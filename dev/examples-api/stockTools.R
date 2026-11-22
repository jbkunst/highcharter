prices <- read.csv(system.file(
  "extdata",
  "spy-2025.csv",
  package = "highcharter"
))

# Show the full Stock Tools toolbar by default.
price_chart <- highchartstock() |>
  hc_add_series(
    prices,
    "candlestick",
    hcaes(
      x = as.Date(date),
      open = SPY.Open,
      high = SPY.High,
      low = SPY.Low,
      close = SPY.Close
    ),
    name = "SPY",
    id = "price"
  )
price_chart

# You can show only selected buttons, in the order specified.
price_chart |>
  hc_stockTools(
    gui = list(buttons = c("indicators", "zoomChange", "fullScreen"))
  )
