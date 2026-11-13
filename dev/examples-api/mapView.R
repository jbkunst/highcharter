highchart(type = "map") |>
  hc_add_series(type = "mappoint", name = "Cities", data = list(
    list(name = "Santiago", lon = -70.67, lat = -33.45),
    list(name = "Valparaíso", lon = -71.62, lat = -33.05)
  )) |>
  hc_mapView(projection = list(name = "Mercator"), center = c(-71.1, -33.3), zoom = 7)
