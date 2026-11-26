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
# A half-circle leaves room below the dial for the value and units.
highchart() |>
  hc_chart(type = "gauge") |>
  hc_title(text = "Storage used") |>
  hc_pane(
    startAngle = -90,
    endAngle = 90,
    center = c("50%", "75%"),
    size = "110%"
  ) |>
  hc_yAxis(
    min = 0,
    max = 100,
    tickInterval = 25,
    title = list(text = "% used"),
    plotBands = list(
      list(from = 0, to = 70, color = "#009E73"),
      list(from = 70, to = 90, color = "#E69F00"),
      list(from = 90, to = 100, color = "#D55E00")
    )
  ) |>
  hc_add_series(name = "Storage", data = 72, tooltip = list(valueSuffix = "%"))

{"x":{"hc_opts":{"chart":{"reflow":true,"type":"gauge"},"title":{"text":"Storage used"},"yAxis":{"title":{"text":"% used"},"min":0.0,"max":100.0,"tickInterval":25.0,"plotBands":[{"from":0.0,"to":70.0,"color":"#009E73"},{"from":70.0,"to":90.0,"color":"#E69F00"},{"from":90.0,"to":100.0,"color":"#D55E00"}]},"credits":{"enabled":false},"exporting":{"enabled":false},"boost":{"enabled":false},"plotOptions":{"series":{"label":{"enabled":false},"turboThreshold":0.0},"treemap":{"layoutAlgorithm":"squarified","levels":[{"level":1,"colorByPoint":true}]},"sunburst":{"levels":[{"level":1,"colorByPoint":true}]}},"pane":{"startAngle":-90.0,"endAngle":90.0,"center":["50%","75%"],"size":"110%"},"series":[{"data":[72.0],"name":"Storage","tooltip":{"valueSuffix":"%"}}]},"theme":{"symbols":["circle","circle","circle","circle","circle"],"colors":["#47475c","#61BC7B","#508CC8","#F49952","#9C9EDB","#6699a1"],"chart":{"style":{"fontFamily":"IBM Plex Sans","color":"#666666"}},"title":{"align":"left","style":{"fontFamily":"Alegreya Sans SC","fontSize":"24px","fontWeight":"normal"}},"subtitle":{"align":"left","style":{"fontFamily":"IBM Plex Sans","fontSize":"16px"}},"caption":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"14px"}},"credits":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"10px"}},"legend":{"align":"right","verticalAlign":"bottom","itemStyle":{"fontWeight":"normal","color":"#666666"}},"xAxis":{"gridLineWidth":1,"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"yAxis":{"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"plotOptions":{"series":{"dataLabels":{"style":{"fontWeight":"normal"}}},"line":{"marker":{"enabled":false}},"spline":{"marker":{"enabled":false}},"area":{"marker":{"enabled":false}},"areaspline":{"marker":{"enabled":false}},"arearange":{"marker":{"enabled":false}},"bubble":{"maxSize":"10%"}},"tooltip":{"className":"highcharter-regular-tooltip","valueDecimals":2.0}},"conf_opts":{"lang":{"locale":"en"}},"type":"chart"},"evals":[],"jsHooks":[]}
```
