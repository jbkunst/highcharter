# Shiny applications

Run the examples below or browse the [Shiny
gallery](https://jkunst.com/highcharter/articles/shiny-gallery.md). Each
app has its own folder under [`pkgdown/shiny/` on
GitHub](https://github.com/jbkunst/highcharter/tree/main/pkgdown/shiny).
The first launch downloads R and its dependencies. The apps use the
highcharter version documented here.

## Basics

Select **Sepal** or **Petal**. The same 150 flowers move to their new
coordinates. Put `highchartOutput("flowers")` in the UI and read
`input$measure` inside
[`renderHighchart()`](https://jkunst.com/highcharter/reference/renderHighchart.md)
to rebuild the plot when the measurement changes.

[Open the app in its own
tab](https://jkunst.com/highcharter/live/basic/index.md) · [View app.R
on
GitHub](https://github.com/jbkunst/highcharter/blob/main/pkgdown/shiny/basic/app.R)

## Proxies

The [original proxy
playground](https://github.com/jbkunst/highcharter-shiny/tree/master/02-proxy-functions)
inspired these three examples. Each tab creates its chart once, then
uses
[`highchartProxy()`](https://jkunst.com/highcharter/reference/highchartProxy.md)
to change the chart already on screen.

- **Series.** Compare monthly temperatures in Santiago and Tokyo. Toggle
  Tokyo to add or remove its series. Switch from daily means to daily
  highs to replace the data by series ID with
  [`hcpxy_set_data()`](https://jkunst.com/highcharter/reference/hcpxy_set_data.md).
  A single
  [`hcpxy_redraw()`](https://jkunst.com/highcharter/reference/hcpxy_redraw.md)
  displays both changes. Try the same comparison on polar axes.
- **Points.** Add or remove a month of observed air traffic. Turn on the
  dashed forecast to repeat the last twelve observations one year ahead.
  The forecast moves with the observations, even when you switch to
  columns.
- **Layout.** Rearrange the same 592 students into a grid, semicircle or
  circle.
  [`hcpxy_update_series()`](https://jkunst.com/highcharter/reference/hcpxy_update_series.md)
  changes the item layout while preserving the counts.

[Open the app in its own
tab](https://jkunst.com/highcharter/live/proxy/index.md) · [View app.R
on
GitHub](https://github.com/jbkunst/highcharter/blob/main/pkgdown/shiny/proxy/app.R)

To switch from weekly to daily Stock prices when the visible date range
narrows, [run the Stock proxy
app](https://jkunst.com/highcharter/live/stock/index.md) or [read the
Stock
walkthrough](https://jkunst.com/highcharter/articles/stock.html#update-a-series-and-its-visible-range-in-shiny).

## Events

Gain ranges from −12 dB (cut) to +12 dB (boost), with 0 dB neutral.
Hover over a band, click it, then drag the arrow at its top and release
it. Each event has its own readout. The `drag` and `mouseOver` values
refresh at most once every 150 ms. The `drop` value shows the final gain
as soon as you release the band.

[Open the app in its own
tab](https://jkunst.com/highcharter/live/events/index.md) · [View app.R
on
GitHub](https://github.com/jbkunst/highcharter/blob/main/pkgdown/shiny/events/app.R)

Point clicks arrive automatically at `input$eq_point_click`. Register
`mouseOver`, `drag` and `drop` with
[`hc_add_event_point()`](https://jkunst.com/highcharter/reference/hc_add_event_point.md)
to receive their inputs too. For example,
`input$eq_point_mouseOver$pointid` identifies the band under the pointer
and `input$eq_point_drag$y` gives its gain during a drag.

## Linked views

The dotplot shows mean petal length by species, rounded to the nearest
millimeter. With `colorByPoint = TRUE`, each species gets its own color.
Pause over a species for 200 ms or click it for an immediate selection.
The detail shows petal length and width for its 50 flowers in the same
color. A Shiny proxy animates the 50 dots to the new species’
measurements and updates the color and title. The axes stay fixed for
comparison.

[Open the app in its own
tab](https://jkunst.com/highcharter/live/linked/index.md) · [View app.R
on
GitHub](https://github.com/jbkunst/highcharter/blob/main/pkgdown/shiny/linked/app.R)

To run an example from a local checkout, load the package and open the
app directory:

``` r

pkgload::load_all()
shiny::runApp("pkgdown/shiny/events")
```

The [original Shiny
examples](https://github.com/jbkunst/highcharter-shiny) also include a
[population explorer with linked
views](https://github.com/jbkunst/highcharter-shiny/tree/master/08-idb-viz).
