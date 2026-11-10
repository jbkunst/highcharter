# From the repository root: Rscript dev/download-highcharts-code.R 12.6.2
update_highcharts <- function(version = NULL) {
  bundle <- normalizePath("dev/highcharts-bundle")
  widgets <- normalizePath("inst/htmlwidgets")
  vendor <- file.path(widgets, "lib", "highcharts")
  npm <- if (.Platform$OS.type == "windows") "npm.cmd" else "npm"

  if (!is.null(version) && !grepl("^[0-9]+\\.[0-9]+\\.[0-9]+([-+][A-Za-z0-9.+-]+)?$", version)) {
    stop("Supply an exact Highcharts release, e.g. 12.6.2.")
  }

  # Resolve and build in isolation so a failed npm install or build leaves the checkout intact.
  stage <- tempfile("highcharts-")
  dir.create(stage)
  previous_dir <- setwd(stage)
  on.exit({
    setwd(previous_dir)
    unlink(stage, recursive = TRUE)
  })
  manifests <- c("package.json", "package-lock.json")
  fs::file_copy(file.path(bundle, c(manifests, "entry.js", "build.mjs")), ".")

  install <- "ci"
  if (!is.null(version)) {
    install <- c("install", "--save-dev", "--save-exact", paste0("highcharts@", version))
  }
  if (system2(npm, install) != 0L) stop("Could not install Highcharts.")
  if (system2(npm, c("run", "build", "--", "highcharter-bundle.js")) != 0L) {
    stop("Could not build the Highcharts bundle.")
  }

  upstream <- file.path("node_modules", "highcharts")
  installed <- jsonlite::read_json(file.path(upstream, "package.json"))$version
  if (!is.null(version) && installed != version) stop("Unexpected Highcharts version: ", installed)
  core <- c("highcharts.js", "highcharts-more.js", "highcharts-3d.js")
  modules <- list.files(file.path(upstream, "modules"), pattern = "\\.js$")
  modules <- modules[!endsWith(modules, ".src.js")]
  assets <- c(core, file.path("modules", modules))
  if (!length(modules) || !all(file.exists(file.path(upstream, assets)))) {
    stop("Incomplete Highcharts distribution: ", installed)
  }

  # In these two manifests the version follows the dependency name. Keep comments and formatting.
  widgets_yaml <- c("highchart.yaml", "highchartzero.yaml")
  for (widget in widgets_yaml) {
    lines <- readLines(file.path(widgets, widget))
    fields <- trimws(lines)
    rows <- which(fields %in% c("- name: highcharts", "- name: highcharts-motion")) + 1L
    if (!("- name: highcharts" %in% fields) || !isTRUE(all(startsWith(fields[rows], "version: ")))) {
      stop("Could not locate the Highcharts dependency version in ", widget)
    }
    lines[rows] <- sub("version: [^ #]+", paste("version:", installed), lines[rows])
    writeLines(lines, widget)
  }

  fs::file_copy(file.path(upstream, assets), file.path(vendor, assets), overwrite = TRUE)
  obsolete <- setdiff(list.files(file.path(vendor, "modules"), pattern = "\\.js$"), modules)
  if (length(obsolete)) fs::file_delete(file.path(vendor, "modules", obsolete))
  fs::file_copy("highcharter-bundle.js", file.path(widgets, "lib"), overwrite = TRUE)
  fs::file_copy(widgets_yaml, widgets, overwrite = TRUE)
  fs::file_copy(manifests, bundle, overwrite = TRUE)
  message("Highcharts ", installed, " ready (bundle and ", length(modules), " standalone modules).")
}

args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 1L) stop("Usage: Rscript dev/download-highcharts-code.R [version]")
update_highcharts(if (length(args)) args[[1L]])
