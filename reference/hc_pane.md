# Pane options for highcharter objects

The pane serves as a container for axes and backgrounds for circular
gauges and polar charts.

## Usage

``` r
hc_pane(hc, ...)
```

## Arguments

- hc:

  A `highchart` `htmlwidget` object.

- ...:

  Options defined in <https://api.highcharts.com/highcharts/pane>.

## Details

When used in `Highcharts.setOptions` for theming, the pane must be a
single object, otherwise arrays are supported.

## Examples

``` r
# The start and end angles give the speedometer a 300-degree sweep.
highchart() |>
  hc_chart(type = "gauge") |>
  hc_title(text = "Speedometer") |>
  hc_pane(startAngle = -150, endAngle = 150) |>
  hc_yAxis(
    min = 0,
    max = 200,
    tickInterval = 40,
    title = list(text = "km/h")
  ) |>
  hc_add_series(
    name = "Speed",
    data = 80,
    tooltip = list(valueSuffix = " km/h")
  )

{"x":{"hc_opts":{"chart":{"reflow":true,"type":"gauge"},"title":{"text":"Speedometer"},"yAxis":{"title":{"text":"km/h"},"min":0.0,"max":200.0,"tickInterval":40.0},"credits":{"enabled":false},"exporting":{"enabled":false},"boost":{"enabled":false},"plotOptions":{"series":{"label":{"enabled":false},"turboThreshold":0.0},"treemap":{"layoutAlgorithm":"squarified","levels":[{"level":1,"colorByPoint":true}]},"sunburst":{"levels":[{"level":1,"colorByPoint":true}]}},"pane":{"startAngle":-150.0,"endAngle":150.0},"series":[{"data":[80.0],"name":"Speed","tooltip":{"valueSuffix":" km/h"}}]},"theme":{"symbols":["circle","circle","circle","circle","circle"],"colors":["#47475c","#61BC7B","#508CC8","#F49952","#9C9EDB","#6699a1"],"chart":{"style":{"fontFamily":"IBM Plex Sans","color":"#666666"}},"title":{"align":"left","style":{"fontFamily":"Alegreya Sans SC","fontSize":"24px","fontWeight":"normal"}},"subtitle":{"align":"left","style":{"fontFamily":"IBM Plex Sans","fontSize":"16px"}},"caption":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"14px"}},"credits":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"10px"}},"legend":{"align":"right","verticalAlign":"bottom","itemStyle":{"fontWeight":"normal","color":"#666666"}},"xAxis":{"gridLineWidth":1,"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"yAxis":{"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"plotOptions":{"series":{"dataLabels":{"style":{"fontWeight":"normal"}}},"line":{"marker":{"enabled":false}},"spline":{"marker":{"enabled":false}},"area":{"marker":{"enabled":false}},"areaspline":{"marker":{"enabled":false}},"arearange":{"marker":{"enabled":false}},"bubble":{"maxSize":"10%"}},"tooltip":{"className":"highcharter-regular-tooltip","valueDecimals":2.0}},"conf_opts":{"lang":{"locale":"en"}},"type":"chart"},"evals":[],"jsHooks":[]}
```
