# Explore individual months without losing the full-year overview.
highcharts_demo() |>
  hc_chart(
    zooming = list(type = "x"),
    panning = list(enabled = TRUE, type = "x"),
    panKey = "shift"
  ) |>
  hc_subtitle(text = "Drag to zoom; hold Shift and drag to pan")
