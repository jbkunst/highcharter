# zAxis options for highcharter objects

The Z axis or depth axis for 3D plots.

## Usage

``` r
hc_zAxis(hc, ...)
```

## Arguments

- hc:

  A `highchart` `htmlwidget` object.

- ...:

  Options defined in <https://api.highcharts.com/highcharts/zAxis>.

## Details

See the Axis class for programmatic access to the axis.

Named options update the first axis. Supply unnamed axis lists,
individually or in one list, to replace the collection. Series can
select an axis by ID.

## Examples

``` r
df <- data.frame(
  x = sample(1:5),
  y = sample(1:5),
  z = sample(1:5)
)

highchart() |>
  hc_add_series(data = df, "scatter3d", hcaes(x = x, y = y, z = z)) |>
  hc_chart(
    type = "scatter3d",
    options3d = list(
      enabled = TRUE,
      alpha = 20,
      beta = 30,
      depth = 200,
      viewDistance = 5,
      frame = list(
        bottom = list(
          size = 1,
          color = "rgba(0,0,0,0.05)"
        )
      )
    )
  ) |>
  hc_zAxis(
    title = list(text = "Z axis is here"),
    startOnTick = FALSE,
    tickInterval = 2,
    tickLength = 4,
    tickWidth = 1,
    gridLineColor = "red",
    gridLineDashStyle = "dot"
  )

{"x":{"hc_opts":{"chart":{"reflow":true,"type":"scatter3d","options3d":{"enabled":true,"alpha":20.0,"beta":30.0,"depth":200.0,"viewDistance":5.0,"frame":{"bottom":{"size":1.0,"color":"rgba(0,0,0,0.05)"}}}},"title":{"text":null},"yAxis":{"title":{"text":null}},"credits":{"enabled":false},"exporting":{"enabled":false},"boost":{"enabled":false},"plotOptions":{"series":{"label":{"enabled":false},"turboThreshold":0.0},"treemap":{"layoutAlgorithm":"squarified","levels":[{"level":1,"colorByPoint":true}]},"sunburst":{"levels":[{"level":1,"colorByPoint":true}]}},"series":[{"group":"group","data":[{"x":2,"y":1,"z":5},{"x":5,"y":3,"z":4},{"x":4,"y":5,"z":2},{"x":3,"y":2,"z":3},{"x":1,"y":4,"z":1}],"type":"scatter3d"}],"zAxis":{"title":{"text":"Z axis is here"},"startOnTick":false,"tickInterval":2.0,"tickLength":4.0,"tickWidth":1.0,"gridLineColor":"red","gridLineDashStyle":"dot"}},"theme":{"symbols":["circle","circle","circle","circle","circle"],"colors":["#47475c","#61BC7B","#508CC8","#F49952","#9C9EDB","#6699a1"],"chart":{"style":{"fontFamily":"IBM Plex Sans","color":"#666666"}},"title":{"align":"left","style":{"fontFamily":"Alegreya Sans SC","fontSize":"24px","fontWeight":"normal"}},"subtitle":{"align":"left","style":{"fontFamily":"IBM Plex Sans","fontSize":"16px"}},"caption":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"14px"}},"credits":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"10px"}},"legend":{"align":"right","verticalAlign":"bottom","itemStyle":{"fontWeight":"normal","color":"#666666"}},"xAxis":{"gridLineWidth":1,"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"yAxis":{"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"plotOptions":{"series":{"dataLabels":{"style":{"fontWeight":"normal"}}},"line":{"marker":{"enabled":false}},"spline":{"marker":{"enabled":false}},"area":{"marker":{"enabled":false}},"areaspline":{"marker":{"enabled":false}},"arearange":{"marker":{"enabled":false}},"bubble":{"maxSize":"10%"}},"tooltip":{"className":"highcharter-regular-tooltip","valueDecimals":2.0}},"conf_opts":{"lang":{"locale":"en"}},"type":"chart"},"evals":[],"jsHooks":[]}
```
