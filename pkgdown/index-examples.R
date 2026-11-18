build_home_gallery <- function(output_dir) {
  article_code <- tempfile("home-vignette-", fileext = ".R")
  knitr::purl(
    "vignettes/from-data-to-charts.Rmd",
    output = article_code,
    documentation = 0L,
    quiet = TRUE
  )
  tryCatch(
    sys.source(article_code, envir = environment()),
    finally = unlink(article_code)
  )

  executor <- paste(
    readLines(
      system.file("examples", "grid-sequence.js", package = "highcharter"),
      encoding = "UTF-8"
    ),
    collapse = "\n"
  )
  # A wide grid and common playback controls
  css <- "
body { margin: 0; background: white; }
.transition-grid-page { max-width: 1200px; margin: auto; padding: 12px;
  font: 300 14px/1.6 'IBM Plex Sans', sans-serif; color: #666; }
.transition-grid { display: grid; grid-template-columns: repeat(2,minmax(0,1fr)); gap: 20px 24px; }
.transition-panel { min-width: 0; }
.grid-controls { display: flex; flex-wrap: wrap; justify-content: center; gap: 10px;
  margin-top: 24px; }
.grid-controls button,.grid-controls select { padding: 7px 18px; font: inherit; cursor: pointer;
  border: 1px solid #ddd; border-radius: 22px; background: #fff; color: #47475c; }
.grid-controls select { appearance: none; padding-right: 38px;
  background-image: url('data:image/svg+xml,%3Csvg xmlns=%27http://www.w3.org/2000/svg%27 viewBox=%270 0 16 16%27%3E%3Cpath d=%27M3 6l5 5 5-5%27 fill=%27none%27 stroke=%27%2347475c%27 stroke-width=%271.8%27 stroke-linecap=%27round%27 stroke-linejoin=%27round%27/%3E%3C/svg%3E');
  background-repeat: no-repeat; background-position: right 12px center;
  background-size: 12px 12px; }
.grid-controls .grid-play { background: #47475c; color: #fff; }
@media(max-width:720px) { .transition-grid { grid-template-columns:1fr; } }
"
  grid <- htmltools::browsable(htmltools::tagList(
    htmltools::tags$head(htmltools::tags$title(
      "Highcharter: a world of contrasts"
    )),
    htmltools::tags$style(htmltools::HTML(css)),
    chart_player(
      countries = country_widgets,
      history = trade_widgets,
      map = map_widgets,
      pie = share_widgets
    )
  ))
  dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
  htmltools::save_html(
    grid,
    file.path(output_dir, "home-gallery.html"),
    libdir = "home-gallery-lib"
  )
  utils::write.csv(
    countries,
    file.path(output_dir, "home-data.csv"),
    row.names = FALSE,
    fileEncoding = "UTF-8"
  )
}
