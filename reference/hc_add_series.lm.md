# hc_add_series for lm and loess objects

hc_add_series for lm and loess objects

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

  A stringr color.

- fillOpacity:

  fillOpacity to the confidence interval.

- ...:

  Arguments defined in <https://api.highcharts.com/highcharts/chart>.
