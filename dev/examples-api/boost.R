# One point per unit cell. A jitter of at most 0.3 leaves a gap of at least 0.4.
cells <- expand.grid(x = seq_len(800) - 0.5, y = seq_len(625) - 0.5)
set.seed(42)
xy <- round(
  cbind(
    cells$x + runif(nrow(cells), -0.3, 0.3),
    cells$y + runif(nrow(cells), -0.3, 0.3)
  ),
  3
)

highchart() |>
  hc_title(text = "A cloud of 500,000 points") |>
  hc_subtitle(text = "Drag to zoom in and see the spacing between samples.") |>
  hc_chart(zooming = list(type = "xy")) |>
  hc_xAxis(min = 0, max = 800, title = list(text = "x")) |>
  hc_yAxis(min = 0, max = 625, endOnTick = FALSE, title = list(text = "y")) |>
  hc_add_series(
    data = xy,
    type = "scatter",
    name = "Samples",
    marker = list(symbol = "circle", radius = 0.5),
    color = "rgba(48, 103, 162, 0.22)",
    boostThreshold = 1000,
    showInLegend = FALSE
  ) |>
  hc_tooltip(pointFormat = "x = {point.x:.3f}<br/>y = {point.y:.3f}") |>
  hc_boost(enabled = TRUE)
