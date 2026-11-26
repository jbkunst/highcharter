# Daily SPY closing prices included with the package; no download needed.
prices <- read.csv(system.file(
  "extdata",
  "spy-2025.csv",
  package = "highcharter"
))
close <- xts::xts(prices$SPY.Close, order.by = as.Date(prices$date))

highchart(type = "stock") |>
  hc_add_series(close, name = "SPY") |>
  hc_title(text = "SPY daily closing prices in 2025") |>
  hc_yAxis(title = list(text = "Price (USD)")) |>
  hc_tooltip(valueDecimals = 2, valuePrefix = "$") |>
  hc_rangeSelector(
    verticalAlign = "bottom",
    selected = 3,
    buttons = list(
      list(type = "month", count = 1, text = "1m"),
      list(type = "month", count = 3, text = "3m"),
      list(type = "month", count = 6, text = "6m"),
      list(type = "all", text = "All")
    )
  )
