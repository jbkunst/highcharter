# Choose Play as sound in the export menu to hear the series.
highchart() |>
  hc_add_series(name = "Orders", data = c(12, 18, 15, 24)) |>
  hc_exporting(enabled = TRUE, buttons = list(contextButton = list(menuItems = list("playAsSound")))) |>
  hc_sonification(enabled = TRUE, duration = 1500, masterVolume = 0.4)
