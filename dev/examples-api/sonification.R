# Choose Play as sound in the export menu to hear the series.
highcharts_demo() |>
  hc_exporting(
    enabled = TRUE,
    buttons = list(contextButton = list(menuItems = list("playAsSound")))
  ) |>
  hc_sonification(enabled = TRUE, duration = 5000, masterVolume = 0.4)
