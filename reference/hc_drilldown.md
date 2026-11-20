# Drilldown options for highcharter objects

Options for drill down, the concept of inspecting increasingly high
resolution data through clicking on chart items like columns or pie
slices.

## Usage

``` r
hc_drilldown(hc, ...)
```

## Arguments

- hc:

  A `highchart` `htmlwidget` object.

- ...:

  Options defined in <https://api.highcharts.com/highcharts/drilldown>.

## Examples

``` r
items <- data.frame(
  category = c(rep("Animals", 5), rep("Fruits", 2)),
  name = c("Cats", "Dogs", "Cows", "Sheep", "Pigs", "Apples", "Oranges"),
  y = c(4, 3, 1, 2, 1, 4, 2)
)
totals <- aggregate(y ~ category, items, sum)
detail <- lapply(totals$category, function(category) {
  rows <- items[items$category == category, c("name", "y")]
  list(id = category, name = category, data = list_parse(rows))
})

# Click a total to see the items that make it up. The breadcrumb takes you back.
highchart() |>
  hc_chart(type = "column") |>
  hc_title(text = "Item counts by category") |>
  hc_xAxis(type = "category") |>
  hc_yAxis(title = list(text = "Count")) |>
  hc_legend(enabled = FALSE) |>
  hc_add_series(
    totals,
    "column",
    hcaes(name = category, y = y, drilldown = category),
    name = "Items",
    colorByPoint = TRUE
  ) |>
  hc_drilldown(series = detail)

{"x":{"hc_opts":{"chart":{"reflow":true,"type":"column"},"title":{"text":"Item counts by category"},"yAxis":{"title":{"text":"Count"}},"credits":{"enabled":false},"exporting":{"enabled":false},"boost":{"enabled":false},"plotOptions":{"series":{"label":{"enabled":false},"turboThreshold":0.0},"treemap":{"layoutAlgorithm":"squarified","levels":[{"level":1,"colorByPoint":true}]},"sunburst":{"levels":[{"level":1,"colorByPoint":true}]}},"xAxis":{"type":"category"},"legend":{"enabled":false},"series":[{"group":"group","data":[{"category":"Animals","y":11.0,"name":"Animals","drilldown":"Animals"},{"category":"Fruits","y":6.0,"name":"Fruits","drilldown":"Fruits"}],"type":"column","name":"Items","colorByPoint":true}],"drilldown":{"series":[{"id":"Animals","name":"Animals","data":[{"name":"Cats","y":4.0},{"name":"Dogs","y":3.0},{"name":"Cows","y":1.0},{"name":"Sheep","y":2.0},{"name":"Pigs","y":1.0}]},{"id":"Fruits","name":"Fruits","data":[{"name":"Apples","y":4.0},{"name":"Oranges","y":2.0}]}]}},"theme":{"symbols":["circle","circle","circle","circle","circle"],"colors":["#47475c","#61BC7B","#508CC8","#F49952","#9C9EDB","#6699a1"],"chart":{"style":{"fontFamily":"IBM Plex Sans","color":"#666666"}},"title":{"align":"left","style":{"fontFamily":"Alegreya Sans SC","fontSize":"24px","fontWeight":"normal"}},"subtitle":{"align":"left","style":{"fontFamily":"IBM Plex Sans","fontSize":"16px"}},"caption":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"14px"}},"credits":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"10px"}},"legend":{"align":"right","verticalAlign":"bottom","itemStyle":{"fontWeight":"normal","color":"#666666"}},"xAxis":{"gridLineWidth":1,"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"yAxis":{"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"plotOptions":{"series":{"dataLabels":{"style":{"fontWeight":"normal"}}},"line":{"marker":{"enabled":false}},"spline":{"marker":{"enabled":false}},"area":{"marker":{"enabled":false}},"areaspline":{"marker":{"enabled":false}},"arearange":{"marker":{"enabled":false}},"bubble":{"maxSize":"10%"}},"tooltip":{"className":"highcharter-regular-tooltip","valueDecimals":2.0}},"conf_opts":{"lang":{"locale":"en"}},"type":"chart"},"evals":[],"jsHooks":[]}
```
