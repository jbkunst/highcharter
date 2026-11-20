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

{"x":{"hc_opts":{"chart":{"reflow":true},"title":{"text":null},"yAxis":{"title":{"text":null}},"credits":{"enabled":false},"exporting":{"enabled":false},"boost":{"enabled":false},"plotOptions":{"series":{"label":{"enabled":false},"turboThreshold":0.0},"treemap":{"layoutAlgorithm":"squarified","levels":[{"level":1,"colorByPoint":true}]},"sunburst":{"levels":[{"level":1,"colorByPoint":true}]}},"series":[{"data":[3.0,1.0,4.0]}]},"theme":{"colors":["#0F5499","#EB5E8D","#70DCE6","#9DBF57","#208FCE","#7F062E","#C2B7AF","#CE3140"],"plotOptions":{"bar":{"colors":["#1E558C","#94D2E6","#1E8FCC","#B3325D","#FF75A3","#D9CCC3","#AECC70","#F34D5B"]},"column":{"colors":["#1E558C","#94D2E6","#1E8FCC","#B3325D","#FF75A3","#D9CCC3","#AECC70","#F34D5B"]}},"chart":{"backgroundColor":"#FFF1E5","style":{"fontFamily":"Arial, sans-serif"}},"title":{"align":"left","style":{"color":"#33302E","fontWeight":"bold"}},"subtitle":{"align":"left","style":{"color":"#33302E"}},"xAxis":{"lineColor":"#CCC1B7","tickLength":0,"labels":{"style":{"color":"#33302E"}}},"yAxis":{"gridLineColor":"#CCC1B7","labels":{"style":{"color":"#33302E"}}},"legend":{"align":"left","itemStyle":{"color":"#33302E"}}},"conf_opts":{"lang":{"locale":"en"}},"type":"chart"},"evals":[],"jsHooks":[]}team <- hc_theme("carbon", colors = c("#005F73", "#CA6702"))
hc_theme(chart = list(style = list(fontFamily = "IBM Plex Sans")))
#> $chart
#> $chart$style
#> $chart$style$fontFamily
#> [1] "IBM Plex Sans"
#> 
#> 
#> 
#> attr(,"class")
#> [1] "hc_theme"
if (FALSE) { # \dontrun{
hc_theme(chart = list(style = list(fontFamily = sass::font_google("Noto Sans"))))
} # }
old <- hc_set_theme(team)
highchart() |> hc_add_series(data = c(3, 1, 4))

{"x":{"hc_opts":{"chart":{"reflow":true},"title":{"text":null},"yAxis":{"title":{"text":null}},"credits":{"enabled":false},"exporting":{"enabled":false},"boost":{"enabled":false},"plotOptions":{"series":{"label":{"enabled":false},"turboThreshold":0.0},"treemap":{"layoutAlgorithm":"squarified","levels":[{"level":1,"colorByPoint":true}]},"sunburst":{"levels":[{"level":1,"colorByPoint":true}]}},"series":[{"data":[3.0,1.0,4.0]}]},"theme":{"symbols":["circle","circle","circle","circle","circle"],"colors":["#005F73","#CA6702"],"chart":{"backgroundColor":"#FFFFFF","style":{"fontFamily":"IBM Plex Sans, sans-serif"}},"title":{"align":"left","style":{"color":"#161616","fontWeight":"normal"}},"subtitle":{"align":"left","style":{"color":"#161616"}},"xAxis":{"gridLineWidth":1,"gridLineColor":"#DCDCDC","lineColor":"#DCDCDC","tickLength":0,"labels":{"style":{"color":"#161616"}}},"yAxis":{"gridLineWidth":1,"gridLineColor":"#DCDCDC","labels":{"style":{"color":"#161616"}}},"legend":{"align":"left","itemStyle":{"fontWeight":"normal","color":"#161616"}},"colorAxis":{"minColor":"#EDF5FF","maxColor":"#002D9C"},"plotOptions":{"series":{"dataLabels":{"style":{"fontWeight":"normal"}}}},"tooltip":{"className":"highcharter-regular-tooltip"}},"conf_opts":{"lang":{"locale":"en"}},"type":"chart"},"evals":[],"jsHooks":[]}options(old)
```
