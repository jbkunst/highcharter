# Stocks with highstocks

The highcharter package include
[highstocks](https://www.highcharts.com/demo/stock) libraries from
highchartsJS to create stock or general timeline charts. Features
sophisticated navigation for high-volume data, user annotations and
range selectors.

## Basics

Highstock work well with the quantmod package. It’s easy chart symbols
using [`hchart()`](https://jkunst.com/highcharter/reference/hchart.md).
Then you can add more series using
[`hc_add_series()`](https://jkunst.com/highcharter/reference/hc_add_series.md).

``` r
library(quantmod)

x <- getSymbols("GOOG", auto.assign = FALSE)

hchart(x)
```

Obviously you can use the implemented API functions to edit the chart:

``` r
y <- getSymbols("AMZN", auto.assign = FALSE)

hchart(y, type = "ohlc") |> 
  hc_title(text = "This is a Open-high-low-close chart with a custom theme") |> 
  hc_add_theme(hc_theme_db())
```

## Candlestick and OHLC charts

If you want to chart more symbols in you can use the
[`hc_add_series()`](https://jkunst.com/highcharter/reference/hc_add_series.md)
function. Don’t forget to specify `type = "stock"` to activate the
navigator, range selector and other features of highstock.

``` r
hc <- highchart(type = "stock") |> 
  hc_add_series(x, id = 1) |> 
  hc_add_series(y, type = "ohlc", id = 2)

hc
```

## Flags

Previously we used the `id` parameter. This is necessary to add flags to
relate series and flags:

``` r
library(dplyr)

set.seed(123)

data_flags <- tibble(
  date = sample(time(x), size = 5),
  title = sprintf("E #%s", seq_along(date)),
  text = sprintf("An interesting event #%s in %s", seq_along(date), date)
)

glimpse(data_flags)
```

    ## Rows: 5
    ## Columns: 3
    ## $ date  <date> 2016-10-12, 2016-12-20, 2015-11-04, 2009-02-03, 2024-01-19
    ## $ title <chr> "E #1", "E #2", "E #3", "E #4", "E #5"
    ## $ text  <chr> "An interesting event #1 in 2016-10-12", "An interesting event …

``` r
hc |> 
  hc_add_series(
    data_flags, 
    hcaes(x = date),
    type = "flags", 
    onSeries = 2
    )
```

## Advanced Example

You can do what you want. Use all the highchartsJS API to add axis,
series, bands, etc.

``` r
SPY <- getSymbols("SPY", from = Sys.Date() - lubridate::years(1), auto.assign = FALSE)
SPY <- adjustOHLC(SPY)

SPY.SMA.10 <- SMA(Cl(SPY), n = 5)
SPY.SMA.200 <- SMA(Cl(SPY), n = 100)
SPY.RSI.14 <- RSI(Cl(SPY))
SPY.RSI.SellLevel <- xts(rep(70, NROW(SPY)), index(SPY))
SPY.RSI.BuyLevel <- xts(rep(30, NROW(SPY)), index(SPY))


highchart(type = "stock") |> 
  # create axis :)
  hc_yAxis_multiples(create_axis(3, height = c(2, 1, 1), turnopposite = TRUE)) |> 
  # series :D
  hc_add_series(SPY, yAxis = 0, name = "SPY") |> 
  hc_add_series(SPY.SMA.10, yAxis = 0, name = "Fast MA") |> 
  hc_add_series(SPY.SMA.200, yAxis = 0, name = "Slow MA") |> 
  hc_add_series(SPY$SPY.Volume, color = "gray", yAxis = 1, name = "Volume", type = "column") |> 
  hc_add_series(SPY.RSI.14, yAxis = 2, name = "Osciallator", color = hex_to_rgba("green", 0.7)) |>
  hc_add_series(SPY.RSI.SellLevel, color = hex_to_rgba("red", 0.7), yAxis = 2, name = "Sell level") |> 
  hc_add_series(SPY.RSI.BuyLevel, color = hex_to_rgba("blue", 0.7), yAxis = 2, name = "Buy level") |> 
  hc_tooltip(valueDecimals = 2) |> 
  hc_size(height = 800)
```
