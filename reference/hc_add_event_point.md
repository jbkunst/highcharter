# Helpers to use highcharter as input in shiny apps

When you use highcharter in a shiny app, for example
`renderHighcharter('my_chart')`, you can access to the actions of the
user using and then use the `hc_add_event_point` via the `my_chart`
input (`input$my_chart`). That's a way you can use a chart as an input.

## Usage

``` r
hc_add_event_point(hc, series = "series", event = "click")

hc_add_event_series(hc, series = "series", event = "click")
```

## Arguments

- hc:

  A `highchart` `htmlwidget` object.

- series:

  The name of type of series to apply the event.

- event:

  The name of event: click, mouseOut, mouseOver. See
  <https://api.highcharts.com/highcharts/plotOptions.areasplinerange.point.events.select>
  for more details.

## Note

Event details are accessible from hc_name_EventType, i.e. if a highchart
is rendered against output\$my_hc and and we wanted the coordinates of
the user-clicked point we would use input\$my_hc_click
