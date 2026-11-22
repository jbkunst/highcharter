# Explore one boosted tree

Select one tree by its one-based index. Marker area represents cover,
with a minimum radius for interaction. Internal nodes report split gain
and the branch for missing values. Leaves report their contribution to
the prediction margin. Supports tree boosters with numeric splits.

## Usage

``` r
# S3 method for class 'xgb.Booster'
hchart(object, ..., tree = 1L)
```

## Arguments

- object:

  An `xgb.Booster` fit.

- ...:

  Highcharts treegraph series options.

- tree:

  A positive tree index, starting at one.

## Value

A highchart htmlwidget.

## Examples

``` r
d <- xgboost::xgb.DMatrix(as.matrix(iris[1:4]), label = iris$Petal.Width)
fit <- xgboost::xgb.train(
  list(objective = "reg:squarederror", max_depth = 2L, nthread = 1L),
  d, nrounds = 3L, verbose = 0
)
hchart(fit, tree = 2)

{"x":{"hc_opts":{"chart":{"reflow":true,"inverted":true,"spacingLeft":26.0,"spacingRight":26.0},"title":{"text":null},"yAxis":{"title":{"text":null}},"credits":{"enabled":false},"exporting":{"enabled":false},"boost":{"enabled":false},"plotOptions":{"series":{"label":{"enabled":false},"turboThreshold":0.0},"treemap":{"layoutAlgorithm":"squarified","levels":[{"level":1,"colorByPoint":true}]},"sunburst":{"levels":[{"level":1,"colorByPoint":true}]},"treegraph":{"link":{"type":"straight","color":"#8C8C8C"},"marker":{"fillColor":"#D4E7E5","lineColor":"#4E7778","lineWidth":1.0},"dataLabels":{"enabled":true,"allowOverlap":true,"crop":false,"overflow":"allow","pointFormat":"{point.custom.label}","linkFormat":"{point.fromNode.name}<br/>{point.toNode.custom.rule}","linkTextPath":{"enabled":false},"style":{"color":"#333333","fontWeight":"normal","textOutline":"2px #FFFFFF"}},"tooltip":{"headerFormat":"","pointFormat":"{point.custom.detail}<br/>Cover: {point.custom.cover:.2f}","linkFormat":"{point.toNode.custom.detail}<br/>Cover: {point.toNode.custom.cover:.2f}"}}},"series":[{"data":[{"id":"1-0","name":"Petal.Width","marker":{"radius":16.0},"custom":{"label":"","rule":"","cover":150.0,"detail":"Petal.Width &lt; 1.2<br/>Gain: 33.796<br/>Missing follows: No"}},{"id":"1-1","name":"Petal.Width","marker":{"radius":10.11928851253881},"custom":{"label":"","rule":"&lt; 1.2","cover":60.0,"detail":"Petal.Width &lt; 0.6<br/>Gain: 2.2462<br/>Missing follows: No"},"parent":"1-0"},{"id":"1-2","name":"Petal.Width","marker":{"radius":12.39354670786374},"custom":{"label":"","rule":"≥ 1.2","cover":90.0,"detail":"Petal.Width &lt; 2<br/>Gain: 5.4318<br/>Missing follows: No"},"parent":"1-0"},{"id":"1-3","name":"-0.19997","marker":{"radius":9.14476170639053},"custom":{"label":"-0.19997","rule":"&lt; 0.6","cover":49.0,"detail":"Leaf contribution: -0.19997"},"parent":"1-1"},{"id":"1-4","name":"-0.04529","marker":{"radius":4.332820482472513},"custom":{"label":"-0.04529","rule":"≥ 0.6","cover":11.0,"detail":"Leaf contribution: -0.04529"},"parent":"1-1"},{"id":"1-5","name":"0.063129","marker":{"radius":10.20326745051146},"custom":{"label":"0.063129","rule":"&lt; 2","cover":61.0,"detail":"Leaf contribution: 0.063129"},"parent":"1-2"},{"id":"1-6","name":"0.22072","marker":{"radius":7.035149844412223},"custom":{"label":"0.22072","rule":"≥ 2","cover":29.0,"detail":"Leaf contribution: 0.22072"},"parent":"1-2"}],"type":"treegraph","name":"Tree 2"}]},"theme":{"symbols":["circle","circle","circle","circle","circle"],"colors":["#47475c","#61BC7B","#508CC8","#F49952","#9C9EDB","#6699a1"],"chart":{"style":{"fontFamily":"IBM Plex Sans","color":"#666666"}},"title":{"align":"left","style":{"fontFamily":"Alegreya Sans SC","fontSize":"24px","fontWeight":"normal"}},"subtitle":{"align":"left","style":{"fontFamily":"IBM Plex Sans","fontSize":"16px"}},"caption":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"14px"}},"credits":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"10px"}},"legend":{"align":"right","verticalAlign":"bottom","itemStyle":{"fontWeight":"normal","color":"#666666"}},"xAxis":{"gridLineWidth":1,"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"yAxis":{"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"plotOptions":{"series":{"dataLabels":{"style":{"fontWeight":"normal"}}},"line":{"marker":{"enabled":false}},"spline":{"marker":{"enabled":false}},"area":{"marker":{"enabled":false}},"areaspline":{"marker":{"enabled":false}},"arearange":{"marker":{"enabled":false}},"bubble":{"maxSize":"10%"}},"tooltip":{"className":"highcharter-regular-tooltip","valueDecimals":2.0}},"conf_opts":{"lang":{"locale":"en"}},"type":"chart"},"evals":[],"jsHooks":[]}
```
