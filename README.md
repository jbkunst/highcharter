# highcharter

Highcharter brings Highcharts to R. Turn data frames, time series and statistical
results into interactive visualizations, explore geographic data and create
financial charts with a flexible R interface.

<iframe class="home-gallery" src="home-gallery.html" title="Explore international development through animated charts" loading="lazy"></iframe>

<div class="home-copy">

## Installation

Install from CRAN:

```r
install.packages("highcharter")
```

Or install the development version from GitHub:

```r
remotes::install_github("jbkunst/highcharter")
```

## What's included

One Highcharts bundle brings together Charts, Stock, Maps and Gantt. Choose from
dozens of chart types and combine them with tooltips, zoom, drilldown,
annotations, exporting and accessibility features.

- Chart R objects with `hchart()`: data frames, vectors, time series, forecasts
  and survival models all have a starting point.
- Create choropleths with `hcmap()` and bring your own geographic data.
- Explore financial time series and candlesticks with `highchartstock()`,
  technical indicators and Stock Tools.
- Make charts your own with themes, colors, labels and languages.
- Add interactive charts to Shiny applications and R Markdown documents.

## Where to start

- [First steps](articles/first-steps.html):
  create your first chart from a data frame.
- [`hchart()` guide](articles/hchart.html):
  chart time series, forecasts and other R objects.
- [Showcase](articles/showcase.html):
  discover ideas for customization and chart design.
- [Chart gallery](articles/series-gallery.html):
  find a chart type and its R example.
- [Maps](articles/maps.html) and
  [Stock charts](articles/stock.html):
  explore places and financial time series.
- [Shiny](articles/shiny.html) and
  [accessibility](articles/accessibility.html):
  build interactive experiences for your audience.
- [Function reference](reference/index.html):
  look up helpers and chart options.
- [Highcharts API in R](articles/highcharts-api.html)
  and [JavaScript-to-R guide](articles/highchartsjs-api-basics.html):
  learn how Highcharts options translate to R code.

Try a first chart: pass a data frame to `hchart()`, map columns with `hcaes()`
and add titles and options with the R pipe.

```r
library(highcharter)

hchart(mtcars, "scatter", hcaes(x = wt, y = mpg, group = cyl)) |>
  hc_title(text = "Fuel economy by car weight") |>
  hc_xAxis(title = list(text = "Weight (1,000 lbs)")) |>
  hc_yAxis(title = list(text = "Miles per gallon"))
```

[Source code](https://github.com/jbkunst/highcharter) ·
[Report an issue](https://github.com/jbkunst/highcharter/issues) ·
[Contribute](CONTRIBUTING.md) ·
[Authors and citation](authors.html)

Highcharter is licensed under MIT. Highcharts has its own
[licensing terms](https://www.highcharts.com/license).

</div>
