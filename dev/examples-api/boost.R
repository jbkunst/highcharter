# Send only y values. Highcharts generates the evenly spaced x coordinates.
sample_index <- seq_len(1e6) - 1L
signal <- sin(sample_index / 50000) +
  0.2 * sin(sample_index / 2400) +
  0.04 * sin(sample_index / 40)

highchart() |>
  hc_title(text = "One million samples") |>
  hc_subtitle(
    text = "Drag across the signal to zoom in on its smaller oscillations."
  ) |>
  hc_chart(zooming = list(type = "x")) |>
  hc_xAxis(title = list(text = "Sample index")) |>
  hc_yAxis(title = list(text = "Amplitude")) |>
  hc_add_series(
    data = round(signal, 2),
    type = "line",
    name = "Signal",
    lineWidth = 1,
    boostThreshold = 1000,
    showInLegend = FALSE
  ) |>
  hc_tooltip(valueDecimals = 2) |>
  hc_boost(enabled = TRUE)
