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
passengers <- as.numeric(window(
  AirPassengers,
  start = c(1949, 1),
  end = c(1949, 12)
))
low <- which.min(passengers)
point <- function(month, value) {
  list(xAxis = 0, yAxis = 0, x = month - 1L, y = value)
}

highchart() |>
  hc_title(text = "International air passengers, 1949") |>
  hc_subtitle(text = "The orange diamond marks the lowest monthly total.") |>
  hc_xAxis(categories = month.abb) |>
  hc_yAxis(title = list(text = "Passengers (thousands)")) |>
  hc_add_series(
    data = passengers,
    type = "line",
    name = "Passengers",
    color = "#47475C",
    marker = list(enabled = FALSE),
    showInLegend = FALSE
  ) |>
  hc_defs(
    diamond = list(
      tagName = "marker",
      attributes = list(
        id = "diamond",
        markerWidth = 10,
        markerHeight = 10,
        refX = 5,
        refY = 5,
        orient = "0"
      ),
      children = list(list(
        tagName = "path",
        attributes = list(d = "M 5 1 L 9 5 L 5 9 L 1 5 Z")
      ))
    )
  ) |>
  hc_annotations(list(
    shapes = list(list(
      type = "path",
      points = list(
        point(low - 3L, passengers[low] + 5),
        point(low, passengers[low])
      ),
      stroke = "#B44816",
      strokeWidth = 2,
      fill = "none",
      markerEnd = "diamond"
    ))
  ))

{"x":{"hc_opts":{"chart":{"reflow":true},"title":{"text":"International air passengers, 1949"},"yAxis":{"title":{"text":"Passengers (thousands)"}},"credits":{"enabled":false},"exporting":{"enabled":false},"boost":{"enabled":false},"plotOptions":{"series":{"label":{"enabled":false},"turboThreshold":0.0},"treemap":{"layoutAlgorithm":"squarified","levels":[{"level":1,"colorByPoint":true}]},"sunburst":{"levels":[{"level":1,"colorByPoint":true}]}},"subtitle":{"text":"The orange diamond marks the lowest monthly total."},"xAxis":{"categories":["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]},"series":[{"data":[112.0,118.0,132.0,129.0,121.0,135.0,148.0,148.0,136.0,119.0,104.0,118.0],"type":"line","name":"Passengers","color":"#47475C","marker":{"enabled":false},"showInLegend":false}],"defs":{"diamond":{"tagName":"marker","attributes":{"id":"diamond","markerWidth":10.0,"markerHeight":10.0,"refX":5.0,"refY":5.0,"orient":"0"},"children":[{"tagName":"path","attributes":{"d":"M 5 1 L 9 5 L 5 9 L 1 5 Z"}}]}},"annotations":[{"shapes":[{"type":"path","points":[{"xAxis":0.0,"yAxis":0.0,"x":7,"y":109.0},{"xAxis":0.0,"yAxis":0.0,"x":10,"y":104.0}],"stroke":"#B44816","strokeWidth":2.0,"fill":"none","markerEnd":"diamond"}]}]},"theme":{"symbols":["circle","circle","circle","circle","circle"],"colors":["#47475c","#61BC7B","#508CC8","#F49952","#9C9EDB","#6699a1"],"chart":{"style":{"fontFamily":"IBM Plex Sans","color":"#666666"}},"title":{"align":"left","style":{"fontFamily":"Alegreya Sans SC","fontSize":"24px","fontWeight":"normal"}},"subtitle":{"align":"left","style":{"fontFamily":"IBM Plex Sans","fontSize":"16px"}},"caption":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"14px"}},"credits":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"10px"}},"legend":{"align":"right","verticalAlign":"bottom","itemStyle":{"fontWeight":"normal","color":"#666666"}},"xAxis":{"gridLineWidth":1,"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"yAxis":{"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"plotOptions":{"series":{"dataLabels":{"style":{"fontWeight":"normal"}}},"line":{"marker":{"enabled":false}},"spline":{"marker":{"enabled":false}},"area":{"marker":{"enabled":false}},"areaspline":{"marker":{"enabled":false}},"arearange":{"marker":{"enabled":false}},"bubble":{"maxSize":"10%"}},"tooltip":{"className":"highcharter-regular-tooltip","valueDecimals":2.0}},"conf_opts":{"lang":{"locale":"en"}},"type":"chart"},"evals":[],"jsHooks":[]}
```
