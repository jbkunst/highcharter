# Format R chunks with Air while preserving Markdown and chunk headers.
# Run from the repository root; AIR can name an executable outside PATH.
args <- commandArgs(trailingOnly = TRUE)
check <- "--check" %in% args
air <- Sys.getenv("AIR", unname(Sys.which("air")))
if (!nzchar(air)) {
  stop("Air was not found. Add it to PATH or set the AIR environment variable.")
}

work <- tempfile("air-vignettes-")
dir.create(work)
work <- normalizePath(work, winslash = "/", mustWork = TRUE)
stopifnot(dirname(work) == normalizePath(tempdir(), winslash = "/"))
input <- file.path(work, "input.R")
output <- file.path(work, "output.R")
errors <- file.path(work, "errors.txt")
chunks <- 0L
changed <- character()
formatted <- list()

tryCatch(
  {
    files <- list.files(
      "vignettes",
      "\\.[Rr]md$",
      recursive = TRUE,
      full.names = TRUE
    )
    for (file in files) {
      lines <- readLines(file, warn = FALSE, encoding = "UTF-8")
      result <- character()
      i <- 1L
      while (i <= length(lines)) {
        fence <- regmatches(
          lines[i],
          regexec("^([ \t]*)(`{3,}|~{3,})(.*)$", lines[i])
        )[[1L]]
        if (!length(fence)) {
          result <- c(result, lines[i])
          i <- i + 1L
          next
        }
        close <- sprintf(
          "^[ \\t]*%s{%d,}[ \\t]*$",
          substr(fence[3L], 1L, 1L),
          nchar(fence[3L])
        )
        j <- i + 1L
        while (j <= length(lines) && !grepl(close, lines[j])) {
          j <- j + 1L
        }
        if (j > length(lines)) {
          stop("Unclosed code fence in ", file, ":", i)
        }
        info <- trimws(fence[4L])
        is_r <- grepl("^\\{r([ ,}]|$)", info) || info %in% c("r", "R")
        if (!is_r || j == i + 1L) {
          result <- c(result, lines[i:j])
        } else {
          code <- sub(
            paste0("^", fence[2L]),
            "",
            lines[seq.int(i + 1L, j - 1L)]
          )
          writeLines(code, input, useBytes = TRUE)
          status <- system2(
            air,
            c(
              "format",
              "--stdin-file-path",
              shQuote(file.path(dirname(file), "chunk.R"))
            ),
            stdin = input,
            stdout = output,
            stderr = errors
          )
          if (status != 0L) {
            stop(
              file,
              ":",
              i,
              "\n",
              paste(readLines(errors, warn = FALSE), collapse = "\n")
            )
          }
          code <- readLines(output, warn = FALSE, encoding = "UTF-8")
          code[nzchar(code)] <- paste0(fence[2L], code[nzchar(code)])
          result <- c(result, lines[i], code, lines[j])
          chunks <- chunks + 1L
        }
        i <- j + 1L
      }
      if (!identical(result, lines)) {
        changed <- c(changed, file)
        formatted[[file]] <- result
      }
    }
    if (check && length(changed)) {
      stop("Air would reformat: ", paste(changed, collapse = ", "))
    }
    if (!check) {
      for (file in changed) {
        writeLines(formatted[[file]], file, useBytes = TRUE)
      }
    }
    message(
      "Air checked ",
      chunks,
      " R chunks in ",
      length(files),
      " vignettes; ",
      length(changed),
      " files ",
      if (check) "need changes." else "formatted."
    )
  },
  finally = unlink(work, recursive = TRUE)
)
