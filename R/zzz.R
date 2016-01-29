.onLoad <- function(libname = find.package("highcharter"), pkgname = "highcharter") {
  options(highcharter.options = list(
    global = list(
      Date = NULL,
      VMLRadialGradientURL = "http =//code.highcharts.com/list(version)/gfx/vml-radial-gradient.png",
      canvasToolsURL = "http =//code.highcharts.com/list(version)/modules/canvas-tools.js",
      getTimezoneOffset = NULL,
      timezoneOffset = 0,
      useUTC = TRUE
    ),
    lang = list(
      contextButtonTitle = "Chart context menu",
      decimalPoint = ".",
      downloadJPEG = "Download JPEG image",
      downloadPDF = "Download PDF document",
      downloadPNG = "Download PNG image",
      downloadSVG = "Download SVG vector image",
      drillUpText = "Back to {series.name}",
      invalidDate = NULL,
      loading = "Loading...",
      months = c( "January" , "February" , "March" , "April" , "May" , "June" ,
                  "July" , "August" , "September" , "October" , "November" , "December"),
      noData = "No data to display",
      numericSymbols = c( "k" , "M" , "G" , "T" , "P" , "E"),
      printChart = "Print chart",
      resetZoom = "Reset zoom",
      resetZoomTitle = "Reset zoom level 1:1",
      shortMonths = c( "Jan" , "Feb" , "Mar" , "Apr" , "May" , "Jun" ,
                       "Jul" , "Aug" , "Sep" , "Oct" , "Nov" , "Dec"),
      thousandsSep = " ",
      weekdays = c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday")
    ),
    chart = list(
      title = list(
        text = NULL
      ),
      credits = list(
        enabled = FALSE
      ),
      exporting = list(
        enabled = FALSE
      ),
      plotOptions = list(
        series = list(
          turboThreshold = 0
        )
      )
    )
  ))
}
