# Annotations options for highcharter objects

A collection of annotations to add to the chart. The basic annotation
allows adding custom labels or shapes. The items can be tied to points,
axis coordinates or chart pixel coordinates. General options for all
annotations can be set using the Highcharts.setOptions function. In this
case only single objects are supported, because it alters the defaults
for all items. For initialization in the chart constructors however,
arrays of annotations are supported. See more in the general docs.

## Usage

``` r
hc_annotations(hc, ...)
```

## Arguments

- hc:

  A `highchart` `htmlwidget` object.

- ...:

  Arguments defined in
  <https://api.highcharts.com/highcharts/annotations>.

## Examples

``` r
# Ex 1
highchart() |> 
  hc_add_series(
    data = c(29.9, 71.5, 106.4, 129.2, 144.0, 176.0, 135.6, 148.5, 216.4, 194.1, 95.6, 54.4)
  ) |> 
  hc_xAxis(
    tickInterval = 0.5,
    gridLineWidth = 1  
  ) |> 
  hc_annotations(
    list(
      labels = 
        list(
          list(
            point = list(x = 3, y = 129.2, xAxis = 0, yAxis = 0),
            text = "x: {x}<br/>y: {y}"
            ),
          list(
            point = list(x = 9, y = 194.1, xAxis = 0, yAxis = 0),
            text = "x: {x}<br/>y: {y}"
            ),
          list(
            point = list(x = 5, y = 100, xAxis = 0),
            text = "x: {x}<br/>y: {point.plotY} px"
            ),
          list(
            point = list(x = 0, y = 0),
            text = "x: {point.plotX} px<br/>y: {point.plotY} px"
            )
          )
      )
    )

{"x":{"hc_opts":{"chart":{"reflow":true},"title":{"text":null},"yAxis":{"title":{"text":null}},"credits":{"enabled":false},"exporting":{"enabled":false},"boost":{"enabled":false},"plotOptions":{"series":{"label":{"enabled":false},"turboThreshold":0},"treemap":{"layoutAlgorithm":"squarified"}},"series":[{"data":[29.9,71.5,106.4,129.2,144,176,135.6,148.5,216.4,194.1,95.59999999999999,54.4]}],"xAxis":{"tickInterval":0.5,"gridLineWidth":1},"annotations":[{"labels":[{"point":{"x":3,"y":129.2,"xAxis":0,"yAxis":0},"text":"x: {x}<br/>y: {y}"},{"point":{"x":9,"y":194.1,"xAxis":0,"yAxis":0},"text":"x: {x}<br/>y: {y}"},{"point":{"x":5,"y":100,"xAxis":0},"text":"x: {x}<br/>y: {point.plotY} px"},{"point":{"x":0,"y":0},"text":"x: {point.plotX} px<br/>y: {point.plotY} px"}]}]},"theme":{"chart":{"backgroundColor":"transparent"},"colors":["#7cb5ec","#434348","#90ed7d","#f7a35c","#8085e9","#f15c80","#e4d354","#2b908f","#f45b5b","#91e8e1"]},"conf_opts":{"global":{"Date":null,"VMLRadialGradientURL":"http =//code.highcharts.com/list(version)/gfx/vml-radial-gradient.png","canvasToolsURL":"http =//code.highcharts.com/list(version)/modules/canvas-tools.js","getTimezoneOffset":null,"timezoneOffset":0,"useUTC":true},"lang":{"contextButtonTitle":"Chart context menu","decimalPoint":".","downloadCSV":"Download CSV","downloadJPEG":"Download JPEG image","downloadPDF":"Download PDF document","downloadPNG":"Download PNG image","downloadSVG":"Download SVG vector image","downloadXLS":"Download XLS","drillUpText":"◁ Back to {series.name}","exitFullscreen":"Exit from full screen","exportData":{"annotationHeader":"Annotations","categoryDatetimeHeader":"DateTime","categoryHeader":"Category"},"hideData":"Hide data table","invalidDate":null,"loading":"Loading...","months":["January","February","March","April","May","June","July","August","September","October","November","December"],"noData":"No data to display","numericSymbolMagnitude":1000,"numericSymbols":["k","M","G","T","P","E"],"printChart":"Print chart","resetZoom":"Reset zoom","resetZoomTitle":"Reset zoom level 1:1","shortMonths":["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"],"shortWeekdays":["Sat","Sun","Mon","Tue","Wed","Thu","Fri"],"thousandsSep":" ","viewData":"View data table","viewFullscreen":"View in full screen","weekdays":["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]}},"type":"chart","fonts":[],"debug":false},"evals":[],"jsHooks":[]}  
# Ex 2
df <- data.frame(
  x = 1:10,
  y = 1:10
)

highchart() |> 
  hc_add_series(data = df, hcaes(x = x, y = y), type = "area") |> 
  hc_annotations(
    list(
      labels = list(
        list(point = list(x = 5, y = 5, xAxis = 0, yAxis = 0), text = "Middle"),
        list(point = list(x = 1, y = 1, xAxis = 0, yAxis = 0), text = "Start")
      )
    )
  )

{"x":{"hc_opts":{"chart":{"reflow":true},"title":{"text":null},"yAxis":{"title":{"text":null}},"credits":{"enabled":false},"exporting":{"enabled":false},"boost":{"enabled":false},"plotOptions":{"series":{"label":{"enabled":false},"turboThreshold":0},"treemap":{"layoutAlgorithm":"squarified"}},"series":[{"group":"group","data":[{"x":1,"y":1},{"x":2,"y":2},{"x":3,"y":3},{"x":4,"y":4},{"x":5,"y":5},{"x":6,"y":6},{"x":7,"y":7},{"x":8,"y":8},{"x":9,"y":9},{"x":10,"y":10}],"type":"area"}],"annotations":[{"labels":[{"point":{"x":5,"y":5,"xAxis":0,"yAxis":0},"text":"Middle"},{"point":{"x":1,"y":1,"xAxis":0,"yAxis":0},"text":"Start"}]}]},"theme":{"chart":{"backgroundColor":"transparent"},"colors":["#7cb5ec","#434348","#90ed7d","#f7a35c","#8085e9","#f15c80","#e4d354","#2b908f","#f45b5b","#91e8e1"]},"conf_opts":{"global":{"Date":null,"VMLRadialGradientURL":"http =//code.highcharts.com/list(version)/gfx/vml-radial-gradient.png","canvasToolsURL":"http =//code.highcharts.com/list(version)/modules/canvas-tools.js","getTimezoneOffset":null,"timezoneOffset":0,"useUTC":true},"lang":{"contextButtonTitle":"Chart context menu","decimalPoint":".","downloadCSV":"Download CSV","downloadJPEG":"Download JPEG image","downloadPDF":"Download PDF document","downloadPNG":"Download PNG image","downloadSVG":"Download SVG vector image","downloadXLS":"Download XLS","drillUpText":"◁ Back to {series.name}","exitFullscreen":"Exit from full screen","exportData":{"annotationHeader":"Annotations","categoryDatetimeHeader":"DateTime","categoryHeader":"Category"},"hideData":"Hide data table","invalidDate":null,"loading":"Loading...","months":["January","February","March","April","May","June","July","August","September","October","November","December"],"noData":"No data to display","numericSymbolMagnitude":1000,"numericSymbols":["k","M","G","T","P","E"],"printChart":"Print chart","resetZoom":"Reset zoom","resetZoomTitle":"Reset zoom level 1:1","shortMonths":["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"],"shortWeekdays":["Sat","Sun","Mon","Tue","Wed","Thu","Fri"],"thousandsSep":" ","viewData":"View data table","viewFullscreen":"View in full screen","weekdays":["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]}},"type":"chart","fonts":[],"debug":false},"evals":[],"jsHooks":[]}
```
