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

  A GeoJSON FeatureCollection of class `geo_json` or `geo_list`.

- type:

  By default, draw a series for every geometry family present, in
  polygon, line, point order. Supply `"map"`, `"mapline"` or
  `"mappoint"` to select one family.

- ...:

  Highcharts series options. For multiple layers, supply one name per
  layer or a shared name prefix. If supplying IDs, give one distinct ID
  per layer, in the same order.
