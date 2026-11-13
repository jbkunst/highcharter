# Run from the repository root after npm ci --prefix dev/highcharts-bundle.
bundle <- "dev/highcharts-bundle"
package <- file.path(bundle, "node_modules", "highcharts")
pinned <- jsonlite::read_json(file.path(bundle, "package.json"))$devDependencies$highcharts
installed <- jsonlite::read_json(file.path(package, "package.json"))$version
stopifnot("Highcharts version differs from the bundle pin" = identical(installed, pinned))

# Only read the title property of the top-level Highcharts.Options interface.
dts <- readLines(file.path(package, "highcharts.d.ts"), encoding = "UTF-8")
start <- which(dts == "export interface Options {")
stopifnot("Expected one Options interface" = length(start) == 1L)
end <- start + match("}", dts[-seq_len(start)])
options <- trimws(dts[seq.int(start + 1L, end - 1L)])
title <- grep("^title\\?: TitleOptions;$", options)
stopifnot("Expected one documented title property" = length(title) == 1L,
          "Missing title documentation" = options[title - 1L] == "*/")
opener <- tail(which(options[seq_len(title - 2L)] == "/**"), 1L)
stopifnot("Missing title documentation" = length(opener) == 1L && opener < title - 2L)
description <- sub("^\\* ?", "", options[seq.int(opener + 1L, title - 2L)])
description[1L] <- sub("^\\([^)]*\\) ", "", description[1L])

example <- "dev/examples-api/title.R"
code <- c(
  sprintf("# Generated from Highcharts %s by dev/generate-highcharts-title.R", pinned),
  "#' Title options for highcharter objects",
  "#'",
  paste("#'", description),
  "#'",
  "#' @param hc A `highchart` `htmlwidget` object.",
  "#' @param ... Arguments defined in \\url{https://api.highcharts.com/highcharts/title}.",
  "#' @examples",
  paste("#'", readLines(example)),
  "#' @export",
  "hc_title <- function(hc, ...) {",
  '  .hc_opt(hc, "title", ...)',
  "}"
)

# Give the example the new wrapper and the package's existing widget helpers.
candidate <- new.env(parent = asNamespace("highcharter"))
eval(parse(text = code), envir = candidate)
chart <- source(example, local = candidate)$value
stopifnot("The title example must return a highchart" = inherits(chart, "highchart"))

writeLines(code, "R/hc-title.R")
