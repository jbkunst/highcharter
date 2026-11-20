# hc_add_series for data frames objects

hc_add_series for data frames objects

## Usage

``` r
# S3 method for class 'data.frame'
hc_add_series(hc, data, type = NULL, mapping = hcaes(), ...)
```

## Arguments

- hc:

  A `highchart` `htmlwidget` object.

- data:

  A `data.frame` object.

- type:

  The type of the series: line, bar, etc.

- mapping:

  The mapping, same idea as `ggplot2`.

- ...:

  Arguments defined in <https://api.highcharts.com/highcharts/chart>.

## Examples

``` r
# Add a band using point options specific to range charts.
intervals <- data.frame(day = as.Date("2025-01-01") + 0:2,
                        estimate = c(10, 12, 11), se = c(1, 2, 1))
highchart() |>
  hc_add_series(intervals, "arearange",
    hcaes(day, low = estimate - se, high = estimate + se), name = "Range") |>
  hc_add_series(intervals, "line", hcaes(day, estimate), name = "Estimate")

{"x":{"hc_opts":{"chart":{"reflow":true},"title":{"text":null},"yAxis":{"title":{"text":null}},"credits":{"enabled":false},"exporting":{"enabled":false},"boost":{"enabled":false},"plotOptions":{"series":{"label":{"enabled":false},"turboThreshold":0.0},"treemap":{"layoutAlgorithm":"squarified","levels":[{"level":1,"colorByPoint":true}]},"sunburst":{"levels":[{"level":1,"colorByPoint":true}]}},"series":[{"group":"group","data":[{"day":"2025-01-01","estimate":10.0,"se":1.0,"x":1735689600000.0,"low":9.0,"high":11.0},{"day":"2025-01-02","estimate":12.0,"se":2.0,"x":1735776000000.0,"low":10.0,"high":14.0},{"day":"2025-01-03","estimate":11.0,"se":1.0,"x":1735862400000.0,"low":10.0,"high":12.0}],"type":"arearange","name":"Range"},{"group":"group","data":[{"day":"2025-01-01","estimate":10.0,"se":1.0,"x":1735689600000.0,"y":10.0},{"day":"2025-01-02","estimate":12.0,"se":2.0,"x":1735776000000.0,"y":12.0},{"day":"2025-01-03","estimate":11.0,"se":1.0,"x":1735862400000.0,"y":11.0}],"type":"line","name":"Estimate"}]},"theme":{"symbols":["circle","circle","circle","circle","circle"],"colors":["#47475c","#61BC7B","#508CC8","#F49952","#9C9EDB","#6699a1"],"chart":{"style":{"fontFamily":"IBM Plex Sans","color":"#666666"}},"title":{"align":"left","style":{"fontFamily":"Alegreya Sans SC","fontSize":"24px","fontWeight":"normal"}},"subtitle":{"align":"left","style":{"fontFamily":"IBM Plex Sans","fontSize":"16px"}},"caption":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"14px"}},"credits":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"10px"}},"legend":{"align":"right","verticalAlign":"bottom","itemStyle":{"fontWeight":"normal","color":"#666666"}},"xAxis":{"gridLineWidth":1,"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"yAxis":{"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"plotOptions":{"series":{"dataLabels":{"style":{"fontWeight":"normal"}}},"line":{"marker":{"enabled":false}},"spline":{"marker":{"enabled":false}},"area":{"marker":{"enabled":false}},"areaspline":{"marker":{"enabled":false}},"arearange":{"marker":{"enabled":false}},"bubble":{"maxSize":"10%"}},"tooltip":{"className":"highcharter-regular-tooltip","valueDecimals":2.0}},"conf_opts":{"lang":{"locale":"en"}},"type":"chart"},"evals":[],"jsHooks":[]}
```
