# Each row becomes a compact [x, y] pair.
set.seed(42)
xy <- round(cbind(runif(10000), runif(10000)), 3)

highchart() |>
  hc_title(text = "A cloud of 10,000 points") |>
  hc_subtitle(text = "Drag a rectangle to zoom in on the point cloud.") |>
  hc_chart(zooming = list(type = "xy")) |>
  hc_xAxis(min = 0, max = 1, title = list(text = "x")) |>
  hc_yAxis(min = 0, max = 1, title = list(text = "y")) |>
  hc_add_series(
    data = xy,
    type = "scatter",
    name = "Samples",
    marker = list(symbol = "circle", radius = 1),
    color = "rgba(48, 103, 162, 0.65)",
    boostThreshold = 1000,
    showInLegend = FALSE
  ) |>
  hc_tooltip(pointFormat = "x = {point.x:.3f}<br/>y = {point.y:.3f}") |>
  hc_boost(enabled = TRUE)
