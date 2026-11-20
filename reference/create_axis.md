# Arrange vertical axes in stacked panels

Arrange vertical axes in stacked panels

## Usage

``` r
create_axis(
  naxis = 2,
  heights = 1,
  sep = 0.01,
  offset = 0,
  turnopposite = TRUE,
  ...
)
```

## Arguments

- naxis:

  Number of axis an integer.

- heights:

  A numeric vector. This values will be normalized.

- sep:

  A numeric value for the separation (in percentage) for the panes.

- offset:

  A numeric value (in percentage).

- turnopposite:

  A logical value to turn the side of each axis or not.

- ...:

  Arguments defined in <https://api.highcharts.com/highcharts/yAxis>.

## Examples

``` r

highchart() |>
  hc_yAxis(create_axis(naxis = 2, heights = c(2, 1))) |>
  hc_add_series(data = c(1, 3, 2), yAxis = 0) |>
  hc_add_series(data = c(20, 40, 10), yAxis = 1)

{"x":{"hc_opts":{"chart":{"reflow":true},"title":{"text":null},"yAxis":[{"height":"66.0066%","top":"0%","offset":0.0,"opposite":false},{"height":"33.0033%","top":"66.9967%","offset":0.0,"opposite":true}],"credits":{"enabled":false},"exporting":{"enabled":false},"boost":{"enabled":false},"plotOptions":{"series":{"label":{"enabled":false},"turboThreshold":0.0},"treemap":{"layoutAlgorithm":"squarified","levels":[{"level":1,"colorByPoint":true}]},"sunburst":{"levels":[{"level":1,"colorByPoint":true}]}},"series":[{"data":[1.0,3.0,2.0],"yAxis":0.0},{"data":[20.0,40.0,10.0],"yAxis":1.0}]},"theme":{"symbols":["circle","circle","circle","circle","circle"],"colors":["#47475c","#61BC7B","#508CC8","#F49952","#9C9EDB","#6699a1"],"chart":{"style":{"fontFamily":"IBM Plex Sans","color":"#666666"}},"title":{"align":"left","style":{"fontFamily":"Alegreya Sans SC","fontSize":"24px","fontWeight":"normal"}},"subtitle":{"align":"left","style":{"fontFamily":"IBM Plex Sans","fontSize":"16px"}},"caption":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"14px"}},"credits":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"10px"}},"legend":{"align":"right","verticalAlign":"bottom","itemStyle":{"fontWeight":"normal","color":"#666666"}},"xAxis":{"gridLineWidth":1,"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"yAxis":{"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"plotOptions":{"series":{"dataLabels":{"style":{"fontWeight":"normal"}}},"line":{"marker":{"enabled":false}},"spline":{"marker":{"enabled":false}},"area":{"marker":{"enabled":false}},"areaspline":{"marker":{"enabled":false}},"arearange":{"marker":{"enabled":false}},"bubble":{"maxSize":"10%"}},"tooltip":{"className":"highcharter-regular-tooltip","valueDecimals":2.0}},"conf_opts":{"lang":{"locale":"en"}},"type":"chart"},"evals":[],"jsHooks":[]}
highchart() |>
  hc_yAxis(create_axis(naxis = 3, lineWidth = 2, title = list(text = NULL))) |>
  hc_add_series(data = c(1, 3, 2)) |>
  hc_add_series(data = c(20, 40, 10), type = "area", yAxis = 1) |>
  hc_add_series(data = c(200, 400, 500), yAxis = 2) |>
  hc_add_series(data = c(500, 300, 400), type = "areaspline", yAxis = 2)

{"x":{"hc_opts":{"chart":{"reflow":true},"title":{"text":null},"yAxis":[{"height":"32.6797%","top":"0%","offset":0.0,"opposite":false,"lineWidth":2.0,"title":{"text":null}},{"height":"32.6797%","top":"33.6601%","offset":0.0,"opposite":true,"lineWidth":2.0,"title":{"text":null}},{"height":"32.6797%","top":"67.3203%","offset":0.0,"opposite":false,"lineWidth":2.0,"title":{"text":null}}],"credits":{"enabled":false},"exporting":{"enabled":false},"boost":{"enabled":false},"plotOptions":{"series":{"label":{"enabled":false},"turboThreshold":0.0},"treemap":{"layoutAlgorithm":"squarified","levels":[{"level":1,"colorByPoint":true}]},"sunburst":{"levels":[{"level":1,"colorByPoint":true}]}},"series":[{"data":[1.0,3.0,2.0]},{"data":[20.0,40.0,10.0],"type":"area","yAxis":1.0},{"data":[200.0,400.0,500.0],"yAxis":2.0},{"data":[500.0,300.0,400.0],"type":"areaspline","yAxis":2.0}]},"theme":{"symbols":["circle","circle","circle","circle","circle"],"colors":["#47475c","#61BC7B","#508CC8","#F49952","#9C9EDB","#6699a1"],"chart":{"style":{"fontFamily":"IBM Plex Sans","color":"#666666"}},"title":{"align":"left","style":{"fontFamily":"Alegreya Sans SC","fontSize":"24px","fontWeight":"normal"}},"subtitle":{"align":"left","style":{"fontFamily":"IBM Plex Sans","fontSize":"16px"}},"caption":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"14px"}},"credits":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"10px"}},"legend":{"align":"right","verticalAlign":"bottom","itemStyle":{"fontWeight":"normal","color":"#666666"}},"xAxis":{"gridLineWidth":1,"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"yAxis":{"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"plotOptions":{"series":{"dataLabels":{"style":{"fontWeight":"normal"}}},"line":{"marker":{"enabled":false}},"spline":{"marker":{"enabled":false}},"area":{"marker":{"enabled":false}},"areaspline":{"marker":{"enabled":false}},"arearange":{"marker":{"enabled":false}},"bubble":{"maxSize":"10%"}},"tooltip":{"className":"highcharter-regular-tooltip","valueDecimals":2.0}},"conf_opts":{"lang":{"locale":"en"}},"type":"chart"},"evals":[],"jsHooks":[]}
```
