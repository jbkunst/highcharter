# The gallery uses the webR binary from CI or a portable local build.
build_shiny_gallery <- function(site_dir) {
  work <- tempfile("highcharter-gallery-")
  dir.create(work)
  on.exit(unlink(work, recursive = TRUE))
  binary <- Sys.getenv("HIGHCHARTER_WASM_PACKAGE")
  if (nzchar(binary) && !file.exists(binary)) {
    stop("Missing highcharter webR package: ", binary)
  }

  app <- file.path(work, "app")
  dir.create(app)
  # Shinylive exposes its shared webR asset URL as .base_url in the worker.
  # Each iframe can fetch the same archive under any pkgdown URL prefix.
  archive <- file.path(
    normalizePath(site_dir),
    "shinylive",
    "webr",
    "highcharter.tar.gz"
  )
  # Shinylive discovers these imports before the example starts. Keep its
  # dependency scan away from the CRAN release of highcharter.
  write.dcf(
    cbind(
      Package = "galleryapp",
      Imports = paste("shiny,", read.dcf("DESCRIPTION")[1, "Imports"])
    ),
    file.path(app, "DESCRIPTION")
  )
  writeLines(
    c(
      'dir.create("library", showWarnings = FALSE)',
      'archive <- tempfile()',
      'utils::download.file(paste0(.base_url, "highcharter.tar.gz"), archive, mode = "wb", quiet = TRUE)',
      'utils::untar(archive, exdir = "library", tar = "internal")',
      '.libPaths(c(normalizePath("library"), .libPaths()))',
      'source("example.txt", local = TRUE)$value'
    ),
    file.path(app, "app.R")
  )

  examples <- c(
    list.dirs("pkgdown/shiny", recursive = FALSE),
    "inst/examples/theme"
  )
  for (example in examples) {
    stopifnot(file.copy(
      file.path(example, "app.R"),
      file.path(app, "example.txt"),
      overwrite = TRUE
    ))
    shinylive::export(
      app,
      site_dir,
      subdir = file.path("live", basename(example)),
      # This release ships webR 0.6.0, also pinned in pkgdown.yaml.
      assets_version = "0.10.12",
      wasm_packages = FALSE
    )
  }
  if (nzchar(binary)) {
    stopifnot(file.copy(binary, archive, overwrite = TRUE))
  } else {
    lib <- file.path(work, "library")
    dir.create(lib)
    pkg <- "highcharter"
    utils::install.packages(
      normalizePath("."),
      repos = NULL,
      type = "source",
      lib = lib,
      INSTALL_opts = c("--no-byte-compile", "--no-test-load")
    )
    installed <- file.path(lib, pkg)
    stopifnot(
      file.exists(file.path(installed, "Meta", "package.rds")),
      !dir.exists(file.path(installed, "libs"))
    )
    withr::with_dir(
      lib,
      utils::tar(archive, files = pkg, compression = "gzip", tar = "internal")
    )
  }
  # Preserve bookmarks to the original iris app.
  writeLines(
    '<meta http-equiv="refresh" content="0; url=basic/">',
    file.path(site_dir, "live", "index.html")
  )
}

build_shiny_gallery(site_dir)
