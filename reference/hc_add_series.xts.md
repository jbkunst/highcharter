# Add xts series to a chart

A single instrument with Open, High, Low and Close columns produces a
candlestick series. Additional columns such as Volume are ignored. With
incomplete or ordinary data, each column produces its own line. Select
one instrument before passing a data set with ambiguous OHLC columns.

## Usage

``` r
# S3 method for class 'xts'
hc_add_series(hc, data, ..., name = NULL)

# S3 method for class 'ohlc'
hc_add_series(hc, data, type = "candlestick", ..., name = NULL)
```

## Arguments

- hc:

  A `highchart` widget.

- data:

  An `xts` object.

- ...:

  Highcharts series options. To set `id` for multiple lines, supply a
  different ID for each column. Other options apply to every line.

- name:

  Optional series name, or one name per column for multiple lines.

- type:

  Financial series type, usually `"candlestick"` or `"ohlc"`.

## Examples

``` r
if (requireNamespace("xts", quietly = TRUE)) {
  dates <- as.Date("2025-01-01") + 0:2
  quotes <- xts::xts(cbind(A = c(42, 45, 44), B = c(30, NA, 32)), dates)
  hchart(quotes, id = c("a", "b"))

  if (requireNamespace("quantmod", quietly = TRUE)) {
    prices <- xts::xts(cbind(Open = 4:6, High = 6:8, Low = 3:5, Close = 5:7), dates)
    highchart(type = "stock") |> hc_add_series(prices, name = "Price")
  }
}
#> Registered S3 method overwritten by 'quantmod':
#>   method            from
#>   as.zoo.data.frame zoo 

{"x":{"hc_opts":{"chart":{"reflow":true},"title":{"text":null},"yAxis":{"title":{"text":null}},"credits":{"enabled":false},"exporting":{"enabled":false},"boost":{"enabled":false},"plotOptions":{"series":{"label":{"enabled":false},"turboThreshold":0.0},"treemap":{"layoutAlgorithm":"squarified","levels":[{"level":1,"colorByPoint":true}]},"sunburst":{"levels":[{"level":1,"colorByPoint":true}]}},"series":[{"data":[[1735689600000.0,4,6,3,5],[1735776000000.0,5,7,4,6],[1735862400000.0,6,8,5,7]],"name":"Price","type":"candlestick"}]},"theme":{"symbols":["circle","circle","circle","circle","circle"],"colors":["#47475c","#61BC7B","#508CC8","#F49952","#9C9EDB","#6699a1"],"chart":{"style":{"fontFamily":"IBM Plex Sans","color":"#666666"}},"title":{"align":"left","style":{"fontFamily":"Alegreya Sans SC","fontSize":"24px","fontWeight":"normal"}},"subtitle":{"align":"left","style":{"fontFamily":"IBM Plex Sans","fontSize":"16px"}},"caption":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"14px"}},"credits":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"10px"}},"legend":{"align":"right","verticalAlign":"bottom","itemStyle":{"fontWeight":"normal","color":"#666666"}},"xAxis":{"gridLineWidth":1,"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"yAxis":{"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"plotOptions":{"series":{"dataLabels":{"style":{"fontWeight":"normal"}}},"line":{"marker":{"enabled":false}},"spline":{"marker":{"enabled":false}},"area":{"marker":{"enabled":false}},"areaspline":{"marker":{"enabled":false}},"arearange":{"marker":{"enabled":false}},"bubble":{"maxSize":"10%"}},"tooltip":{"className":"highcharter-regular-tooltip","valueDecimals":2.0}},"conf_opts":{"lang":{"locale":"en"}},"type":"stock"},"evals":[],"jsHooks":[]}
```
