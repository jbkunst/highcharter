# Tooltip options for highcharter objects

Options for the tooltip that appears when the user hovers over a series
or point.

## Usage

``` r
hc_tooltip(hc, ..., sort = FALSE, table = FALSE)
```

## Arguments

- hc:

  A `highchart` `htmlwidget` object.

- ...:

  Arguments defined in <https://api.highcharts.com/highcharts/tooltip>.

- sort:

  Logical value to implement sort according `this.point`.

- table:

  Logical value to implement table in tooltip.

## Examples

``` r
highchart() |>
  hc_add_series(data = sample(1:12)) |> 
  hc_add_series(data = sample(1:12) + 10) |> 
  hc_tooltip(
    crosshairs = TRUE,
    borderWidth = 5,
    sort = TRUE,
    table = TRUE
    ) 

{"x":{"hc_opts":{"chart":{"reflow":true},"title":{"text":null},"yAxis":{"title":{"text":null}},"credits":{"enabled":false},"exporting":{"enabled":false},"boost":{"enabled":false},"plotOptions":{"series":{"label":{"enabled":false},"turboThreshold":0},"treemap":{"layoutAlgorithm":"squarified"}},"series":[{"data":[11,4,8,10,3,1,6,2,7,9,5,12]},{"data":[12,13,21,15,16,18,22,17,14,20,19,11]}],"tooltip":{"shared":true,"formatter":"function(tooltip){\n          function isArray(obj) {\n          return Object.prototype.toString.call(obj) === '[object Array]';\n          }\n\n          function splat(obj) {\n          return isArray(obj) ? obj : [obj];\n          }\n\n          var items = this.points || splat(this), series = items[0].series, s;\n\n          // sort the values\n          items.sort(function(a, b){\n          return ((a.y < b.y) ? -1 : ((a.y > b.y) ? 1 : 0));\n          });\n          items.reverse();\n\n          return tooltip.defaultFormatter.call(this, tooltip);\n        }","useHTML":true,"headerFormat":"<small>{point.key}<\/small><table>","pointFormat":"<tr><td style=\"color: {series.color}\">{series.name}: <\/td><td style=\"text-align: right\"><b>{point.y}<\/b><\/td><\/tr>","footerFormat":"<\/table>","crosshairs":true,"borderWidth":5}},"theme":{"chart":{"backgroundColor":"transparent"},"colors":["#7cb5ec","#434348","#90ed7d","#f7a35c","#8085e9","#f15c80","#e4d354","#2b908f","#f45b5b","#91e8e1"]},"conf_opts":{"global":{"Date":null,"VMLRadialGradientURL":"http =//code.highcharts.com/list(version)/gfx/vml-radial-gradient.png","canvasToolsURL":"http =//code.highcharts.com/list(version)/modules/canvas-tools.js","getTimezoneOffset":null,"timezoneOffset":0,"useUTC":true},"lang":{"contextButtonTitle":"Chart context menu","decimalPoint":".","downloadCSV":"Download CSV","downloadJPEG":"Download JPEG image","downloadPDF":"Download PDF document","downloadPNG":"Download PNG image","downloadSVG":"Download SVG vector image","downloadXLS":"Download XLS","drillUpText":"◁ Back to {series.name}","exitFullscreen":"Exit from full screen","exportData":{"annotationHeader":"Annotations","categoryDatetimeHeader":"DateTime","categoryHeader":"Category"},"hideData":"Hide data table","invalidDate":null,"loading":"Loading...","months":["January","February","March","April","May","June","July","August","September","October","November","December"],"noData":"No data to display","numericSymbolMagnitude":1000,"numericSymbols":["k","M","G","T","P","E"],"printChart":"Print chart","resetZoom":"Reset zoom","resetZoomTitle":"Reset zoom level 1:1","shortMonths":["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"],"shortWeekdays":["Sat","Sun","Mon","Tue","Wed","Thu","Fri"],"thousandsSep":" ","viewData":"View data table","viewFullscreen":"View in full screen","weekdays":["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]}},"type":"chart","fonts":[],"debug":false},"evals":["hc_opts.tooltip.formatter"],"jsHooks":[]}
```
