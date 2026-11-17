# highcharter

Bring your data to life with interactive charts, maps and financial dashboards
in R. Highcharter combines the power of Highcharts with a familiar R workflow:
start with your data, choose a chart and make it your own.

<iframe class="home-gallery" src="home-gallery.html" title="Explore international development through animated charts" loading="lazy"></iframe>

<div class="home-copy">

## Installation

Install the released version from CRAN:

```r
install.packages("highcharter")
```

Try the development version with the unified Highcharts bundle:

```r
remotes::install_github("jbkunst/highcharter", ref = "feat/highcharts-bundle")
```

## One bundle, a world of charts

Go from a scatter plot to an interactive world map or a market dashboard.
One shared Highcharts bundle brings together Charts, Stock, Maps and Gantt,
with dozens of chart types ready to explore.

- **Explore your data:** zoom, drill down and discover details in rich tooltips.
- **Tell your story:** combine series, add annotations and customize colors,
  themes and languages.
- **Follow the markets:** use `highchartstock()` for financial time series,
  technical indicators and the Stock Tools interface.
- **Share the result:** embed charts in Shiny and R Markdown, export images and
  data, and use built-in accessibility features.

## Your first chart

Pass a data frame to `hchart()` and map columns to visual properties with
`hcaes()`. Add titles and options with the R pipe:

```r
library(highcharter)

hchart(mtcars, "scatter", hcaes(x = wt, y = mpg, group = cyl)) |>
  hc_title(text = "Fuel economy by car weight") |>
  hc_xAxis(title = list(text = "Weight (1,000 lbs)")) |>
  hc_yAxis(title = list(text = "Miles per gallon"))
```

The [first steps guide](https://jkunst.com/highcharter/articles/first-steps.html)
walks through data frames, chart types and the options that make a chart yours.

## Keep exploring

- [Chart gallery](https://jkunst.com/highcharter/articles/series-gallery.html):
  find a chart type and its R example.
- [Maps](https://jkunst.com/highcharter/articles/maps.html) and
  [Stock charts](https://jkunst.com/highcharter/articles/stock.html):
  explore places and financial time series.
- [Shiny](https://jkunst.com/highcharter/articles/shiny.html) and
  [accessibility](https://jkunst.com/highcharter/articles/accessibility.html):
  build interactive experiences for your audience.
- [Function reference](https://jkunst.com/highcharter/reference/index.html):
  look up helpers and chart options.

[Source code](https://github.com/jbkunst/highcharter) ·
[Report an issue](https://github.com/jbkunst/highcharter/issues) ·
[Contribute](CONTRIBUTING.md) ·
[Authors and citation](https://jkunst.com/highcharter/authors.html)

Highcharter is licensed under MIT. Highcharts has its own
[licensing terms](https://www.highcharts.com/license).

</div>
