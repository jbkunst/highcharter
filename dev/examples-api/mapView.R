# Keep the coastline for context while focusing on two nearby cities.
hcmap("cl", showInLegend = FALSE) |>
  hc_title(text = "Santiago and Valpara\u00edso") |>
  hc_add_series(
    type = "mappoint",
    name = "Cities",
    dataLabels = list(enabled = TRUE, format = "{point.name}"),
    data = list(
      list(name = "Santiago", lon = -70.67, lat = -33.45),
      list(name = "Valpara\u00edso", lon = -71.62, lat = -33.05)
    )
  ) |>
  hc_mapView(
    projection = list(name = "WebMercator"),
    center = c(-71.1, -33.3),
    zoom = 7
  )
