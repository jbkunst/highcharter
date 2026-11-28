# Connect interactions between charts in an HTML document

Apply this helper to each widget, including widgets rendered in separate
Quarto HTML chunks. Each widget keeps its own data. The first X axis is
used for hover and zoom. Points are matched by their exact numeric X
value (including timestamps). Category axes should have the same
category order. A missing match clears the receiving tooltip and
crosshair.

## Usage

``` r
hc_connect(hc, group, sync = c("hover", "zoom"))
```

## Arguments

- hc:

  A highchart widget.

- group:

  A non-empty group name shared by the charts on the page.

- sync:

  Interactions to share. `"hover"` links tooltips and crosshairs,
  `"zoom"` links X ranges and reset buttons, and `"legend"` links series
  or pie points with the same explicit `id`. Enable an interaction on
  both widgets.

## Value

The highchart widget.

## See also

[Connected
charts](https://jkunst.com/highcharter/articles/connected-charts.html)
for linked time series, legends across chart types, and a four-chart
layout.

## Examples

``` r
# Fictional monthly sales. Matching series IDs link the legends.
cafes <- list(
  list(id = "harbor", name = "Harbor", data = c(12, 15, 18, 16, 22, 25)),
  list(id = "garden", name = "Garden", data = c(18, 16, 14, 19, 21, 23)),
  list(id = "station", name = "Station", data = c(9, 12, 16, 21, 18, 24))
)
base <- highchart() |>
  hc_add_series_list(cafes) |>
  hc_xAxis(categories = month.abb[1:6], crosshair = TRUE) |>
  hc_yAxis(title = list(text = "Sales (thousands of dollars)")) |>
  hc_tooltip(shared = TRUE, table = TRUE, valueDecimals = 0,
             valuePrefix = "$", valueSuffix = "k") |>
  hc_connect("cafes", sync = c("hover", "legend")) |>
  hc_size(height = 320)

# Hover a month or click a legend item in either chart.
trends <- base |>
  hc_chart(type = "line") |>
  hc_title(text = "Coffee around town") |>
  hc_subtitle(text = "Hover a month or toggle a cafe")
sales <- base |>
  hc_chart(type = "column") |>
  hc_title(text = "The same sales, another view") |>
  hc_plotOptions(column = list(
    borderRadius = 4,
    dataLabels = list(enabled = TRUE)
  )) |>
  hc_caption(text = "Legends and tooltips are linked in both directions.")
htmltools::browsable(htmltools::tagList(trends, sales))

{"x":{"hc_opts":{"chart":{"reflow":true,"height":320.0,"type":"line"},"title":{"text":"Coffee around town"},"yAxis":{"title":{"text":"Sales (thousands of dollars)"}},"credits":{"enabled":false},"exporting":{"enabled":false},"boost":{"enabled":false},"plotOptions":{"series":{"label":{"enabled":false},"turboThreshold":0.0},"treemap":{"layoutAlgorithm":"squarified","levels":[{"level":1,"colorByPoint":true}]},"sunburst":{"levels":[{"level":1,"colorByPoint":true}]}},"series":[{"id":"harbor","name":"Harbor","data":[12.0,15.0,18.0,16.0,22.0,25.0]},{"id":"garden","name":"Garden","data":[18.0,16.0,14.0,19.0,21.0,23.0]},{"id":"station","name":"Station","data":[9.0,12.0,16.0,21.0,18.0,24.0]}],"xAxis":{"categories":["Jan","Feb","Mar","Apr","May","Jun"],"crosshair":true},"tooltip":{"shared":true,"useHTML":true,"headerFormat":"<small>{point.key}\u003c/small><table>","pointFormat":"<tr><td style=\"color: {series.color}\">{series.name}: \u003c/td><td style=\"text-align: right\"><b>{point.y}\u003c/b>\u003c/td>\u003c/tr>","footerFormat":"\u003c/table>","valueDecimals":0.0,"valuePrefix":"$","valueSuffix":"k"},"subtitle":{"text":"Hover a month or toggle a cafe"}},"theme":{"symbols":["circle","circle","circle","circle","circle"],"colors":["#47475c","#61BC7B","#508CC8","#F49952","#9C9EDB","#6699a1"],"chart":{"style":{"fontFamily":"IBM Plex Sans","color":"#666666"}},"title":{"align":"left","style":{"fontFamily":"Alegreya Sans SC","fontSize":"24px","fontWeight":"normal"}},"subtitle":{"align":"left","style":{"fontFamily":"IBM Plex Sans","fontSize":"16px"}},"caption":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"14px"}},"credits":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"10px"}},"legend":{"align":"right","verticalAlign":"bottom","itemStyle":{"fontWeight":"normal","color":"#666666"}},"xAxis":{"gridLineWidth":1,"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"yAxis":{"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"plotOptions":{"series":{"dataLabels":{"style":{"fontWeight":"normal"}}},"line":{"marker":{"enabled":false}},"spline":{"marker":{"enabled":false}},"area":{"marker":{"enabled":false}},"areaspline":{"marker":{"enabled":false}},"arearange":{"marker":{"enabled":false}},"bubble":{"maxSize":"10%"}},"tooltip":{"className":"highcharter-regular-tooltip","valueDecimals":2.0}},"conf_opts":{"lang":{"locale":"en"}},"type":"chart","connect":{"group":"cafes","sync":["hover","legend"]}},"evals":[],"jsHooks":[]}
{"x":{"hc_opts":{"chart":{"reflow":true,"height":320.0,"type":"column"},"title":{"text":"The same sales, another view"},"yAxis":{"title":{"text":"Sales (thousands of dollars)"}},"credits":{"enabled":false},"exporting":{"enabled":false},"boost":{"enabled":false},"plotOptions":{"series":{"label":{"enabled":false},"turboThreshold":0.0},"treemap":{"layoutAlgorithm":"squarified","levels":[{"level":1,"colorByPoint":true}]},"sunburst":{"levels":[{"level":1,"colorByPoint":true}]},"column":{"borderRadius":4.0,"dataLabels":{"enabled":true}}},"series":[{"id":"harbor","name":"Harbor","data":[12.0,15.0,18.0,16.0,22.0,25.0]},{"id":"garden","name":"Garden","data":[18.0,16.0,14.0,19.0,21.0,23.0]},{"id":"station","name":"Station","data":[9.0,12.0,16.0,21.0,18.0,24.0]}],"xAxis":{"categories":["Jan","Feb","Mar","Apr","May","Jun"],"crosshair":true},"tooltip":{"shared":true,"useHTML":true,"headerFormat":"<small>{point.key}\u003c/small><table>","pointFormat":"<tr><td style=\"color: {series.color}\">{series.name}: \u003c/td><td style=\"text-align: right\"><b>{point.y}\u003c/b>\u003c/td>\u003c/tr>","footerFormat":"\u003c/table>","valueDecimals":0.0,"valuePrefix":"$","valueSuffix":"k"},"caption":{"text":"Legends and tooltips are linked in both directions."}},"theme":{"symbols":["circle","circle","circle","circle","circle"],"colors":["#47475c","#61BC7B","#508CC8","#F49952","#9C9EDB","#6699a1"],"chart":{"style":{"fontFamily":"IBM Plex Sans","color":"#666666"}},"title":{"align":"left","style":{"fontFamily":"Alegreya Sans SC","fontSize":"24px","fontWeight":"normal"}},"subtitle":{"align":"left","style":{"fontFamily":"IBM Plex Sans","fontSize":"16px"}},"caption":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"14px"}},"credits":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"10px"}},"legend":{"align":"right","verticalAlign":"bottom","itemStyle":{"fontWeight":"normal","color":"#666666"}},"xAxis":{"gridLineWidth":1,"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"yAxis":{"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"plotOptions":{"series":{"dataLabels":{"style":{"fontWeight":"normal"}}},"line":{"marker":{"enabled":false}},"spline":{"marker":{"enabled":false}},"area":{"marker":{"enabled":false}},"areaspline":{"marker":{"enabled":false}},"arearange":{"marker":{"enabled":false}},"bubble":{"maxSize":"10%"}},"tooltip":{"className":"highcharter-regular-tooltip","valueDecimals":2.0}},"conf_opts":{"lang":{"locale":"en"}},"type":"chart","connect":{"group":"cafes","sync":["hover","legend"]}},"evals":[],"jsHooks":[]}
```
