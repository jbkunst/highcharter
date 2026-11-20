# Apply a theme to a chart

Apply a theme to a chart

## Usage

``` r
hc_add_theme(hc, hc_thm)
```

## Arguments

- hc:

  A highchart widget.

- hc_thm:

  A theme built with
  [`hc_theme()`](https://jkunst.com/highcharter/reference/hc_theme.md).

## Value

The widget with the selected theme.

## Examples

``` r
highchart() |>
  hc_add_series(data = c(7, 5, 9)) |>
  hc_add_theme(hc_theme("ft"))

{"x":{"hc_opts":{"chart":{"reflow":true},"title":{"text":null},"yAxis":{"title":{"text":null}},"credits":{"enabled":false},"exporting":{"enabled":false},"boost":{"enabled":false},"plotOptions":{"series":{"label":{"enabled":false},"turboThreshold":0.0},"treemap":{"layoutAlgorithm":"squarified","levels":[{"level":1,"colorByPoint":true}]},"sunburst":{"levels":[{"level":1,"colorByPoint":true}]}},"series":[{"data":[7.0,5.0,9.0]}]},"theme":{"colors":["#0F5499","#EB5E8D","#70DCE6","#9DBF57","#208FCE","#7F062E","#C2B7AF","#CE3140"],"plotOptions":{"bar":{"colors":["#1E558C","#94D2E6","#1E8FCC","#B3325D","#FF75A3","#D9CCC3","#AECC70","#F34D5B"]},"column":{"colors":["#1E558C","#94D2E6","#1E8FCC","#B3325D","#FF75A3","#D9CCC3","#AECC70","#F34D5B"]}},"chart":{"backgroundColor":"#FFF1E5","style":{"fontFamily":"Arial, sans-serif"}},"title":{"align":"left","style":{"color":"#33302E","fontWeight":"bold"}},"subtitle":{"align":"left","style":{"color":"#33302E"}},"xAxis":{"lineColor":"#CCC1B7","tickLength":0,"labels":{"style":{"color":"#33302E"}}},"yAxis":{"gridLineColor":"#CCC1B7","labels":{"style":{"color":"#33302E"}}},"legend":{"align":"left","itemStyle":{"color":"#33302E"}}},"conf_opts":{"lang":{"locale":"en"}},"type":"chart"},"evals":[],"jsHooks":[]}
```
