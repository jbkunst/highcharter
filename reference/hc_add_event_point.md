# Use chart events as Shiny inputs

For an output named `sales`, Shiny receives point clicks automatically
at `input$sales_point_click`. Register other Highcharts events with
these helpers. For example, `hc_add_event_point(event = "drop")` sends
the released point to `input$sales_point_drop`, and
`hc_add_event_series(event = "mouseOver")` sends the hovered series to
`input$sales_series_mouseOver`.

## Usage

``` r
hc_add_event_point(hc, series = "series", event = "click")

hc_add_event_series(hc, series = "series", event = "click")
```

## Arguments

- hc:

  A `highchart` htmlwidget.

- series:

  Highcharts series type to listen to, such as `"column"`. The default
  `"series"` applies to all types.

- event:

  Case-sensitive Highcharts event name, such as `"mouseOver"`. See the
  [point
  events](https://api.highcharts.com/highcharts/plotOptions.series.point.events)
  and [series
  events](https://api.highcharts.com/highcharts/plotOptions.series.events).

## Value

The chart with the requested event configured.

## Details

Point events include `series`, `seriesid`, `pointid`, `name`, `x`, `y`
and `category` when available. During a drag or drop, the coordinates
reflect the proposed position. Series events include `name` and
`seriesid`.
