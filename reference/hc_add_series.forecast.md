# hc_add_series for forecast objects

hc_add_series for forecast objects

## Usage

``` r
# S3 method for class 'forecast'
hc_add_series(
  hc,
  data,
  addOriginal = FALSE,
  addLevels = TRUE,
  fillOpacity = 0.1,
  name = NULL,
  ...
)
```

## Arguments

- hc:

  A `highchart` `htmlwidget` object.

- data:

  A `forecast` object.

- addOriginal:

  Logical value to add the original series or not.

- addLevels:

  Logical value to show predictions bands.

- fillOpacity:

  The opacity of bands.

- name:

  The name of the series.

- ...:

  Arguments defined in <https://api.highcharts.com/highcharts/chart>.
