# Set axis extremes for a higchartProxy object

This controls the visible range without rebuilding the chart. It is
useful for Stock charts and their navigator, and also works with regular
charts.

## Usage

``` r
hcpxy_set_extremes(
  proxy,
  min = NULL,
  max = NULL,
  axis = 0,
  redraw = TRUE,
  animation = TRUE
)
```

## Arguments

- proxy:

  A `higchartProxy` object.

- min, max:

  Minimum and maximum axis values. Dates and date-times are converted to
  Highcharts timestamps. Use `NULL` for both to reset the range.

- axis:

  Zero-based x-axis index or a character axis ID.

- redraw:

  Whether to redraw the chart after changing the range.

- animation:

  Whether to animate the range change, or an animation options list.
