# Add a fitted model series (deprecated)

Passing an `lm` or `loess` object to
[`hc_add_series()`](https://jkunst.com/highcharter/reference/hc_add_series.md)
is deprecated. Use
[`stats::predict()`](https://rdrr.io/r/stats/predict.html) to prepare a
data frame, then add the fitted values as a line and the interval bounds
as an arearange. See the [worked
example](https://jkunst.com/highcharter/articles/first-steps.html#a-more-advanced-example).
The model methods use the fitted value plus or minus two standard
errors.

## Usage

``` r
# S3 method for class 'lm'
hc_add_series(
  hc,
  data,
  type = "line",
  color = "#5F83EE",
  fillOpacity = 0.1,
  ...
)

# S3 method for class 'loess'
hc_add_series(
  hc,
  data,
  type = "line",
  color = "#5F83EE",
  fillOpacity = 0.1,
  ...
)
```

## Arguments

- hc:

  A `highchart` `htmlwidget` object.

- data:

  A `lm` or `loess` object.

- type:

  The type of the series: line, spline.

- color:

  Color of the fitted line.

- fillOpacity:

  Opacity of the interval band.

- ...:

  Arguments defined in <https://api.highcharts.com/highcharts/chart>.
