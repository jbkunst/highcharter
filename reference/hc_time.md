# Time options for highcharter objects

Time options that can apply globally or to individual charts. These
settings affect how `datetime` axes are laid out, how tooltips are
formatted, how series pointIntervalUnit works and how the Highcharts
Stock range selector handles time.

## Usage

``` r
hc_time(hc, ...)
```

## Arguments

- hc:

  A `highchart` `htmlwidget` object.

- ...:

  Options defined in <https://api.highcharts.com/highcharts/time>.

## Details

The common use case is that all charts in the same Highcharts object
share the same time settings, in which case the global settings are set
using `setOptions`.

Since v6.0.5, the time options were moved from the `global` object to
the `time` object, and time options can be set on each individual chart.

## Examples

``` r
# The first observation is midnight UTC and 21:00 the previous day in Santiago.
highchart() |>
  hc_add_series(
    name = "Orders",
    data = c(12, 18, 15),
    pointStart = datetime_to_timestamp(as.Date("2025-01-01")),
    pointInterval = 3600000
  ) |>
  hc_xAxis(type = "datetime") |>
  hc_time(timezone = "America/Santiago")

{"x":{"hc_opts":{"chart":{"reflow":true},"title":{"text":null},"yAxis":{"title":{"text":null}},"credits":{"enabled":false},"exporting":{"enabled":false},"boost":{"enabled":false},"plotOptions":{"series":{"label":{"enabled":false},"turboThreshold":0.0},"treemap":{"layoutAlgorithm":"squarified","levels":[{"level":1,"colorByPoint":true}]},"sunburst":{"levels":[{"level":1,"colorByPoint":true}]}},"series":[{"data":[12.0,18.0,15.0],"name":"Orders","pointStart":1735689600000.0,"pointInterval":3600000.0}],"xAxis":{"type":"datetime"},"time":{"timezone":"America/Santiago"}},"theme":{"symbols":["circle","circle","circle","circle","circle"],"colors":["#47475c","#61BC7B","#508CC8","#F49952","#9C9EDB","#6699a1"],"chart":{"style":{"fontFamily":"IBM Plex Sans","color":"#666666"}},"title":{"align":"left","style":{"fontFamily":"Alegreya Sans SC","fontSize":"24px","fontWeight":"normal"}},"subtitle":{"align":"left","style":{"fontFamily":"IBM Plex Sans","fontSize":"16px"}},"caption":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"14px"}},"credits":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"10px"}},"legend":{"align":"right","verticalAlign":"bottom","itemStyle":{"fontWeight":"normal","color":"#666666"}},"xAxis":{"gridLineWidth":1,"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"yAxis":{"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"plotOptions":{"series":{"dataLabels":{"style":{"fontWeight":"normal"}}},"line":{"marker":{"enabled":false}},"spline":{"marker":{"enabled":false}},"area":{"marker":{"enabled":false}},"areaspline":{"marker":{"enabled":false}},"arearange":{"marker":{"enabled":false}},"bubble":{"maxSize":"10%"}},"tooltip":{"className":"highcharter-regular-tooltip","valueDecimals":2.0}},"conf_opts":{"lang":{"locale":"en"}},"type":"chart"},"evals":[],"jsHooks":[]}
```
