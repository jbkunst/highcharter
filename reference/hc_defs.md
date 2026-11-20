# Defs options for highcharter objects

Options for configuring markers for annotations.

## Usage

``` r
hc_defs(hc, ...)
```

## Arguments

- hc:

  A `highchart` `htmlwidget` object.

- ...:

  Options defined in <https://api.highcharts.com/highcharts/defs>.

## Details

An example of the arrow marker:

## Examples

``` r
# Define a diamond marker and use it at the end of an annotation.
point <- function(x, y) list(xAxis = 0, yAxis = 0, x = x, y = y)
highchart() |>
  hc_add_series(data = c(2, 4, 3)) |>
  hc_defs(
    diamond = list(
      tagName = "marker",
      attributes = list(
        id = "diamond",
        markerWidth = 8,
        markerHeight = 8,
        refX = 4,
        refY = 4
      ),
      children = list(list(
        tagName = "path",
        attributes = list(d = "M 0 4 L 4 0 L 8 4 L 4 8 Z")
      ))
    )
  ) |>
  hc_annotations(list(
    shapes = list(list(
      type = "path",
      stroke = "#3066BE",
      markerEnd = "diamond",
      points = list(point(0, 2), point(1, 4))
    ))
  ))

{"x":{"hc_opts":{"chart":{"reflow":true},"title":{"text":null},"yAxis":{"title":{"text":null}},"credits":{"enabled":false},"exporting":{"enabled":false},"boost":{"enabled":false},"plotOptions":{"series":{"label":{"enabled":false},"turboThreshold":0.0},"treemap":{"layoutAlgorithm":"squarified","levels":[{"level":1,"colorByPoint":true}]},"sunburst":{"levels":[{"level":1,"colorByPoint":true}]}},"series":[{"data":[2.0,4.0,3.0]}],"defs":{"diamond":{"tagName":"marker","attributes":{"id":"diamond","markerWidth":8.0,"markerHeight":8.0,"refX":4.0,"refY":4.0},"children":[{"tagName":"path","attributes":{"d":"M 0 4 L 4 0 L 8 4 L 4 8 Z"}}]}},"annotations":[{"shapes":[{"type":"path","stroke":"#3066BE","markerEnd":"diamond","points":[{"xAxis":0.0,"yAxis":0.0,"x":0.0,"y":2.0},{"xAxis":0.0,"yAxis":0.0,"x":1.0,"y":4.0}]}]}]},"theme":{"symbols":["circle","circle","circle","circle","circle"],"colors":["#47475c","#61BC7B","#508CC8","#F49952","#9C9EDB","#6699a1"],"chart":{"style":{"fontFamily":"IBM Plex Sans","color":"#666666"}},"title":{"align":"left","style":{"fontFamily":"Alegreya Sans SC","fontSize":"24px","fontWeight":"normal"}},"subtitle":{"align":"left","style":{"fontFamily":"IBM Plex Sans","fontSize":"16px"}},"caption":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"14px"}},"credits":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"10px"}},"legend":{"align":"right","verticalAlign":"bottom","itemStyle":{"fontWeight":"normal","color":"#666666"}},"xAxis":{"gridLineWidth":1,"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"yAxis":{"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"plotOptions":{"series":{"dataLabels":{"style":{"fontWeight":"normal"}}},"line":{"marker":{"enabled":false}},"spline":{"marker":{"enabled":false}},"area":{"marker":{"enabled":false}},"areaspline":{"marker":{"enabled":false}},"arearange":{"marker":{"enabled":false}},"bubble":{"maxSize":"10%"}},"tooltip":{"className":"highcharter-regular-tooltip","valueDecimals":2.0}},"conf_opts":{"lang":{"locale":"en"}},"type":"chart"},"evals":[],"jsHooks":[]}
```
