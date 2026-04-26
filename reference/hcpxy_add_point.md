# Add point to a series of a higchartProxy object

Add point to a series of a higchartProxy object

## Usage

``` r
hcpxy_add_point(
  proxy,
  id = NULL,
  point,
  redraw = TRUE,
  shift = FALSE,
  animation = TRUE
)
```

## Arguments

- proxy:

  A `higchartProxy` object.

- id:

  A character vector indicating the `id` of the series to update.

- point:

  The point options. If options is a single number, a point with that y
  value is appended to the series. If it is an list, it will be
  interpreted as x and y values respectively. If it is an object,
  advanced options as outlined under series.data are applied

- redraw:

  Whether to redraw the chart after the point is added. When adding more
  than one point, it is highly recommended that the redraw option be set
  to false, and instead Highcharts.Chart#redraw is explicitly called
  after the adding of points is finished. Otherwise, the chart will
  redraw after adding each point.

- shift:

  If `TRUE`, a point is shifted off the start of the series as one is
  appended to the end.

- animation:

  Whether to apply animation, and optionally animation configuration.
