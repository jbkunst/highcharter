# Drilldown options for highcharter objects

Options for drill down, the concept of inspecting increasingly high
resolution data through clicking on chart items like columns or pie
slices.

## Usage

``` r
hc_drilldown(hc, ...)
```

## Arguments

- hc:

  A `highchart` `htmlwidget` object.

- ...:

  Arguments defined in
  <https://api.highcharts.com/highcharts/drilldown>.

## Examples

``` r
library(highcharter)
library(dplyr)
library(purrr)

df <- tibble(
  name = c("Animals", "Fruits"),
  y = c(5, 2),
  drilldown = tolower(name)
)

df
#> # A tibble: 2 × 3
#>   name        y drilldown
#>   <chr>   <dbl> <chr>    
#> 1 Animals     5 animals  
#> 2 Fruits      2 fruits   

hc <- highchart() |>
  hc_title(text = "Basic drilldown") |>
  hc_xAxis(type = "category") |>
  hc_legend(enabled = FALSE) |>
  hc_plotOptions(
    series = list(
      boderWidth = 0,
      dataLabels = list(enabled = TRUE)
    )
  ) |>
  hc_add_series(
    data = df,
    type = "column",
    hcaes(name = name, y = y),
    name = "Things",
    colorByPoint = TRUE
  )

dfan <- data.frame(
  name = c("Cats", "Dogs", "Cows", "Sheep", "Pigs"),
  value = c(4, 3, 1, 2, 1)
)

dffru <- data.frame(
  name = c("Apple", "Organes"),
  value = c(4, 2)
)


dsan <- list_parse2(dfan)

dsfru <- list_parse2(dffru)

hc <- hc |>
  hc_drilldown(
    allowPointDrilldown = TRUE,
    series = list(
      list(
        id = "animals",
        data = dsan
      ),
      list(
        id = "fruits",
        data = dsfru
      )
    )
  )

hc

{"x":{"hc_opts":{"chart":{"reflow":true},"title":{"text":"Basic drilldown"},"yAxis":{"title":{"text":null}},"credits":{"enabled":false},"exporting":{"enabled":false},"boost":{"enabled":false},"plotOptions":{"series":{"label":{"enabled":false},"turboThreshold":0,"boderWidth":0,"dataLabels":{"enabled":true}},"treemap":{"layoutAlgorithm":"squarified"}},"xAxis":{"type":"category"},"legend":{"enabled":false},"series":[{"group":"group","data":[{"name":"Animals","y":5,"drilldown":"animals"},{"name":"Fruits","y":2,"drilldown":"fruits"}],"type":"column","name":"Things","colorByPoint":true}],"drilldown":{"allowPointDrilldown":true,"series":[{"id":"animals","data":[["Cats",4],["Dogs",3],["Cows",1],["Sheep",2],["Pigs",1]]},{"id":"fruits","data":[["Apple",4],["Organes",2]]}]}},"theme":{"chart":{"backgroundColor":"transparent"},"colors":["#7cb5ec","#434348","#90ed7d","#f7a35c","#8085e9","#f15c80","#e4d354","#2b908f","#f45b5b","#91e8e1"]},"conf_opts":{"global":{"Date":null,"VMLRadialGradientURL":"http =//code.highcharts.com/list(version)/gfx/vml-radial-gradient.png","canvasToolsURL":"http =//code.highcharts.com/list(version)/modules/canvas-tools.js","getTimezoneOffset":null,"timezoneOffset":0,"useUTC":true},"lang":{"contextButtonTitle":"Chart context menu","decimalPoint":".","downloadCSV":"Download CSV","downloadJPEG":"Download JPEG image","downloadPDF":"Download PDF document","downloadPNG":"Download PNG image","downloadSVG":"Download SVG vector image","downloadXLS":"Download XLS","drillUpText":"◁ Back to {series.name}","exitFullscreen":"Exit from full screen","exportData":{"annotationHeader":"Annotations","categoryDatetimeHeader":"DateTime","categoryHeader":"Category"},"hideData":"Hide data table","invalidDate":null,"loading":"Loading...","months":["January","February","March","April","May","June","July","August","September","October","November","December"],"noData":"No data to display","numericSymbolMagnitude":1000,"numericSymbols":["k","M","G","T","P","E"],"printChart":"Print chart","resetZoom":"Reset zoom","resetZoomTitle":"Reset zoom level 1:1","shortMonths":["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"],"shortWeekdays":["Sat","Sun","Mon","Tue","Wed","Thu","Fri"],"thousandsSep":" ","viewData":"View data table","viewFullscreen":"View in full screen","weekdays":["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]}},"type":"chart","fonts":[],"debug":false},"evals":[],"jsHooks":[]}

```
