# Show just the zoom and fullscreen controls in the Stock Tools toolbar.
highchartstock() |>
  hc_add_series(AirPassengers, name = "Passengers") |>
  hc_stockTools(gui = list(enabled = TRUE, buttons = c("zoomChange", "fullScreen")))
