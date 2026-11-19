.onAttach <- function(libname, pkgname) {
  if (interactive()) {
    packageStartupMessage("Highcharts JS licensing: see ?highcharter.")
  }
}

.onLoad <- function(
  libname = find.package("highcharter"),
  pkgname = "highcharter"
) {
  if (is.null(getOption("highcharter.lang"))) {
    hc_set_language("en")
  }

  options(
    highcharter.chart = list(
      chart = list(
        reflow = TRUE
      ),
      title = list(
        text = NULL
      ),
      yAxis = list(
        title = list(
          text = NULL
        )
      ),
      credits = list(
        enabled = FALSE
      ),
      exporting = list(
        enabled = FALSE
      ),
      boost = list(
        enabled = FALSE
      ),
      plotOptions = list(
        series = list(
          label = list(enabled = FALSE),
          # Preserve mixed point formats in long OHLC and range series.
          turboThreshold = 0
        ),
        treemap = list(layoutAlgorithm = "squarified")
      )
    )
  )

  default_theme <- hc_theme(
    chart = list(backgroundColor = "transparent"),
    colors = c(
      "#7cb5ec",
      "#434348",
      "#90ed7d",
      "#f7a35c",
      "#8085e9",
      "#f15c80",
      "#e4d354",
      "#2b908f",
      "#f45b5b",
      "#91e8e1"
    )
  )
  options(
    highcharter.theme = getOption("highcharter.theme", default_theme),
    highcharter.verbose = FALSE,
    highcharter.debug = FALSE,
    highcharter.download_map_data = TRUE,
    highcharter.color_palette = default_theme$colors
  )
}
