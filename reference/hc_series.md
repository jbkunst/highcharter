# Series options for highcharter objects

Series options for specific data and the data itself. In TypeScript you
have to cast the series options to specific series types, to get all
possible options for a series. (see online documentation for example)

## Usage

``` r
hc_series(hc, ...)
```

## Arguments

- hc:

  A `highchart` `htmlwidget` object.

- ...:

  Options defined in <https://api.highcharts.com/highcharts/series>.

## Examples

``` r
# Fictional orders: distinguish a forecast with a shared color and a dashed line.
highchart() |>
  hc_title(text = "Cafe orders: observed and forecast") |>
  hc_xAxis(categories = month.abb[1:6]) |>
  hc_yAxis(title = list(text = "Orders")) |>
  hc_series(
    list(
      name = "Observed",
      color = "#0072B2",
      data = c(120, 150, 180, 160)
    ),
    list(
      name = "Forecast",
      color = "#0072B2",
      dashStyle = "Dash",
      pointStart = 3,
      data = c(160, 190, 210)
    )
  )

{"x":{"hc_opts":{"chart":{"reflow":true},"title":{"text":"Cafe orders: observed and forecast"},"yAxis":{"title":{"text":"Orders"}},"credits":{"enabled":false},"exporting":{"enabled":false},"boost":{"enabled":false},"plotOptions":{"series":{"label":{"enabled":false},"turboThreshold":0.0},"treemap":{"layoutAlgorithm":"squarified","levels":[{"level":1,"colorByPoint":true}]},"sunburst":{"levels":[{"level":1,"colorByPoint":true}]}},"xAxis":{"categories":["Jan","Feb","Mar","Apr","May","Jun"]},"series":[{"name":"Observed","color":"#0072B2","data":[120.0,150.0,180.0,160.0]},{"name":"Forecast","color":"#0072B2","dashStyle":"Dash","pointStart":3.0,"data":[160.0,190.0,210.0]}]},"theme":{"symbols":["circle","circle","circle","circle","circle"],"colors":["#47475c","#61BC7B","#508CC8","#F49952","#9C9EDB","#6699a1"],"chart":{"style":{"fontFamily":"IBM Plex Sans","color":"#666666"}},"title":{"align":"left","style":{"fontFamily":"Alegreya Sans SC","fontSize":"24px","fontWeight":"normal"}},"subtitle":{"align":"left","style":{"fontFamily":"IBM Plex Sans","fontSize":"16px"}},"caption":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"14px"}},"credits":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"10px"}},"legend":{"align":"right","verticalAlign":"bottom","itemStyle":{"fontWeight":"normal","color":"#666666"}},"xAxis":{"gridLineWidth":1,"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"yAxis":{"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"plotOptions":{"series":{"dataLabels":{"style":{"fontWeight":"normal"}}},"line":{"marker":{"enabled":false}},"spline":{"marker":{"enabled":false}},"area":{"marker":{"enabled":false}},"areaspline":{"marker":{"enabled":false}},"arearange":{"marker":{"enabled":false}},"bubble":{"maxSize":"10%"}},"tooltip":{"className":"highcharter-regular-tooltip","valueDecimals":2.0}},"conf_opts":{"lang":{"locale":"en"}},"type":"chart"},"evals":[],"jsHooks":[]}
```
