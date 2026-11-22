# Count links between consecutive columns for a Sankey chart

Count links between consecutive columns for a Sankey chart

## Usage

``` r
data_to_sankey(data = NULL)
```

## Arguments

- data:

  A data frame with one column per stage, in traversal order. Numeric
  columns with more than ten distinct finite values are grouped by
  quintiles. Tied cut points produce fewer groups.

## Value

A tibble with `from`, `to`, `weight` (number of transitions) and a
unique link `id`. Links with a missing endpoint are omitted. Fewer than
two columns produce an empty tibble with the same columns.

## Examples

``` r
stages <- dplyr::select(ggplot2::diamonds, cut, color, clarity)
links <- data_to_sankey(stages)
head(links)
#> # A tibble: 6 × 4
#>   from  to    weight id   
#>   <chr> <chr>  <int> <chr>
#> 1 Fair  D        163 FairD
#> 2 Fair  E        224 FairE
#> 3 Fair  F        312 FairF
#> 4 Fair  G        314 FairG
#> 5 Fair  H        303 FairH
#> 6 Fair  I        175 FairI

hchart(links, "sankey", name = "Diamonds")

{"x":{"hc_opts":{"chart":{"reflow":true},"title":{"text":null},"yAxis":{"title":{}},"credits":{"enabled":false},"exporting":{"enabled":false},"boost":{"enabled":false},"plotOptions":{"series":{"label":{"enabled":false},"turboThreshold":0.0},"treemap":{"layoutAlgorithm":"squarified","levels":[{"level":1,"colorByPoint":true}]},"sunburst":{"levels":[{"level":1,"colorByPoint":true}]},"scatter":{"marker":{"symbol":"circle"}}},"series":[{"group":"group","data":[{"from":"Fair","to":"D","weight":163,"id":"FairD"},{"from":"Fair","to":"E","weight":224,"id":"FairE"},{"from":"Fair","to":"F","weight":312,"id":"FairF"},{"from":"Fair","to":"G","weight":314,"id":"FairG"},{"from":"Fair","to":"H","weight":303,"id":"FairH"},{"from":"Fair","to":"I","weight":175,"id":"FairI"},{"from":"Fair","to":"J","weight":119,"id":"FairJ"},{"from":"Good","to":"D","weight":662,"id":"GoodD"},{"from":"Good","to":"E","weight":933,"id":"GoodE"},{"from":"Good","to":"F","weight":909,"id":"GoodF"},{"from":"Good","to":"G","weight":871,"id":"GoodG"},{"from":"Good","to":"H","weight":702,"id":"GoodH"},{"from":"Good","to":"I","weight":522,"id":"GoodI"},{"from":"Good","to":"J","weight":307,"id":"GoodJ"},{"from":"Very Good","to":"D","weight":1513,"id":"Very GoodD"},{"from":"Very Good","to":"E","weight":2400,"id":"Very GoodE"},{"from":"Very Good","to":"F","weight":2164,"id":"Very GoodF"},{"from":"Very Good","to":"G","weight":2299,"id":"Very GoodG"},{"from":"Very Good","to":"H","weight":1824,"id":"Very GoodH"},{"from":"Very Good","to":"I","weight":1204,"id":"Very GoodI"},{"from":"Very Good","to":"J","weight":678,"id":"Very GoodJ"},{"from":"Premium","to":"D","weight":1603,"id":"PremiumD"},{"from":"Premium","to":"E","weight":2337,"id":"PremiumE"},{"from":"Premium","to":"F","weight":2331,"id":"PremiumF"},{"from":"Premium","to":"G","weight":2924,"id":"PremiumG"},{"from":"Premium","to":"H","weight":2360,"id":"PremiumH"},{"from":"Premium","to":"I","weight":1428,"id":"PremiumI"},{"from":"Premium","to":"J","weight":808,"id":"PremiumJ"},{"from":"Ideal","to":"D","weight":2834,"id":"IdealD"},{"from":"Ideal","to":"E","weight":3903,"id":"IdealE"},{"from":"Ideal","to":"F","weight":3826,"id":"IdealF"},{"from":"Ideal","to":"G","weight":4884,"id":"IdealG"},{"from":"Ideal","to":"H","weight":3115,"id":"IdealH"},{"from":"Ideal","to":"I","weight":2093,"id":"IdealI"},{"from":"Ideal","to":"J","weight":896,"id":"IdealJ"},{"from":"D","to":"I1","weight":42,"id":"DI1"},{"from":"D","to":"SI2","weight":1370,"id":"DSI2"},{"from":"D","to":"SI1","weight":2083,"id":"DSI1"},{"from":"D","to":"VS2","weight":1697,"id":"DVS2"},{"from":"D","to":"VS1","weight":705,"id":"DVS1"},{"from":"D","to":"VVS2","weight":553,"id":"DVVS2"},{"from":"D","to":"VVS1","weight":252,"id":"DVVS1"},{"from":"D","to":"IF","weight":73,"id":"DIF"},{"from":"E","to":"I1","weight":102,"id":"EI1"},{"from":"E","to":"SI2","weight":1713,"id":"ESI2"},{"from":"E","to":"SI1","weight":2426,"id":"ESI1"},{"from":"E","to":"VS2","weight":2470,"id":"EVS2"},{"from":"E","to":"VS1","weight":1281,"id":"EVS1"},{"from":"E","to":"VVS2","weight":991,"id":"EVVS2"},{"from":"E","to":"VVS1","weight":656,"id":"EVVS1"},{"from":"E","to":"IF","weight":158,"id":"EIF"},{"from":"F","to":"I1","weight":143,"id":"FI1"},{"from":"F","to":"SI2","weight":1609,"id":"FSI2"},{"from":"F","to":"SI1","weight":2131,"id":"FSI1"},{"from":"F","to":"VS2","weight":2201,"id":"FVS2"},{"from":"F","to":"VS1","weight":1364,"id":"FVS1"},{"from":"F","to":"VVS2","weight":975,"id":"FVVS2"},{"from":"F","to":"VVS1","weight":734,"id":"FVVS1"},{"from":"F","to":"IF","weight":385,"id":"FIF"},{"from":"G","to":"I1","weight":150,"id":"GI1"},{"from":"G","to":"SI2","weight":1548,"id":"GSI2"},{"from":"G","to":"SI1","weight":1976,"id":"GSI1"},{"from":"G","to":"VS2","weight":2347,"id":"GVS2"},{"from":"G","to":"VS1","weight":2148,"id":"GVS1"},{"from":"G","to":"VVS2","weight":1443,"id":"GVVS2"},{"from":"G","to":"VVS1","weight":999,"id":"GVVS1"},{"from":"G","to":"IF","weight":681,"id":"GIF"},{"from":"H","to":"I1","weight":162,"id":"HI1"},{"from":"H","to":"SI2","weight":1563,"id":"HSI2"},{"from":"H","to":"SI1","weight":2275,"id":"HSI1"},{"from":"H","to":"VS2","weight":1643,"id":"HVS2"},{"from":"H","to":"VS1","weight":1169,"id":"HVS1"},{"from":"H","to":"VVS2","weight":608,"id":"HVVS2"},{"from":"H","to":"VVS1","weight":585,"id":"HVVS1"},{"from":"H","to":"IF","weight":299,"id":"HIF"},{"from":"I","to":"I1","weight":92,"id":"II1"},{"from":"I","to":"SI2","weight":912,"id":"ISI2"},{"from":"I","to":"SI1","weight":1424,"id":"ISI1"},{"from":"I","to":"VS2","weight":1169,"id":"IVS2"},{"from":"I","to":"VS1","weight":962,"id":"IVS1"},{"from":"I","to":"VVS2","weight":365,"id":"IVVS2"},{"from":"I","to":"VVS1","weight":355,"id":"IVVS1"},{"from":"I","to":"IF","weight":143,"id":"IIF"},{"from":"J","to":"I1","weight":50,"id":"JI1"},{"from":"J","to":"SI2","weight":479,"id":"JSI2"},{"from":"J","to":"SI1","weight":750,"id":"JSI1"},{"from":"J","to":"VS2","weight":731,"id":"JVS2"},{"from":"J","to":"VS1","weight":542,"id":"JVS1"},{"from":"J","to":"VVS2","weight":131,"id":"JVVS2"},{"from":"J","to":"VVS1","weight":74,"id":"JVVS1"},{"from":"J","to":"IF","weight":51,"id":"JIF"}],"type":"sankey","name":"Diamonds"}],"xAxis":{"title":{"text":null}}},"theme":{"symbols":["circle","circle","circle","circle","circle"],"colors":["#47475c","#61BC7B","#508CC8","#F49952","#9C9EDB","#6699a1"],"chart":{"style":{"fontFamily":"IBM Plex Sans","color":"#666666"}},"title":{"align":"left","style":{"fontFamily":"Alegreya Sans SC","fontSize":"24px","fontWeight":"normal"}},"subtitle":{"align":"left","style":{"fontFamily":"IBM Plex Sans","fontSize":"16px"}},"caption":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"14px"}},"credits":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"10px"}},"legend":{"align":"right","verticalAlign":"bottom","itemStyle":{"fontWeight":"normal","color":"#666666"}},"xAxis":{"gridLineWidth":1,"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"yAxis":{"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"plotOptions":{"series":{"dataLabels":{"style":{"fontWeight":"normal"}}},"line":{"marker":{"enabled":false}},"spline":{"marker":{"enabled":false}},"area":{"marker":{"enabled":false}},"areaspline":{"marker":{"enabled":false}},"arearange":{"marker":{"enabled":false}},"bubble":{"maxSize":"10%"}},"tooltip":{"className":"highcharter-regular-tooltip","valueDecimals":2.0}},"conf_opts":{"lang":{"locale":"en"}},"type":"chart"},"evals":[],"jsHooks":[]}
```
