# Use the Boost renderer for a dense line once it reaches 1,000 points.
highchart() |>
  hc_add_series(data = sin(seq(0, 12 * pi, length.out = 2000)), boostThreshold = 1000) |>
  hc_boost(enabled = TRUE)
