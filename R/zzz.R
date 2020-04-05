.join_hc_opts <- function() {
  list(
    global = getOption("highcharter.global"),
    lang = getOption("highcharter.lang"),
    chart = getOption("highcharter.chart")
  )
}

.onAttach <- function(libname = find.package("highcharter"),
                      pkgname = "highcharter") {
  packageStartupMessage(
    "Highcharts (www.highcharts.com) is a Highsoft software product which is"
  )
  packageStartupMessage(
    "not free for commercial and Governmental use"
  )
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
      downloadJPEG = "Download JPEG image",
      downloadPDF = "Download PDF document",
      downloadPNG = "Download PNG image",
      downloadSVG = "Download SVG vector image",
      drillUpText = "Back to {series.name}",
      invalidDate = NULL,
      loading = "Loading...",
      months = c(
        "January", "February", "March", "April",
        "May", "June", "July", "August",
        "September", "October", "November", "December"
      ),
      noData = "No data to display",
      numericSymbols = c("k", "M", "G", "T", "P", "E"),
      printChart = "Print chart",
      resetZoom = "Reset zoom",
      resetZoomTitle = "Reset zoom level 1:1",
      shortMonths = c(
        "Jan", "Feb", "Mar", "Apr", "May", "Jun",
        "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
      ),
      thousandsSep = " ",
      weekdays = c(
        "Sunday", "Monday", "Tuesday", "Wednesday",
        "Thursday", "Friday", "Saturday"
      )
    )
  )

  options(
    highcharter.chart = list(
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
      plotOptions = list(
        series = list(
          # start disabled series-label.js module https://api.highcharts.com/highcharts/plotOptions.series.label
          label = list(enabled = FALSE),
          turboThreshold = 0
        ),
        treemap = list(layoutAlgorithm = "squarified")
      )
    )
  )

  options(
    highcharter.theme = hc_theme(chart = list(backgroundColor = "transparent")),
    highcharter.verbose = FALSE,
    highcharter.google_fonts = TRUE,
    highcharter.debug = FALSE,
    highcharter.rjson = FALSE,
    highcharter.download_map_data = TRUE,
    highcharter.color_palette = c(
      "#420A68", "#66166E", "#8B226A", "#AE305C", "#CF4446",
      "#E8602C", "#F8850F", "#FCAF13", "#F5DC4D", "#FCFFA4"
    )
  )
}
