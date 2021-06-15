#' @importFrom stats runif
.join_hc_opts <- function() {
  list(
    global = getOption("highcharter.global"),
    lang = getOption("highcharter.lang"),
    chart = getOption("highcharter.chart")
  )
}

.onAttach <- function(libname = find.package("highcharter"),
                      pkgname = "highcharter") {
  if (stats::runif(1) <= 1 / 3) {
    packageStartupMessage("Highcharts (www.highcharts.com) is a Highsoft software product which is")

    packageStartupMessage("not free for commercial and Governmental use")
  }
}

.onLoad <- function(libname = find.package("highcharter"),
                    pkgname = "highcharter") {
  options(
    highcharter.global = list(
      Date = NULL,
      VMLRadialGradientURL =
        "http =//code.highcharts.com/list(version)/gfx/vml-radial-gradient.png",
      canvasToolsURL =
        "http =//code.highcharts.com/list(version)/modules/canvas-tools.js",
      getTimezoneOffset = NULL,
      timezoneOffset = 0,
      useUTC = TRUE
    )
  )

  options(
    highcharter.lang = list(
      contextButtonTitle = "Chart context menu",
      decimalPoint = ".",
      downloadCSV = "Download CSV",
      downloadJPEG = "Download JPEG image",
      downloadPDF = "Download PDF document",
      downloadPNG = "Download PNG image",
      downloadSVG = "Download SVG vector image",
      downloadXLS = "Download XLS",
      drillUpText = "\u25C1 Back to {series.name}",
      exitFullscreen = "Exit from full screen",
      exportData = list(
        annotationHeader = "Annotations",
        categoryDatetimeHeader = "DateTime",
        categoryHeader = "Category"
      ),
      hideData = "Hide data table",
      invalidDate = NULL,
      loading = "Loading...",
      months = c(
        "January", "February", "March", "April",
        "May", "June", "July", "August",
        "September", "October", "November", "December"
      ),
      # navigation
      noData = "No data to display",
      numericSymbolMagnitude = 1000,
      numericSymbols = c("k", "M", "G", "T", "P", "E"),
      printChart = "Print chart",
      resetZoom = "Reset zoom",
      resetZoomTitle = "Reset zoom level 1:1",
      shortMonths = c(
        "Jan", "Feb", "Mar", "Apr", "May", "Jun",
        "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
      ),
      shortWeekdays = c("Sat", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri"),
      thousandsSep = " ",
      viewData = "View data table",
      viewFullscreen = "View in full screen",
      weekdays = c(
        "Sunday", "Monday", "Tuesday", "Wednesday",
        "Thursday", "Friday", "Saturday"
      )
    )
  )

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
          # start disabled series-label.js module https://api.highcharts.com/highcharts/plotOptions.series.label
          label = list(enabled = FALSE),
          # this is DUE inteally all data is given as named arrays
          # https://www.highcharts.com/errors/12/
          turboThreshold = 0
        ),
        treemap = list(layoutAlgorithm = "squarified")
      )
    )
  )

  options(
    highcharter.theme = hc_theme(
      chart = list(backgroundColor = "transparent"),
      colors = c(
        "#7cb5ec", "#434348", "#90ed7d", "#f7a35c", "#8085e9",
        "#f15c80", "#e4d354", "#2b908f", "#f45b5b", "#91e8e1"
      )
    ),
    highcharter.verbose = FALSE,
    highcharter.google_fonts = TRUE,
    highcharter.debug = FALSE,
    highcharter.rjson = FALSE,
    highcharter.download_map_data = TRUE,
    highcharter.color_palette = c(
      "#7cb5ec", "#434348", "#90ed7d", "#f7a35c", "#8085e9",
      "#f15c80", "#e4d354", "#2b908f", "#f45b5b", "#91e8e1"
    )
  )
}
