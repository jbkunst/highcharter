# Helper to transform data frame for boxplot highcharts format

Helper to transform data frame for boxplot highcharts format

## Usage

``` r
data_to_boxplot(
  data,
  variable,
  group_var = NULL,
  group_var2 = NULL,
  add_outliers = FALSE,
  ...
)
```

## Arguments

- data:

  The data frame containing variables.

- variable:

  The variable to calculate the box plot data.

- group_var:

  A variable to split calculation

- group_var2:

  A second variable to create separate series.

- add_outliers:

  A logical value indicating if outliers series should be calculated.
  Default to `FALSE`.

- ...:

  Arguments defined in
  <https://api.highcharts.com/highcharts/plotOptions.series>.

## Examples

``` r

data(pokemon)

dat <- data_to_boxplot(pokemon, height)

highchart() |>
  hc_xAxis(type = "category") |>
  hc_add_series_list(dat)

{"x":{"hc_opts":{"chart":{"reflow":true},"title":{"text":null},"yAxis":{"title":{"text":null}},"credits":{"enabled":false},"exporting":{"enabled":false},"boost":{"enabled":false},"plotOptions":{"series":{"label":{"enabled":false},"turboThreshold":0.0},"treemap":{"layoutAlgorithm":"squarified","levels":[{"level":1,"colorByPoint":true}]},"sunburst":{"levels":[{"level":1,"colorByPoint":true}]}},"xAxis":{"type":"category"},"series":[{"name":null,"data":[{"name":0.0,"low":1.0,"q1":5.0,"median":10.0,"q3":15.0,"high":30.0,"x":0}],"id":null,"type":"boxplot"}]},"theme":{"symbols":["circle","circle","circle","circle","circle"],"colors":["#47475c","#61BC7B","#508CC8","#F49952","#9C9EDB","#6699a1"],"chart":{"style":{"fontFamily":"IBM Plex Sans","color":"#666666"}},"title":{"align":"left","style":{"fontFamily":"Alegreya Sans SC","fontSize":"24px","fontWeight":"normal"}},"subtitle":{"align":"left","style":{"fontFamily":"IBM Plex Sans","fontSize":"16px"}},"caption":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"14px"}},"credits":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"10px"}},"legend":{"align":"right","verticalAlign":"bottom","itemStyle":{"fontWeight":"normal","color":"#666666"}},"xAxis":{"gridLineWidth":1,"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"yAxis":{"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"plotOptions":{"series":{"dataLabels":{"style":{"fontWeight":"normal"}}},"line":{"marker":{"enabled":false}},"spline":{"marker":{"enabled":false}},"area":{"marker":{"enabled":false}},"areaspline":{"marker":{"enabled":false}},"arearange":{"marker":{"enabled":false}},"bubble":{"maxSize":"10%"}},"tooltip":{"className":"highcharter-regular-tooltip","valueDecimals":2.0}},"conf_opts":{"lang":{"locale":"en"}},"type":"chart"},"evals":[],"jsHooks":[]}
dat <- data_to_boxplot(pokemon, height / 10, type_1, name = "Height (m)")

highchart() |>
  hc_xAxis(type = "category") |>
  hc_add_series_list(dat)

{"x":{"hc_opts":{"chart":{"reflow":true},"title":{"text":null},"yAxis":{"title":{"text":null}},"credits":{"enabled":false},"exporting":{"enabled":false},"boost":{"enabled":false},"plotOptions":{"series":{"label":{"enabled":false},"turboThreshold":0.0},"treemap":{"layoutAlgorithm":"squarified","levels":[{"level":1,"colorByPoint":true}]},"sunburst":{"levels":[{"level":1,"colorByPoint":true}]}},"xAxis":{"type":"category"},"series":[{"name":"Height (m)","data":[{"name":"bug","low":0.1,"q1":0.4,"median":0.8,"q3":1.2,"high":2.4,"x":0},{"name":"dark","low":0.4,"q1":0.6,"median":1.05,"q3":1.5,"high":1.8,"x":1},{"name":"dragon","low":0.3,"q1":1.05,"median":1.6,"q3":2.15,"high":3.2,"x":2},{"name":"electric","low":0.2,"q1":0.4,"median":0.8,"q3":1.5,"high":2.3,"x":3},{"name":"fairy","low":0.1,"q1":0.3,"median":0.6,"q3":1.1,"high":1.5,"x":4},{"name":"fighting","low":0.5,"q1":0.7,"median":1.25,"q3":1.55,"high":2.3,"x":5},{"name":"fire","low":0.3,"q1":0.6,"median":1.0,"q3":1.7,"high":3.0,"x":6},{"name":"flying","low":0.2,"q1":0.65,"median":0.8,"q3":1.5,"high":2.2,"x":7},{"name":"ghost","low":0.1,"q1":0.5,"median":1.0,"q3":1.5,"high":2.2,"x":8},{"name":"grass","low":0.2,"q1":0.4,"median":0.8,"q3":1.2,"high":2.2,"x":9},{"name":"ground","low":0.2,"q1":0.7,"median":1.0,"q3":1.95,"high":3.8,"x":10},{"name":"ice","low":0.3,"q1":0.8,"median":1.2,"q3":1.5,"high":2.5,"x":11},{"name":"normal","low":0.2,"q1":0.5,"median":0.9,"q3":1.3,"high":2.3,"x":12},{"name":"poison","low":0.4,"q1":0.6,"median":1.0,"q3":1.65,"high":2.7,"x":13},{"name":"psychic","low":0.1,"q1":0.4,"median":0.8500000000000001,"q3":1.4,"high":2.4,"x":14},{"name":"rock","low":0.3,"q1":0.6,"median":1.15,"q3":1.5,"high":2.8,"x":15},{"name":"steel","low":0.2,"q1":0.6,"median":1.1,"q3":1.9,"high":3.0,"x":16},{"name":"water","low":0.2,"q1":0.6,"median":1.0,"q3":1.5,"high":2.5,"x":17}],"id":null,"type":"boxplot"}]},"theme":{"symbols":["circle","circle","circle","circle","circle"],"colors":["#47475c","#61BC7B","#508CC8","#F49952","#9C9EDB","#6699a1"],"chart":{"style":{"fontFamily":"IBM Plex Sans","color":"#666666"}},"title":{"align":"left","style":{"fontFamily":"Alegreya Sans SC","fontSize":"24px","fontWeight":"normal"}},"subtitle":{"align":"left","style":{"fontFamily":"IBM Plex Sans","fontSize":"16px"}},"caption":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"14px"}},"credits":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"10px"}},"legend":{"align":"right","verticalAlign":"bottom","itemStyle":{"fontWeight":"normal","color":"#666666"}},"xAxis":{"gridLineWidth":1,"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"yAxis":{"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"plotOptions":{"series":{"dataLabels":{"style":{"fontWeight":"normal"}}},"line":{"marker":{"enabled":false}},"spline":{"marker":{"enabled":false}},"area":{"marker":{"enabled":false}},"areaspline":{"marker":{"enabled":false}},"arearange":{"marker":{"enabled":false}},"bubble":{"maxSize":"10%"}},"tooltip":{"className":"highcharter-regular-tooltip","valueDecimals":2.0}},"conf_opts":{"lang":{"locale":"en"}},"type":"chart"},"evals":[],"jsHooks":[]}if (FALSE) { # \dontrun{

} # }
```
