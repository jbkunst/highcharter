# Connectors options for highcharter objects

The Pathfinder module allows you to define connections between any two
points, represented as lines - optionally with markers for the start
and/or end points. Multiple algorithms are available for calculating how
the connecting lines are drawn.

## Usage

``` r
hc_connectors(hc, ...)
```

## Arguments

- hc:

  A `highchart` `htmlwidget` object.

- ...:

  Options defined in <https://api.highcharts.com/gantt/connectors>.

## Details

Connector functionality requires Highcharts Gantt to be loaded. In Gantt
charts, the connectors are used to draw dependencies between tasks.

## Examples

``` r
day <- datetime_to_timestamp(as.Date("2025-01-01") + 0:3)
highchart(type = "gantt") |>
  hc_title(text = "Design must finish before building starts") |>
  hc_add_series(
    type = "gantt",
    data = list(
      list(id = "design", name = "Design", start = day[1], end = day[2]),
      list(name = "Build", start = day[2], end = day[4], dependency = "design")
    )
  ) |>
  hc_connectors(
    type = "straight",
    lineColor = "#3066BE",
    lineWidth = 2,
    endMarker = list(enabled = TRUE)
  )

{"x":{"hc_opts":{"chart":{"reflow":true},"title":{"text":"Design must finish before building starts"},"yAxis":{"title":{"text":null}},"credits":{"enabled":false},"exporting":{"enabled":false},"boost":{"enabled":false},"plotOptions":{"series":{"label":{"enabled":false},"turboThreshold":0.0},"treemap":{"layoutAlgorithm":"squarified","levels":[{"level":1,"colorByPoint":true}]},"sunburst":{"levels":[{"level":1,"colorByPoint":true}]}},"series":[{"data":[{"id":"design","name":"Design","start":1735689600000.0,"end":1735776000000.0},{"name":"Build","start":1735776000000.0,"end":1735948800000.0,"dependency":"design"}],"type":"gantt"}],"connectors":{"type":"straight","lineColor":"#3066BE","lineWidth":2.0,"endMarker":{"enabled":true}}},"theme":{"symbols":["circle","circle","circle","circle","circle"],"colors":["#47475c","#61BC7B","#508CC8","#F49952","#9C9EDB","#6699a1"],"chart":{"style":{"fontFamily":"IBM Plex Sans","color":"#666666"}},"title":{"align":"left","style":{"fontFamily":"Alegreya Sans SC","fontSize":"24px","fontWeight":"normal"}},"subtitle":{"align":"left","style":{"fontFamily":"IBM Plex Sans","fontSize":"16px"}},"caption":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"14px"}},"credits":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"10px"}},"legend":{"align":"right","verticalAlign":"bottom","itemStyle":{"fontWeight":"normal","color":"#666666"}},"xAxis":{"gridLineWidth":1,"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"yAxis":{"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"plotOptions":{"series":{"dataLabels":{"style":{"fontWeight":"normal"}}},"line":{"marker":{"enabled":false}},"spline":{"marker":{"enabled":false}},"area":{"marker":{"enabled":false}},"areaspline":{"marker":{"enabled":false}},"arearange":{"marker":{"enabled":false}},"bubble":{"maxSize":"10%"}},"tooltip":{"className":"highcharter-regular-tooltip","valueDecimals":2.0}},"conf_opts":{"lang":{"locale":"en"}},"type":"gantt"},"evals":[],"jsHooks":[]}
```
