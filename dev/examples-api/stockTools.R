# Start with the full toolbar expanded beside the candlestick chart.
data(sample_matrix, package = "xts")
highchartstock() |>
  hc_add_series(xts::as.xts(sample_matrix), name = "Price", id = "price") |>
  hc_stockTools(gui = list(visible = TRUE))
