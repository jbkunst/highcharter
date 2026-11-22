# Exporting options for highcharter objects

Options for the exporting module. For an overview on the matter, see the
docs and read our Fair Usage Policy.

## Usage

``` r
hc_exporting(hc, ...)
```

## Arguments

- hc:

  A `highchart` `htmlwidget` object.

- ...:

  Options defined in <https://api.highcharts.com/highcharts/exporting>.

## Examples

``` r
# Open the chart menu to download the image or the underlying temperatures.
highcharts_demo() |>
  hc_exporting(
    enabled = TRUE,
    filename = "monthly-city-temperatures",
    buttons = list(
      contextButton = list(menuItems = c("downloadPNG", "downloadCSV"))
    )
  )

{"x":{"hc_opts":{"chart":{"reflow":true},"title":{"text":"Monthly mean temperatures in 2025"},"yAxis":{"title":{"text":"Temperature (°C)"},"type":"linear"},"credits":{"enabled":false},"exporting":{"enabled":true,"filename":"monthly-city-temperatures","buttons":{"contextButton":{"menuItems":["downloadPNG","downloadCSV"]}}},"boost":{"enabled":false},"plotOptions":{"series":{"label":{"enabled":false},"turboThreshold":0.0},"treemap":{"layoutAlgorithm":"squarified","levels":[{"level":1,"colorByPoint":true}]},"sunburst":{"levels":[{"level":1,"colorByPoint":true}]},"scatter":{"marker":{"symbol":"circle"}}},"series":[{"name":"Berlin","data":[{"month":0,"city":"Berlin","temperature":2.470967741935484,"x":0,"y":2.470967741935484},{"month":1,"city":"Berlin","temperature":0.65,"x":1,"y":0.65},{"month":2,"city":"Berlin","temperature":6.041935483870968,"x":2,"y":6.041935483870968},{"month":3,"city":"Berlin","temperature":11.51,"x":3,"y":11.51},{"month":4,"city":"Berlin","temperature":13.24193548387097,"x":4,"y":13.24193548387097},{"month":5,"city":"Berlin","temperature":19.31,"x":5,"y":19.31},{"month":6,"city":"Berlin","temperature":19.52258064516129,"x":6,"y":19.52258064516129},{"month":7,"city":"Berlin","temperature":18.76129032258065,"x":7,"y":18.76129032258065},{"month":8,"city":"Berlin","temperature":15.64666666666667,"x":8,"y":15.64666666666667},{"month":9,"city":"Berlin","temperature":10.15806451612903,"x":9,"y":10.15806451612903},{"month":10,"city":"Berlin","temperature":5.043333333333333,"x":10,"y":5.043333333333333},{"month":11,"city":"Berlin","temperature":2.980645161290323,"x":11,"y":2.980645161290323}],"type":"line"},{"name":"Nairobi","data":[{"month":0,"city":"Nairobi","temperature":20.3258064516129,"x":0,"y":20.3258064516129},{"month":1,"city":"Nairobi","temperature":21.41428571428572,"x":1,"y":21.41428571428572},{"month":2,"city":"Nairobi","temperature":21.47741935483871,"x":2,"y":21.47741935483871},{"month":3,"city":"Nairobi","temperature":20.21,"x":3,"y":20.21},{"month":4,"city":"Nairobi","temperature":19.60322580645161,"x":4,"y":19.60322580645161},{"month":5,"city":"Nairobi","temperature":18.65,"x":5,"y":18.65},{"month":6,"city":"Nairobi","temperature":17.96451612903226,"x":6,"y":17.96451612903226},{"month":7,"city":"Nairobi","temperature":17.68709677419355,"x":7,"y":17.68709677419355},{"month":8,"city":"Nairobi","temperature":19.51,"x":8,"y":19.51},{"month":9,"city":"Nairobi","temperature":20.15483870967742,"x":9,"y":20.15483870967742},{"month":10,"city":"Nairobi","temperature":19.86,"x":10,"y":19.86},{"month":11,"city":"Nairobi","temperature":20.20322580645161,"x":11,"y":20.20322580645161}],"type":"line"},{"name":"Santiago","data":[{"month":0,"city":"Santiago","temperature":22.68387096774194,"x":0,"y":22.68387096774194},{"month":1,"city":"Santiago","temperature":22.375,"x":1,"y":22.375},{"month":2,"city":"Santiago","temperature":19.59677419354839,"x":2,"y":19.59677419354839},{"month":3,"city":"Santiago","temperature":15.82,"x":3,"y":15.82},{"month":4,"city":"Santiago","temperature":12.95161290322581,"x":4,"y":12.95161290322581},{"month":5,"city":"Santiago","temperature":8.47,"x":5,"y":8.47},{"month":6,"city":"Santiago","temperature":10.28064516129032,"x":6,"y":10.28064516129032},{"month":7,"city":"Santiago","temperature":10.59354838709678,"x":7,"y":10.59354838709678},{"month":8,"city":"Santiago","temperature":13.10333333333333,"x":8,"y":13.10333333333333},{"month":9,"city":"Santiago","temperature":16.21290322580645,"x":9,"y":16.21290322580645},{"month":10,"city":"Santiago","temperature":18.3,"x":10,"y":18.3},{"month":11,"city":"Santiago","temperature":21.30322580645162,"x":11,"y":21.30322580645162}],"type":"line"},{"name":"Tokyo","data":[{"month":0,"city":"Tokyo","temperature":5.34516129032258,"x":0,"y":5.34516129032258},{"month":1,"city":"Tokyo","temperature":5.314285714285714,"x":1,"y":5.314285714285714},{"month":2,"city":"Tokyo","temperature":9.86774193548387,"x":2,"y":9.86774193548387},{"month":3,"city":"Tokyo","temperature":14.90666666666667,"x":3,"y":14.90666666666667},{"month":4,"city":"Tokyo","temperature":18.67741935483871,"x":4,"y":18.67741935483871},{"month":5,"city":"Tokyo","temperature":24.36,"x":5,"y":24.36},{"month":6,"city":"Tokyo","temperature":28.53225806451613,"x":6,"y":28.53225806451613},{"month":7,"city":"Tokyo","temperature":29.89032258064516,"x":7,"y":29.89032258064516},{"month":8,"city":"Tokyo","temperature":26.17333333333333,"x":8,"y":26.17333333333333},{"month":9,"city":"Tokyo","temperature":18.22258064516129,"x":9,"y":18.22258064516129},{"month":10,"city":"Tokyo","temperature":11.61,"x":10,"y":11.61},{"month":11,"city":"Tokyo","temperature":7.032258064516129,"x":11,"y":7.032258064516129}],"type":"line"}],"xAxis":{"type":"linear","title":{},"categories":["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]},"subtitle":{"text":"ERA5 reanalysis via Open-Meteo"},"caption":{"text":"July was warmer in Tokyo than in Santiago."},"tooltip":{"shared":true,"valueDecimals":1.0,"valueSuffix":" °C"}},"theme":{"symbols":["circle","circle","circle","circle","circle"],"colors":["#47475c","#61BC7B","#508CC8","#F49952","#9C9EDB","#6699a1"],"chart":{"style":{"fontFamily":"IBM Plex Sans","color":"#666666"}},"title":{"align":"left","style":{"fontFamily":"Alegreya Sans SC","fontSize":"24px","fontWeight":"normal"}},"subtitle":{"align":"left","style":{"fontFamily":"IBM Plex Sans","fontSize":"16px"}},"caption":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"14px"}},"credits":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"10px"}},"legend":{"align":"right","verticalAlign":"bottom","itemStyle":{"fontWeight":"normal","color":"#666666"}},"xAxis":{"gridLineWidth":1,"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"yAxis":{"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"plotOptions":{"series":{"dataLabels":{"style":{"fontWeight":"normal"}}},"line":{"marker":{"enabled":false}},"spline":{"marker":{"enabled":false}},"area":{"marker":{"enabled":false}},"areaspline":{"marker":{"enabled":false}},"arearange":{"marker":{"enabled":false}},"bubble":{"maxSize":"10%"}},"tooltip":{"className":"highcharter-regular-tooltip","valueDecimals":2.0}},"conf_opts":{"lang":{"locale":"en"}},"type":"chart"},"evals":[],"jsHooks":[]}
```
