# Remove point to a series of a higchartProxy object

Remove point to a series of a higchartProxy object

## Usage

``` r
hcpxy_remove_point(proxy, id = NULL, i = NULL, redraw = TRUE)
```

## Arguments

- proxy:

  A `higchartProxy` object.

- id:

  A character vector indicating the `id` of the series to update.

- i:

  The index of the point in the data array. Remember js is 0 based
  index.

- redraw:

  Whether to redraw the chart after the point is added. When adding more
  than one point, it is highly recommended that the redraw option be set
  to false, and instead Highcharts.Chart#redraw is explicitly called
  after the adding of points is finished. Otherwise, the chart will
  redraw after adding each point.
