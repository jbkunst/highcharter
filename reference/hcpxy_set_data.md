# Update data for a higchartProxy object

Update data for a higchartProxy object

## Usage

``` r
hcpxy_set_data(
  proxy,
  type,
  data,
  mapping = hcaes(),
  redraw = FALSE,
  animation = NULL,
  updatePoints = TRUE
)
```

## Arguments

- proxy:

  A `higchartProxy` object.

- type:

  series type (column, bar, line, etc)

- data:

  dataframe of new data to send to chart

- mapping:

  how data should be mapped using
  [`hcaes()`](https://jkunst.com/highcharter/reference/hcaes.md)

- redraw:

  boolean Whether to redraw the chart after the series is altered. If
  doing more operations on the chart, it is a good idea to set redraw to
  false and call hcpxy_redraw after.

- animation:

  boolean When the updated data is the same length as the existing data,
  points will be updated by default, and animation visualizes how the
  points are changed. Set false to disable animation, or a configuration
  object to set duration or easing.

- updatePoints:

  boolean When this is TRUE, points will be updated instead of replaced
  whenever possible. This occurs a) when the updated data is the same
  length as the existing data, b) when points are matched by their id's,
  or c) when points can be matched by X values. This allows updating
  with animation and performs better. In this case, the original array
  is not passed by reference. Set FALSE to prevent.
