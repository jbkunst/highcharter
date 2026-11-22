# Arrange pairs of axes in a grid

Each panel has its own x-axis and y-axis with the same index. Indices
start at zero and run from left to right across each row. To add a
series to a panel, pass its index to both axis arguments of
[`hc_add_series()`](https://jkunst.com/highcharter/reference/hc_add_series.md).
Several series can share a panel.

## Usage

``` r
hc_gridAxis(hc, nrow, ncol, xAxis = list(), yAxis = list())
```

## Arguments

- hc:

  A `highchart` widget.

- nrow, ncol:

  Number of rows and columns in the grid.

- xAxis, yAxis:

  A named list of Highcharts axis options for every panel, or an unnamed
  list with one option list per panel in row order.

## Value

The widget with its x-axis and y-axis collections set to the grid.

## Examples

``` r
highchart() |>
  hc_gridAxis(1, 2) |>
  hc_add_series(data = c(1, 3, 2), name = "First", xAxis = 0, yAxis = 0) |>
  hc_add_series(data = c(4, 2, 5), name = "Second", xAxis = 1, yAxis = 1)

{"x":{"hc_opts":{"chart":{"reflow":true,"alignTicks":false},"title":{"text":null},"yAxis":[{"left":"0%","top":"0%","width":"44.4444444444444%","height":"100%","offset":0.0,"title":{"text":null}},{"left":"55.5555555555556%","top":"0%","width":"44.4444444444444%","height":"100%","offset":0.0,"title":{"text":null}}],"credits":{"enabled":false},"exporting":{"enabled":false},"boost":{"enabled":false},"plotOptions":{"series":{"label":{"enabled":false},"turboThreshold":0.0},"treemap":{"layoutAlgorithm":"squarified","levels":[{"level":1,"colorByPoint":true}]},"sunburst":{"levels":[{"level":1,"colorByPoint":true}]}},"xAxis":[{"left":"0%","top":"0%","width":"44.4444444444444%","height":"100%","offset":0.0,"title":{"text":null}},{"left":"55.5555555555556%","top":"0%","width":"44.4444444444444%","height":"100%","offset":0.0,"title":{"text":null}}],"series":[{"data":[1.0,3.0,2.0],"name":"First","xAxis":0.0,"yAxis":0.0},{"data":[4.0,2.0,5.0],"name":"Second","xAxis":1.0,"yAxis":1.0}]},"theme":{"symbols":["circle","circle","circle","circle","circle"],"colors":["#47475c","#61BC7B","#508CC8","#F49952","#9C9EDB","#6699a1"],"chart":{"style":{"fontFamily":"IBM Plex Sans","color":"#666666"}},"title":{"align":"left","style":{"fontFamily":"Alegreya Sans SC","fontSize":"24px","fontWeight":"normal"}},"subtitle":{"align":"left","style":{"fontFamily":"IBM Plex Sans","fontSize":"16px"}},"caption":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"14px"}},"credits":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"10px"}},"legend":{"align":"right","verticalAlign":"bottom","itemStyle":{"fontWeight":"normal","color":"#666666"}},"xAxis":{"gridLineWidth":1,"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"yAxis":{"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"plotOptions":{"series":{"dataLabels":{"style":{"fontWeight":"normal"}}},"line":{"marker":{"enabled":false}},"spline":{"marker":{"enabled":false}},"area":{"marker":{"enabled":false}},"areaspline":{"marker":{"enabled":false}},"arearange":{"marker":{"enabled":false}},"bubble":{"maxSize":"10%"}},"tooltip":{"className":"highcharter-regular-tooltip","valueDecimals":2.0}},"conf_opts":{"lang":{"locale":"en"}},"type":"chart"},"evals":[],"jsHooks":[]}
```
