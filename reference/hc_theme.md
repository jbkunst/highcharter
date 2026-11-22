# Create, list and select chart themes

A theme contains Highcharts options shared by one or more charts. Start
from a packaged preset or supply your own named Highcharts options.

## Usage

``` r
hc_theme(preset = NULL, ...)

hc_themes()

hc_set_theme(theme, ...)
```

## Arguments

- preset:

  A name returned by `hc_themes()`, or `NULL` to start from an empty
  theme.

- ...:

  Named Highcharts options. Nested options override individual fields.
  Arrays such as `colors` and gradient stops are replaced in full. In a
  `fontFamily` field, name a bundled or page-supplied family, or pass
  [`sass::font_google()`](https://rstudio.github.io/sass/reference/font_face.html)
  to include a web font with the chart.

- theme:

  A preset name or an object created with `hc_theme()`.

## Value

`hc_theme()` returns an `hc_theme` object. `hc_themes()` lists the
available preset names. `hc_set_theme()` sets `highcharter.theme` for
subsequent charts in the R process and invisibly returns the previous
option.

## See also

[`hc_add_theme()`](https://jkunst.com/highcharter/reference/hc_add_theme.md),
[`hc_theme_merge()`](https://jkunst.com/highcharter/reference/hc_theme_merge.md),
[`vignette("themes", package = "highcharter")`](https://jkunst.com/highcharter/articles/themes.md)

## Examples

``` r
hc_themes()
#>  [1] "538"          "alone"        "bloom"        "bslib"        "carbon"      
#>  [6] "chalk"        "cloudscape"   "darkunica"    "db"           "economist"   
#> [11] "elementary"   "ffx"          "flat"         "flatdark"     "ft"          
#> [16] "ggplot2"      "google"       "gridlight"    "handdrawn"    "hcrt"        
#> [21] "monokai"      "null"         "sandsignika"  "smpl"         "sparkline"   
#> [26] "sparkline_vb" "superheroes"  "tufte"       
highchart(theme = hc_theme("ft")) |> hc_add_series(data = c(3, 1, 4))

{"x":{"hc_opts":{"chart":{"reflow":true},"title":{"text":null},"yAxis":{"title":{"text":null}},"credits":{"enabled":false},"exporting":{"enabled":false},"boost":{"enabled":false},"plotOptions":{"series":{"label":{"enabled":false},"turboThreshold":0.0},"treemap":{"layoutAlgorithm":"squarified","levels":[{"level":1,"colorByPoint":true}]},"sunburst":{"levels":[{"level":1,"colorByPoint":true}]}},"series":[{"data":[3.0,1.0,4.0]}]},"theme":{"colors":["#0F5499","#EB5E8D","#70DCE6","#9DBF57","#208FCE","#7F062E","#C2B7AF","#CE3140"],"plotOptions":{"bar":{"colors":["#1E558C","#94D2E6","#1E8FCC","#B3325D","#FF75A3","#D9CCC3","#AECC70","#F34D5B"]},"column":{"colors":["#1E558C","#94D2E6","#1E8FCC","#B3325D","#FF75A3","#D9CCC3","#AECC70","#F34D5B"]}},"chart":{"backgroundColor":"#FFF1E5","style":{"fontFamily":"Arial, sans-serif"}},"title":{"align":"left","style":{"color":"#33302E","fontWeight":"bold"}},"subtitle":{"align":"left","style":{"color":"#33302E"}},"xAxis":{"lineColor":"#CCC1B7","tickLength":0,"labels":{"style":{"color":"#33302E"}}},"yAxis":{"gridLineColor":"#CCC1B7","labels":{"style":{"color":"#33302E"}}},"legend":{"align":"left","itemStyle":{"color":"#33302E"}}},"conf_opts":{"lang":{"locale":"en"}},"type":"chart"},"evals":[],"jsHooks":[]}team <- hc_theme("carbon", colors = c("#005F73", "#CA6702"),
  chart = list(style = list(fontFamily = "IBM Plex Sans")))
old <- hc_set_theme(team)
highchart() |> hc_add_series(data = c(3, 1, 4))

{"x":{"hc_opts":{"chart":{"reflow":true},"title":{"text":null},"yAxis":{"title":{"text":null}},"credits":{"enabled":false},"exporting":{"enabled":false},"boost":{"enabled":false},"plotOptions":{"series":{"label":{"enabled":false},"turboThreshold":0.0},"treemap":{"layoutAlgorithm":"squarified","levels":[{"level":1,"colorByPoint":true}]},"sunburst":{"levels":[{"level":1,"colorByPoint":true}]}},"series":[{"data":[3.0,1.0,4.0]}]},"theme":{"symbols":["circle","circle","circle","circle","circle"],"colors":["#005F73","#CA6702"],"chart":{"backgroundColor":"#FFFFFF","style":{"fontFamily":"IBM Plex Sans"}},"title":{"align":"left","style":{"color":"#161616","fontWeight":"normal"}},"subtitle":{"align":"left","style":{"color":"#161616"}},"xAxis":{"gridLineWidth":1,"gridLineColor":"#DCDCDC","lineColor":"#DCDCDC","tickLength":0,"labels":{"style":{"color":"#161616"}}},"yAxis":{"gridLineWidth":1,"gridLineColor":"#DCDCDC","labels":{"style":{"color":"#161616"}}},"legend":{"align":"left","itemStyle":{"fontWeight":"normal","color":"#161616"}},"colorAxis":{"minColor":"#EDF5FF","maxColor":"#002D9C"},"plotOptions":{"series":{"dataLabels":{"style":{"fontWeight":"normal"}}}},"tooltip":{"className":"highcharter-regular-tooltip"}},"conf_opts":{"lang":{"locale":"en"}},"type":"chart"},"evals":[],"jsHooks":[]}options(old)

font <- sass::font_google("Noto Sans", local = FALSE)
highcharts_demo() |>
  hc_add_theme(hc_theme(chart = list(style = list(fontFamily = font))))

{"x":{"hc_opts":{"chart":{"reflow":true},"title":{"text":"Monthly mean temperatures in 2025"},"yAxis":{"title":{"text":"Temperature (°C)"},"type":"linear"},"credits":{"enabled":false},"exporting":{"enabled":false},"boost":{"enabled":false},"plotOptions":{"series":{"label":{"enabled":false},"turboThreshold":0.0},"treemap":{"layoutAlgorithm":"squarified","levels":[{"level":1,"colorByPoint":true}]},"sunburst":{"levels":[{"level":1,"colorByPoint":true}]},"scatter":{"marker":{"symbol":"circle"}}},"series":[{"name":"Berlin","data":[{"month":0,"city":"Berlin","temperature":2.470967741935484,"x":0,"y":2.470967741935484},{"month":1,"city":"Berlin","temperature":0.65,"x":1,"y":0.65},{"month":2,"city":"Berlin","temperature":6.041935483870968,"x":2,"y":6.041935483870968},{"month":3,"city":"Berlin","temperature":11.51,"x":3,"y":11.51},{"month":4,"city":"Berlin","temperature":13.24193548387097,"x":4,"y":13.24193548387097},{"month":5,"city":"Berlin","temperature":19.31,"x":5,"y":19.31},{"month":6,"city":"Berlin","temperature":19.52258064516129,"x":6,"y":19.52258064516129},{"month":7,"city":"Berlin","temperature":18.76129032258065,"x":7,"y":18.76129032258065},{"month":8,"city":"Berlin","temperature":15.64666666666667,"x":8,"y":15.64666666666667},{"month":9,"city":"Berlin","temperature":10.15806451612903,"x":9,"y":10.15806451612903},{"month":10,"city":"Berlin","temperature":5.043333333333333,"x":10,"y":5.043333333333333},{"month":11,"city":"Berlin","temperature":2.980645161290323,"x":11,"y":2.980645161290323}],"type":"line"},{"name":"Nairobi","data":[{"month":0,"city":"Nairobi","temperature":20.3258064516129,"x":0,"y":20.3258064516129},{"month":1,"city":"Nairobi","temperature":21.41428571428572,"x":1,"y":21.41428571428572},{"month":2,"city":"Nairobi","temperature":21.47741935483871,"x":2,"y":21.47741935483871},{"month":3,"city":"Nairobi","temperature":20.21,"x":3,"y":20.21},{"month":4,"city":"Nairobi","temperature":19.60322580645161,"x":4,"y":19.60322580645161},{"month":5,"city":"Nairobi","temperature":18.65,"x":5,"y":18.65},{"month":6,"city":"Nairobi","temperature":17.96451612903226,"x":6,"y":17.96451612903226},{"month":7,"city":"Nairobi","temperature":17.68709677419355,"x":7,"y":17.68709677419355},{"month":8,"city":"Nairobi","temperature":19.51,"x":8,"y":19.51},{"month":9,"city":"Nairobi","temperature":20.15483870967742,"x":9,"y":20.15483870967742},{"month":10,"city":"Nairobi","temperature":19.86,"x":10,"y":19.86},{"month":11,"city":"Nairobi","temperature":20.20322580645161,"x":11,"y":20.20322580645161}],"type":"line"},{"name":"Santiago","data":[{"month":0,"city":"Santiago","temperature":22.68387096774194,"x":0,"y":22.68387096774194},{"month":1,"city":"Santiago","temperature":22.375,"x":1,"y":22.375},{"month":2,"city":"Santiago","temperature":19.59677419354839,"x":2,"y":19.59677419354839},{"month":3,"city":"Santiago","temperature":15.82,"x":3,"y":15.82},{"month":4,"city":"Santiago","temperature":12.95161290322581,"x":4,"y":12.95161290322581},{"month":5,"city":"Santiago","temperature":8.47,"x":5,"y":8.47},{"month":6,"city":"Santiago","temperature":10.28064516129032,"x":6,"y":10.28064516129032},{"month":7,"city":"Santiago","temperature":10.59354838709678,"x":7,"y":10.59354838709678},{"month":8,"city":"Santiago","temperature":13.10333333333333,"x":8,"y":13.10333333333333},{"month":9,"city":"Santiago","temperature":16.21290322580645,"x":9,"y":16.21290322580645},{"month":10,"city":"Santiago","temperature":18.3,"x":10,"y":18.3},{"month":11,"city":"Santiago","temperature":21.30322580645162,"x":11,"y":21.30322580645162}],"type":"line"},{"name":"Tokyo","data":[{"month":0,"city":"Tokyo","temperature":5.34516129032258,"x":0,"y":5.34516129032258},{"month":1,"city":"Tokyo","temperature":5.314285714285714,"x":1,"y":5.314285714285714},{"month":2,"city":"Tokyo","temperature":9.86774193548387,"x":2,"y":9.86774193548387},{"month":3,"city":"Tokyo","temperature":14.90666666666667,"x":3,"y":14.90666666666667},{"month":4,"city":"Tokyo","temperature":18.67741935483871,"x":4,"y":18.67741935483871},{"month":5,"city":"Tokyo","temperature":24.36,"x":5,"y":24.36},{"month":6,"city":"Tokyo","temperature":28.53225806451613,"x":6,"y":28.53225806451613},{"month":7,"city":"Tokyo","temperature":29.89032258064516,"x":7,"y":29.89032258064516},{"month":8,"city":"Tokyo","temperature":26.17333333333333,"x":8,"y":26.17333333333333},{"month":9,"city":"Tokyo","temperature":18.22258064516129,"x":9,"y":18.22258064516129},{"month":10,"city":"Tokyo","temperature":11.61,"x":10,"y":11.61},{"month":11,"city":"Tokyo","temperature":7.032258064516129,"x":11,"y":7.032258064516129}],"type":"line"}],"xAxis":{"type":"linear","title":{},"categories":["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]},"subtitle":{"text":"ERA5 reanalysis via Open-Meteo"},"caption":{"text":"July was warmer in Tokyo than in Santiago."},"tooltip":{"shared":true,"valueDecimals":1.0,"valueSuffix":" °C"}},"theme":{"chart":{"style":{"fontFamily":"'Noto Sans'"}}},"conf_opts":{"lang":{"locale":"en"}},"type":"chart"},"evals":[],"jsHooks":[]}
```
