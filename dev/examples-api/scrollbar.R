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
  hc_rangeSelector(selected = 0) |>
  hc_scrollbar(
    height = 20,
    minWidth = 24,
    barBackgroundColor = "#31688E",
    barBorderRadius = 7,
    barBorderWidth = 0,
    buttonBackgroundColor = "#E5F0F5",
    buttonBorderWidth = 0,
    buttonArrowColor = "#31688E",
    trackBackgroundColor = "#F5FAFC",
    trackBorderColor = "#D5E3E8"
  )
