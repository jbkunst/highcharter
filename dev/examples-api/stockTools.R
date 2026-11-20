data(sample_matrix, package = "xts")

# Show the full Stock Tools toolbar by default.
price_chart <- highchartstock() |>
  hc_add_series(xts::as.xts(sample_matrix), name = "Price", id = "price")
price_chart

# You can show only selected buttons, in the order specified.
price_chart |>
  hc_stockTools(
    gui = list(buttons = c("indicators", "zoomChange", "fullScreen"))
  )
