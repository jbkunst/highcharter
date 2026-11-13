# From the repository root: Rscript dev/generate-highcharts-api.R
generate_api <- function() {
  bundle <- "dev/highcharts-bundle"
  package <- file.path(bundle, "node_modules", "highcharts")
  manifest <- file.path(package, "package.json")
  pinned <- jsonlite::read_json(file.path(bundle, "package.json"))$devDependencies$highcharts
  if (!file.exists(manifest) || !identical(jsonlite::read_json(manifest)$version, pinned)) {
    status <- system2("npm", c("ci", "--prefix", bundle))
    stopifnot("npm ci failed" = status == 0L)
  }
  stopifnot("Unexpected Highcharts version" = identical(jsonlite::read_json(manifest)$version, pinned))
  dts <- readLines(file.path(package, "highcharts.d.ts"), encoding = "UTF-8")
  start <- which(dts == "export interface Options {")
  stopifnot("Expected one Highcharts.Options interface" = length(start) == 1L)
  end <- start + match("}", dts[-seq_len(start)])
  lines <- trimws(dts[seq.int(start + 1L, end - 1L)])
  properties <- grep("^[[:alpha:]][[:alnum:]]*\\??:", lines)
  names(properties) <- sub("\\??:.*", "", lines[properties])
  stopifnot(length(properties) > 0L, !anyDuplicated(names(properties)))
  # These have a session-level API. The remaining groups configure a widget.
  groups <- setdiff(names(properties), c("global", "lang"))
  examples <- list.files("dev/examples-api", pattern = "\\.R$")
  documented <- tools::file_path_sans_ext(examples)
  added <- setdiff(groups, documented)
  removed <- setdiff(documented, groups)
  if (length(added) || length(removed)) {
    changes <- list(highcharts = jsonlite::unbox(pinned),
                    missing_examples = added, obsolete_examples = removed)
    stop("Review the API changes before generating:\n", jsonlite::toJSON(changes, pretty = TRUE))
  }

  # Preserve the two public signatures with R-specific behavior.
  special <- list(
    colors = function(hc, colors) {
      assertthat::assert_that(is.vector(colors))
      if (length(colors) == 1L) colors <- list(colors)
      hc$x$hc_opts$colors <- colors
      hc
    },
    tooltip = function(hc, ..., sort = FALSE, table = FALSE) {
      if (sort) hc <- .hc_tooltip_sort(hc)
      if (table) hc <- .hc_tooltip_table(hc)
      if (length(list(...))) hc <- .hc_opt(hc, "tooltip", ...)
      hc
    }
  )
  products <- c(Highcharts = "highcharts", Highstock = "highstock", Highmaps = "highmaps", Gantt = "gantt")
  render_wrapper <- function(group) {
    i <- properties[[group]]
    if (i > 2L && lines[i - 1L] == "*/") {
      opener <- tail(which(lines[seq_len(i - 2L)] == "/**"), 1L)
      stopifnot(length(opener) == 1L)
      description <- sub("^\\* ?", "", lines[seq.int(opener + 1L, i - 2L)])
      product <- sub("^\\(([^,)]+).*", "\\1", description[1L])
      stopifnot("Unknown documentation product" = product %in% names(products))
      description[1L] <- sub("^\\([^)]*\\) ?", "", description[1L])
      # The declarations use empty link targets where the online docs use links.
      description <- gsub("\\[([^]]+)\\]\\(\\)", "\\1", description)
      description <- trimws(gsub(" ?\\(see online documentation for example\\)", "", description))
    } else if (group == "sonification") {
      product <- "Highcharts"
      description <- "Play chart data as sound. Set the playback duration, instruments and volume."
    } else {
      stop("Missing documentation for Highcharts.Options.", group)
    }
    url <- sprintf("https://api.highcharts.com/%s/%s", products[[product]], group)
    parameters <- if (group == "colors") {
      c("@param colors A vector of series colors.", sprintf("@seealso <%s>", url))
    } else {
      sprintf("@param ... Options defined in <%s>.", url)
    }
    if (group == "tooltip") {
      parameters <- c(parameters, "@param sort Sort shared tooltip points by descending value.",
                      "@param table Display the shared tooltip as an HTML table.")
    }
    docs <- c(paste(tools::toTitleCase(group), "options for highcharter objects"), "", description, "",
              "@param hc A `highchart` `htmlwidget` object.", parameters,
              paste0("@example dev/examples-api/", group, ".R"), "@export")
    fn <- if (group %in% names(special)) {
      trimws(deparse(special[[group]], width.cutoff = 100L, control = "keepInteger"), which = "right")
    } else {
      c("function(hc, ...) {", sprintf('  .hc_opt(hc, "%s", ...)', group), "}")
    }
    fn[1L] <- paste0("hc_", group, " <- ", fn[1L])
    c(ifelse(nzchar(docs), paste("#'", docs), "#'"), fn, "")
  }
  output <- c(sprintf("# Generated from Highcharts %s by dev/generate-highcharts-api.R", pinned),
              "", unlist(lapply(groups, render_wrapper), use.names = FALSE))

  # Load and document a candidate package so helpers, S3 methods and examples
  # all resolve against the same source, including newly generated exports.
  stage <- tempfile("highcharter-api-")
  dir.create(stage)
  on.exit(unlink(stage, recursive = TRUE), add = TRUE)
  stopifnot(all(file.copy(c("DESCRIPTION", "NAMESPACE", "R", "data", "inst", "man"), stage, recursive = TRUE)))
  dir.create(file.path(stage, "dev"))
  stopifnot(file.copy("dev/examples-api", file.path(stage, "dev"), recursive = TRUE))
  target <- "R/highcharts-api.R"
  writeLines(output, file.path(stage, target))
  message("Highcharts ", pinned, ": ", length(groups), " chart options. Session options: global, lang.")
  roxygen2::roxygenise(stage, roclets = c("namespace", "rd"))
  pkgload::load_all(stage, export_all = FALSE, helpers = FALSE, quiet = TRUE)
  for (group in groups) {
    message("Checking hc_", group)
    env <- new.env(parent = globalenv())
    example <- file.path("dev/examples-api", paste0(group, ".R"))
    chart <- source(example, local = env)$value
    if (!is.highchart(chart) || is.null(chart$x$hc_opts[[group]])) {
      stop(example, " must return a chart with its ", group, " option configured.")
    }
  }

  files <- c(target, "NAMESPACE", file.path("man", paste0("hc_", groups, ".Rd")))
  stopifnot(all(file.exists(file.path(stage, files))))
  for (file in files) {
    from <- file.path(stage, file)
    if (!file.exists(file) || unname(tools::md5sum(from)) != unname(tools::md5sum(file))) {
      stopifnot(file.copy(from, file, overwrite = TRUE))
    }
  }
  message("Validated ", length(groups), " examples. Updated ", target, ", NAMESPACE and API help.")
}
generate_api()
