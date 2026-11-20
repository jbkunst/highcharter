# Setting `elementId`

Function to modify the `id` for the container.

## Usage

``` r
hc_elementId(hc, id = NULL)
```

## Arguments

- hc:

  A `highchart` `htmlwidget` object.

- id:

  A string

## Examples

``` r

hchart(rnorm(10)) |>
  hc_elementId("newid")

{"x":{"hc_opts":{"chart":{"reflow":true,"zoomType":"x"},"title":{"text":null},"yAxis":{"title":{"text":null}},"credits":{"enabled":false},"exporting":{"enabled":false},"boost":{"enabled":false},"plotOptions":{"series":{"label":{"enabled":false},"turboThreshold":0.0},"treemap":{"layoutAlgorithm":"squarified","levels":[{"level":1,"colorByPoint":true}]},"sunburst":{"levels":[{"level":1,"colorByPoint":true}]},"column":{"borderRadius":0.0},"variwide":{"borderRadius":0.0}},"tooltip":{"formatter":"function() { return  this.point.name + '<br/>' + this.y; }"},"series":[{"data":[{"x":-1.5,"y":4,"name":"-2 – -1"},{"x":-0.5,"y":2,"name":"-1 – 0"},{"x":0.5,"y":3,"name":"0 – 1"},{"x":1.5,"y":1,"name":"1 – 2"}],"type":"column","pointRange":1.0,"groupPadding":0.0,"pointPadding":0.0,"borderWidth":0.0}]},"theme":{"symbols":["circle","circle","circle","circle","circle"],"colors":["#47475c","#61BC7B","#508CC8","#F49952","#9C9EDB","#6699a1"],"chart":{"style":{"fontFamily":"IBM Plex Sans","color":"#666666"}},"title":{"align":"left","style":{"fontFamily":"Alegreya Sans SC","fontSize":"24px","fontWeight":"normal"}},"subtitle":{"align":"left","style":{"fontFamily":"IBM Plex Sans","fontSize":"16px"}},"caption":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"14px"}},"credits":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"10px"}},"legend":{"align":"right","verticalAlign":"bottom","itemStyle":{"fontWeight":"normal","color":"#666666"}},"xAxis":{"gridLineWidth":1,"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"yAxis":{"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"plotOptions":{"series":{"dataLabels":{"style":{"fontWeight":"normal"}}},"line":{"marker":{"enabled":false}},"spline":{"marker":{"enabled":false}},"area":{"marker":{"enabled":false}},"areaspline":{"marker":{"enabled":false}},"arearange":{"marker":{"enabled":false}},"bubble":{"maxSize":"10%"}},"tooltip":{"className":"highcharter-regular-tooltip","valueDecimals":2.0}},"conf_opts":{"lang":{"locale":"en"}},"type":"chart"},"evals":["hc_opts.tooltip.formatter"],"jsHooks":[]}
```
