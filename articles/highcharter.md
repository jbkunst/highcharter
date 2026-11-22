# Highcharter

## Highcharts

let us start start with a simple example using `hchart` function.

``` r

library(highcharter)

hchart(
  palmerpenguins::penguins,
  "scatter",
  hcaes(x = flipper_length_mm, y = bill_length_mm, group = species)
)
```

Among its features {highcharter} can chart various objects depending of
its class with the generic `hchart` function. In the next example `x` is
numeric:

``` r

x <- c(rnorm(10000), rnorm(1000, 4, 0.5))

hchart(x, name = "data", color = "#17b8b6")
```

One of the nicest class which `hchart` can plot is the `forecast` class
from the {forecast} package.

``` r

library(forecast)

airforecast <- forecast(auto.arima(AirPassengers), level = 95)

hchart(airforecast)
```

See more examples of `hchart` in
[`vignette("hchart")`](https://jkunst.com/highcharter/articles/hchart.md).

## Highstock

With {highcharter} you can use the highstock library which include
sophisticated navigation options like:

- Small navigator series
- Preset date ranges
- Date picker
- Scrolling and panning.

It is easy make candlesticks or ohlc charts using time series data. For
example, using data from [{quantmod}](http://www.quantmod.com/) package:

``` r

library(quantmod)

data(sample_matrix, package = "xts")
x <- xts::as.xts(sample_matrix)

highchart(type = "stock") |>
  hc_add_series(x, name = "Sample prices")
```

## Highmaps

We can chart maps elements and choropleth using the highmaps and build
interactive maps to display data linked to geographic objects.

``` r

palette <- c("#000004", "#56106E", "#BB3754", "#F98C0A", "#FCFFA4")

hcmap(
  "custom/world-robinson-lowres",
  data = subset(world_income, year == 2024),
  value = "gni_per_capita",
  joinBy = c("iso-a3", "iso3"),
  name = "GNI per capita",
  borderWidth = 0.2
) |>
  hc_title(text = "Gross national income per capita, 2024") |>
  hc_colorAxis(
    type = "logarithmic",
    stops = color_stops(colors = palette)
  ) |>
  hc_tooltip(valuePrefix = "$", valueDecimals = 0)
```

## What now?

Since you know the basics now it could be interesting:

- Go motivate yourself with the
  [`vignette("showcase")`](https://jkunst.com/highcharter/articles/showcase.md)
  and look everything that can be done with the {highcharter} package.
- Learn to configure graphics using the implemented API in
  [`vignette("highcharts-api")`](https://jkunst.com/highcharter/articles/highcharts-api.md).
- Explore [chart
  types](https://jkunst.com/highcharter/articles/chart-types.md) and
  their R examples.
