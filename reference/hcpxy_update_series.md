# Update options series in a higchartProxy object

Update options series in a higchartProxy object

## Usage

``` r
hcpxy_update_series(proxy, id = NULL, ...)
```

## Arguments

- proxy:

  A `higchartProxy` object.

- id:

  A character vector indicating the `id` (or `id`s) of the series to
  update.

- ...:

  Arguments defined in
  <https://api.highcharts.com/highcharts/plotOptions.series>. The
  arguments will be the same for each series. So if you want update data
  it is used this function sequentially for each series.
