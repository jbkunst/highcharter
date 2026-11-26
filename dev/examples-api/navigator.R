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
  hc_rangeSelector(selected = 3) |>
  hc_navigator(
    height = 60,
    outlineColor = "#31688E",
    series = list(
      color = "#31688E",
      type = "areaspline",
      fillOpacity = 0.15
    ),
    handles = list(
      width = 10,
      height = 20,
      backgroundColor = "#E5F0F5",
      borderColor = "#31688E"
    )
  )
