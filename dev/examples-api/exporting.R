# Open the chart menu to download the image or the underlying temperatures.
highcharts_demo() |>
  hc_exporting(
    enabled = TRUE,
    filename = "monthly-city-temperatures",
    buttons = list(contextButton = list(menuItems = c("downloadPNG", "downloadCSV")))
  )
