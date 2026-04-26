# Update options series in a higchartProxy object

Update options series in a higchartProxy object

## Usage

``` r
hcpxy_update_point(proxy, id = NULL, id_point = NULL, ...)
```

## Arguments

- proxy:

  A `higchartProxy` object.

- id:

  A character indicating the `id` of the series' point to update.

- id_point:

  A vector value indicating the point's index to update, (0 based).

- ...:

  Arguments defined in
  <https://api.highcharts.com/class-reference/Highcharts.Point>. The
  arguments will be the same for each series. So if you want update data
  it is used this function sequentially for each point
