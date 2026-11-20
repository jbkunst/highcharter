# yAxis options for highcharter objects

The Y axis or value axis. Normally this is the vertical axis, though if
the chart is inverted this is the horizontal axis. In case of multiple
axes, the yAxis node is an array of configuration objects.

## Usage

``` r
hc_yAxis(hc, ...)
```

## Arguments

- hc:

  A `highchart` `htmlwidget` object.

- ...:

  Options defined in <https://api.highcharts.com/highcharts/yAxis>.

## Details

See the Axis object for programmatic access to the axis.

Named options update the first axis. Supply unnamed axis lists,
individually or in one list, to replace the collection. Series can
select an axis by ID.

## Examples

``` r
highchart() |>
  hc_add_series(
    data = c(
      7.0,
      6.9,
      9.5,
      14.5,
      18.2,
      21.5,
      25.2,
      26.5,
      23.3,
      18.3,
      13.9,
      9.6
    ),
    type = "spline"
  ) |>
  hc_yAxis(
    title = list(text = "y Axis at right"),
    opposite = TRUE,
    alternateGridColor = "#FAFAFA",
    minorTickInterval = "auto",
    minorGridLineDashStyle = "LongDashDotDot",
    showFirstLabel = FALSE,
    showLastLabel = FALSE,
    plotBands = list(
      list(
        from = 13,
        to = 17,
        color = "rgba(100, 0, 0, 0.1)",
        label = list(text = "This is a plotBand")
      )
    )
  )

{"x":{"hc_opts":{"chart":{"reflow":true},"title":{"text":null},"yAxis":{"title":{"text":"y Axis at right"},"opposite":true,"alternateGridColor":"#FAFAFA","minorTickInterval":"auto","minorGridLineDashStyle":"LongDashDotDot","showFirstLabel":false,"showLastLabel":false,"plotBands":[{"from":13.0,"to":17.0,"color":"rgba(100, 0, 0, 0.1)","label":{"text":"This is a plotBand"}}]},"credits":{"enabled":false},"exporting":{"enabled":false},"boost":{"enabled":false},"plotOptions":{"series":{"label":{"enabled":false},"turboThreshold":0.0},"treemap":{"layoutAlgorithm":"squarified","levels":[{"level":1,"colorByPoint":true}]},"sunburst":{"levels":[{"level":1,"colorByPoint":true}]}},"series":[{"data":[7.0,6.9,9.5,14.5,18.2,21.5,25.2,26.5,23.3,18.3,13.9,9.6],"type":"spline"}]},"theme":{"symbols":["circle","circle","circle","circle","circle"],"colors":["#47475c","#61BC7B","#508CC8","#F49952","#9C9EDB","#6699a1"],"chart":{"style":{"fontFamily":"IBM Plex Sans","color":"#666666"}},"title":{"align":"left","style":{"fontFamily":"Alegreya Sans SC","fontSize":"24px","fontWeight":"normal"}},"subtitle":{"align":"left","style":{"fontFamily":"IBM Plex Sans","fontSize":"16px"}},"caption":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"14px"}},"credits":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"10px"}},"legend":{"align":"right","verticalAlign":"bottom","itemStyle":{"fontWeight":"normal","color":"#666666"}},"xAxis":{"gridLineWidth":1,"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"yAxis":{"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"plotOptions":{"series":{"dataLabels":{"style":{"fontWeight":"normal"}}},"line":{"marker":{"enabled":false}},"spline":{"marker":{"enabled":false}},"area":{"marker":{"enabled":false}},"areaspline":{"marker":{"enabled":false}},"arearange":{"marker":{"enabled":false}},"bubble":{"maxSize":"10%"}},"tooltip":{"className":"highcharter-regular-tooltip","valueDecimals":2.0}},"conf_opts":{"lang":{"locale":"en"}},"type":"chart"},"evals":[],"jsHooks":[]}
# Independent scales for two series in the same plotting area.
highchart() |>
  hc_yAxis(
    list(id = "sales", title = list(text = "Sales ($)")),
    list(id = "margin", title = list(text = "Margin (%)"), opposite = TRUE)
  ) |>
  hc_add_series(data = c(100, 125, 120), name = "Sales", yAxis = "sales") |>
  hc_add_series(data = c(15, 18, 16), name = "Margin", yAxis = "margin")

{"x":{"hc_opts":{"chart":{"reflow":true},"title":{"text":null},"yAxis":[{"id":"sales","title":{"text":"Sales ($)"}},{"id":"margin","title":{"text":"Margin (%)"},"opposite":true}],"credits":{"enabled":false},"exporting":{"enabled":false},"boost":{"enabled":false},"plotOptions":{"series":{"label":{"enabled":false},"turboThreshold":0.0},"treemap":{"layoutAlgorithm":"squarified","levels":[{"level":1,"colorByPoint":true}]},"sunburst":{"levels":[{"level":1,"colorByPoint":true}]}},"series":[{"data":[100.0,125.0,120.0],"name":"Sales","yAxis":"sales"},{"data":[15.0,18.0,16.0],"name":"Margin","yAxis":"margin"}]},"theme":{"symbols":["circle","circle","circle","circle","circle"],"colors":["#47475c","#61BC7B","#508CC8","#F49952","#9C9EDB","#6699a1"],"chart":{"style":{"fontFamily":"IBM Plex Sans","color":"#666666"}},"title":{"align":"left","style":{"fontFamily":"Alegreya Sans SC","fontSize":"24px","fontWeight":"normal"}},"subtitle":{"align":"left","style":{"fontFamily":"IBM Plex Sans","fontSize":"16px"}},"caption":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"14px"}},"credits":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"10px"}},"legend":{"align":"right","verticalAlign":"bottom","itemStyle":{"fontWeight":"normal","color":"#666666"}},"xAxis":{"gridLineWidth":1,"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"yAxis":{"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"plotOptions":{"series":{"dataLabels":{"style":{"fontWeight":"normal"}}},"line":{"marker":{"enabled":false}},"spline":{"marker":{"enabled":false}},"area":{"marker":{"enabled":false}},"areaspline":{"marker":{"enabled":false}},"arearange":{"marker":{"enabled":false}},"bubble":{"maxSize":"10%"}},"tooltip":{"className":"highcharter-regular-tooltip","valueDecimals":2.0}},"conf_opts":{"lang":{"locale":"en"}},"type":"chart"},"evals":[],"jsHooks":[]}
```
