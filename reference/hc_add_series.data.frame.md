# hc_add_series for data frames objects

hc_add_series for data frames objects

## Usage

``` r
# S3 method for class 'data.frame'
hc_add_series(hc, data, type = NULL, mapping = hcaes(), fast = FALSE, ...)
```

## Arguments

- hc:

  A `highchart` `htmlwidget` object.

- data:

  A `data.frame` object.

- type:

  The type of the series: line, bar, etc.

- mapping:

  The mapping, same idea as `ggplot2`.

- fast:

  convert to json during the composition of a highchart object

- ...:

  Arguments defined in <https://api.highcharts.com/highcharts/chart>.
