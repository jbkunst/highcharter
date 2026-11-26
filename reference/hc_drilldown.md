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
  category = c(rep("Drinks", 3), rep("Bakery", 3)),
  name = c("Espresso", "Latte", "Tea", "Croissant", "Muffin", "Cookie"),
  y = c(42, 58, 25, 35, 20, 30)
)
totals <- aggregate(y ~ category, items, sum)
detail <- lapply(totals$category, function(category) {
  rows <- items[items$category == category, c("name", "y")]
  list(id = category, name = category, data = list_parse(rows))
})

# Click a total to see the items that make it up. The breadcrumb takes you back.
highchart() |>
  hc_chart(type = "column") |>
  hc_title(text = "A day at the cafe") |>
  hc_subtitle(
    text = "Click a category to explore its orders (fictional data)"
  ) |>
  hc_xAxis(type = "category") |>
  hc_yAxis(title = list(text = "Orders")) |>
  hc_legend(enabled = FALSE) |>
  hc_add_series(
    totals,
    "column",
    hcaes(name = category, y = y, drilldown = category),
    name = "Orders",
    colorByPoint = TRUE
  ) |>
  hc_drilldown(series = detail)

{"x":{"hc_opts":{"chart":{"reflow":true,"type":"column"},"title":{"text":"A day at the cafe"},"yAxis":{"title":{"text":"Orders"}},"credits":{"enabled":false},"exporting":{"enabled":false},"boost":{"enabled":false},"plotOptions":{"series":{"label":{"enabled":false},"turboThreshold":0.0},"treemap":{"layoutAlgorithm":"squarified","levels":[{"level":1,"colorByPoint":true}]},"sunburst":{"levels":[{"level":1,"colorByPoint":true}]}},"subtitle":{"text":"Click a category to explore its orders (fictional data)"},"xAxis":{"type":"category"},"legend":{"enabled":false},"series":[{"group":"group","data":[{"category":"Bakery","y":85.0,"name":"Bakery","drilldown":"Bakery"},{"category":"Drinks","y":125.0,"name":"Drinks","drilldown":"Drinks"}],"type":"column","name":"Orders","colorByPoint":true}],"drilldown":{"series":[{"id":"Bakery","name":"Bakery","data":[{"name":"Croissant","y":35.0},{"name":"Muffin","y":20.0},{"name":"Cookie","y":30.0}]},{"id":"Drinks","name":"Drinks","data":[{"name":"Espresso","y":42.0},{"name":"Latte","y":58.0},{"name":"Tea","y":25.0}]}]}},"theme":{"symbols":["circle","circle","circle","circle","circle"],"colors":["#47475c","#61BC7B","#508CC8","#F49952","#9C9EDB","#6699a1"],"chart":{"style":{"fontFamily":"IBM Plex Sans","color":"#666666"}},"title":{"align":"left","style":{"fontFamily":"Alegreya Sans SC","fontSize":"24px","fontWeight":"normal"}},"subtitle":{"align":"left","style":{"fontFamily":"IBM Plex Sans","fontSize":"16px"}},"caption":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"14px"}},"credits":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"10px"}},"legend":{"align":"right","verticalAlign":"bottom","itemStyle":{"fontWeight":"normal","color":"#666666"}},"xAxis":{"gridLineWidth":1,"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"yAxis":{"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"plotOptions":{"series":{"dataLabels":{"style":{"fontWeight":"normal"}}},"line":{"marker":{"enabled":false}},"spline":{"marker":{"enabled":false}},"area":{"marker":{"enabled":false}},"areaspline":{"marker":{"enabled":false}},"arearange":{"marker":{"enabled":false}},"bubble":{"maxSize":"10%"}},"tooltip":{"className":"highcharter-regular-tooltip","valueDecimals":2.0}},"conf_opts":{"lang":{"locale":"en"}},"type":"chart"},"evals":[],"jsHooks":[]}
```
