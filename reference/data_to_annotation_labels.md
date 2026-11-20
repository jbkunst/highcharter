# Convert data to annotation labels

Convert data to annotation labels

## Usage

``` r
data_to_annotation_labels(data, xAxis = 0, yAxis = 0)
```

## Arguments

- data:

  A data frame with columns `x`, `y` and `text`. Each row defines one
  label. Additional columns supply label options such as
  `backgroundColor`.

- xAxis, yAxis:

  Axis index (starting at zero) or axis ID for the points.

## Value

A list for the `labels` option of
[`hc_add_annotation()`](https://jkunst.com/highcharter/reference/hc_add_annotation.md).

## Examples

``` r
peaks <- data.frame(x = c(0, 2), y = c(5, 6), text = c("Start", "Peak"))
highchart() |>
  hc_add_series(data = c(5, 3, 6)) |>
  hc_add_annotation(labels = data_to_annotation_labels(peaks))

{"x":{"hc_opts":{"chart":{"reflow":true},"title":{"text":null},"yAxis":{"title":{"text":null}},"credits":{"enabled":false},"exporting":{"enabled":false},"boost":{"enabled":false},"plotOptions":{"series":{"label":{"enabled":false},"turboThreshold":0.0},"treemap":{"layoutAlgorithm":"squarified","levels":[{"level":1,"colorByPoint":true}]},"sunburst":{"levels":[{"level":1,"colorByPoint":true}]}},"series":[{"data":[5.0,3.0,6.0]}],"annotations":[{"labels":[{"text":"Start","point":{"x":0.0,"y":5.0,"xAxis":0.0,"yAxis":0.0}},{"text":"Peak","point":{"x":2.0,"y":6.0,"xAxis":0.0,"yAxis":0.0}}]}]},"theme":{"symbols":["circle","circle","circle","circle","circle"],"colors":["#47475c","#61BC7B","#508CC8","#F49952","#9C9EDB","#6699a1"],"chart":{"style":{"fontFamily":"IBM Plex Sans","color":"#666666"}},"title":{"align":"left","style":{"fontFamily":"Alegreya Sans SC","fontSize":"24px","fontWeight":"normal"}},"subtitle":{"align":"left","style":{"fontFamily":"IBM Plex Sans","fontSize":"16px"}},"caption":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"14px"}},"credits":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"10px"}},"legend":{"align":"right","verticalAlign":"bottom","itemStyle":{"fontWeight":"normal","color":"#666666"}},"xAxis":{"gridLineWidth":1,"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"yAxis":{"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"plotOptions":{"series":{"dataLabels":{"style":{"fontWeight":"normal"}}},"line":{"marker":{"enabled":false}},"spline":{"marker":{"enabled":false}},"area":{"marker":{"enabled":false}},"areaspline":{"marker":{"enabled":false}},"arearange":{"marker":{"enabled":false}},"bubble":{"maxSize":"10%"}},"tooltip":{"className":"highcharter-regular-tooltip","valueDecimals":2.0}},"conf_opts":{"lang":{"locale":"en"}},"type":"chart"},"evals":[],"jsHooks":[]}
```
