# hc_add_series for geo_json & geo_list objects

hc_add_series for geo_json & geo_list objects

## Usage

``` r
# S3 method for class 'geo_json'
hc_add_series(hc, data, type = NULL, ...)

# S3 method for class 'geo_list'
hc_add_series(hc, data, type = NULL, ...)
```

## Arguments

- hc:

  A `highchart` `htmlwidget` object.

- data:

  A `geo_json` or `geo_list` object.

- type:

  Type of series. Can be 'mapline', 'mapoint'.

- ...:

  Arguments defined in
  <https://api.highcharts.com/highcharts/plotOptions.series>.
