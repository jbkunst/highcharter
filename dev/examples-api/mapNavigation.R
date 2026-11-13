highchart(type = "map") |>
  hc_add_series(type = "mappoint", data = list(
    list(name = "Tokyo", lon = 139.7, lat = 35.7),
    list(name = "Osaka", lon = 135.5, lat = 34.7)
  )) |>
  hc_mapNavigation(enabled = TRUE, enableMouseWheelZoom = FALSE)
