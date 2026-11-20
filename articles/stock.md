# Stock charts and Stock Tools

`highchart(type = "stock")` adds the Stock navigator and range selector.
Use
[`highchartstock()`](https://jkunst.com/highcharter/reference/highchartstock.md)
when readers also need drawing tools and technical indicators. The
introductory examples use the xts package’s sample OHLC matrix; the
closing dashboard restores the SPY example with a local historical
snapshot.

``` r

data(sample_matrix, package = "xts")
prices <- xts::as.xts(sample_matrix)
hchart(prices, id = "price", name = "Sample instrument")
```

## Lines and price bars

One ordinary column produces a line. All four price fields together
produce candles. Use `type = "ohlc"` for open–high–low–close bars.

``` r

hchart(prices[, "Close"], name = "Close")
```

``` r

hchart(prices, type = "ohlc", name = "Sample instrument")
```

## Flags, navigator and indicators

The flag and moving average select the price series by ID. The range
selector and navigator act on the same time axis. The full Stock Tools
toolbar is enabled by default. Use **Indicators** to add a moving
average, or **Type change** to switch the price series between
candlesticks and OHLC bars.

``` r

price_chart <- highchartstock() |>
  hc_add_series(prices, name = "Price", id = "price") |>
  hc_add_series(
    type = "sma",
    linkedTo = "price",
    name = "10-day mean",
    params = list(period = 10)
  ) |>
  hc_add_series(
    type = "flags",
    onSeries = "price",
    data = list(
      list(
        x = datetime_to_timestamp(time(prices)[30]),
        title = "A",
        text = "Day 30"
      )
    )
  ) |>
  hc_navigator(enabled = TRUE)

price_chart
```

## Two stacked panels

The price and the daily trading range have separate scales. Their
heights are in the ratio 3 to 1. The panels share the time axis.

``` r

daily_range <- prices[, "High"] - prices[, "Low"]
highchart(type = "stock") |>
  hc_yAxis(create_axis(2, heights = c(3, 1))) |>
  hc_add_series(prices, name = "Price", yAxis = 0) |>
  hc_add_series(
    daily_range,
    name = "High minus low",
    type = "column",
    yAxis = 1
  )
```

## Update a series and its visible range in Shiny

The app opens with the last trading close of each week from the local
2025 SPY snapshot. Press **Explore April**, choose **1m** or drag the
navigator to a window of six weeks or less. The x-axis sends its new
limits to Shiny, and the proxy replaces the visible series with daily
closes for that interval. Choose **All** to return to weekly closes. The
navigator keeps its original weekly overview as the main series changes.
[Run the Stock app](https://jkunst.com/highcharter/live/stock/index.md).

``` r

library(highcharter)
library(shiny)

snapshot <- read.csv(system.file(
  "extdata",
  "spy-2025.csv",
  package = "highcharter"
))
daily <- data.frame(day = as.Date(snapshot$date), close = snapshot$SPY.Close)
weekly <- daily[!duplicated(cut(daily$day, "week"), fromLast = TRUE), ]

ui <- fluidPage(
  p(
    "View up to six weeks for daily closing prices. Zoom out to see weekly closes."
  ),
  actionButton("april", "Explore April"),
  highchartOutput("prices")
)

server <- function(input, output, session) {
  output$prices <- renderHighchart({
    highchart(type = "stock") |>
      hc_title(text = "SPY closing price, 2025") |>
      hc_legend(enabled = TRUE) |>
      hc_xAxis(
        id = "days",
        ordinal = FALSE,
        minRange = 7 * 86400000,
        events = list(
          afterSetExtremes = JS(
            "function (e) {
              if (e.trigger !== 'updatedData') {
                Shiny.setInputValue('prices_range', [e.min, e.max]);
              }
            }"
          )
        )
      ) |>
      hc_navigator(adaptToUpdatedData = FALSE) |>
      hc_rangeSelector(
        selected = 1,
        buttons = list(
          list(type = "month", count = 1, text = "1m"),
          list(type = "all", text = "All")
        )
      ) |>
      hc_add_series(
        weekly,
        "line",
        hcaes(day, close),
        id = "closing",
        name = "Weekly close",
        dataGrouping = list(enabled = FALSE)
      ) |>
      hc_tooltip(valueDecimals = 2, valuePrefix = "$")
  })

  observeEvent(input$april, {
    highchartProxy("prices", session) |>
      hcpxy_set_extremes(
        as.Date("2025-04-01"),
        as.Date("2025-04-30"),
        axis = "days"
      )
  })

  observeEvent(input$prices_range, {
    days <- as.Date(
      unlist(input$prices_range) / 86400000,
      origin = "1970-01-01"
    )
    detail <- as.numeric(diff(days)) <= 42
    prices <- if (detail) {
      subset(daily, day >= days[1] & day <= days[2])
    } else {
      weekly
    }
    highchartProxy("prices", session) |>
      hcpxy_set_data("line", prices, hcaes(day, close), id = "closing") |>
      hcpxy_update_series(
        id = "closing",
        name = if (detail) "Daily close" else "Weekly close"
      )
  })
}

shinyApp(ui, server)
```

## Price, moving averages, volume and momentum

The earlier advanced example combined SPY prices, two moving averages,
trading volume and RSI, including its 30/70 guide levels. This version
uses a local snapshot of 2025 daily prices from Yahoo Finance, so
rendering does not depend on a live quote request.
[`adjustOHLC()`](https://rdrr.io/pkg/quantmod/man/adjustOHLC.html)
adjusts the price fields using the downloaded adjusted close; volume
remains the reported daily volume.

``` r

snapshot <- read.csv(system.file(
  "extdata",
  "spy-2025.csv",
  package = "highcharter"
))
SPY <- xts::xts(snapshot[-1], order.by = base::as.Date(snapshot$date))
SPY <- quantmod::adjustOHLC(SPY, use.Adjusted = TRUE)
close <- quantmod::Cl(SPY)
fast_mean <- TTR::SMA(close, n = 5)
slow_mean <- TTR::SMA(close, n = 100)
momentum <- TTR::RSI(close, n = 14)
sell_level <- xts::xts(rep(70, NROW(SPY)), order.by = time(SPY))
buy_level <- xts::xts(rep(30, NROW(SPY)), order.by = time(SPY))

highchart(type = "stock") |>
  hc_rangeSelector(selected = 1) |>
  hc_title(text = "SPY: price, volume and momentum in 2025") |>
  hc_yAxis(create_axis(3, heights = c(3, 1, 1), turnopposite = TRUE)) |>
  hc_add_series(SPY, yAxis = 0, name = "SPY", id = "instrument") |>
  hc_add_series(fast_mean, yAxis = 0, name = "5-day mean") |>
  hc_add_series(slow_mean, yAxis = 0, name = "100-day mean") |>
  hc_add_series(
    quantmod::Vo(SPY),
    yAxis = 1,
    name = "Volume",
    type = "column"
  ) |>
  hc_add_series(momentum, yAxis = 2, name = "RSI (14)") |>
  hc_add_series(
    sell_level,
    yAxis = 2,
    name = "RSI 70",
    dashStyle = "ShortDash",
    color = "#94A3B8",
    lineWidth = 1,
    showInLegend = FALSE,
    enableMouseTracking = FALSE
  ) |>
  hc_add_series(
    buy_level,
    yAxis = 2,
    name = "RSI 30",
    dashStyle = "ShortDash",
    color = "#94A3B8",
    lineWidth = 1,
    showInLegend = FALSE,
    enableMouseTracking = FALSE
  ) |>
  hc_yAxis(title = list(text = "Price")) |>
  hc_tooltip(valueDecimals = 2, shared = TRUE) |>
  hc_size(height = 720)
```
