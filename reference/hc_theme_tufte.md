# Tufte theme for highcharts

Tufte theme for highcharts

## Usage

``` r
hc_theme_tufte(...)
```

## Arguments

- ...:

  A named parameters to modify the theme.

## Examples

``` r
n <- 15

dta <- data.frame(
  x = 1:n + rnorm(n),
  y = 2 * 1:n + rnorm(n)
)

highchart() |>
  hc_chart(type = "scatter") |>
  hc_add_series(data = list_parse(dta), showInLegend = FALSE) |>
  hc_add_theme(hc_theme_tufte())

{"x":{"hc_opts":{"chart":{"reflow":true,"type":"scatter"},"title":{"text":null},"yAxis":{"title":{"text":null}},"credits":{"enabled":false},"exporting":{"enabled":false},"boost":{"enabled":false},"plotOptions":{"series":{"label":{"enabled":false},"turboThreshold":0},"treemap":{"layoutAlgorithm":"squarified"}},"series":[{"data":[{"x":2.809108551764822,"y":5.586945475704337},{"x":3.113986006040515,"y":4.755743005728581},{"x":3.465350534180041,"y":6.400127303498656},{"x":2.931370271360024,"y":8.829345713039135},{"x":5.255940283745922,"y":9.694863757200833},{"x":5.22278106624844,"y":12.71010332194469},{"x":6.049681762807337,"y":14.43861381668822},{"x":9.230516331906459,"y":16.3582236967963},{"x":8.709678669983662,"y":17.87576234886379},{"x":8.754750414673296,"y":19.30678391493004},{"x":10.07488937727351,"y":22.5743465281119},{"x":11.64824172886363,"y":23.78284048478621},{"x":12.95836917162025,"y":29.0375811627325},{"x":14.72929742240132,"y":26.40833286889784},{"x":15.29340302870936,"y":29.32631076413446}],"showInLegend":false}]},"theme":{"colors":["#737373","#D8D7D6","#B2B0AD","#8C8984"],"chart":{"style":{"fontFamily":"Cardo"}},"xAxis":{"lineWidth":0,"minorGridLineWidth":0,"lineColor":"transparent","tickColor":"#737373"},"yAxis":{"lineWidth":0,"minorGridLineWidth":0,"lineColor":"transparent","tickColor":"#737373","tickWidth":1,"gridLineColor":"transparent"}},"conf_opts":{"global":{"Date":null,"VMLRadialGradientURL":"http =//code.highcharts.com/list(version)/gfx/vml-radial-gradient.png","canvasToolsURL":"http =//code.highcharts.com/list(version)/modules/canvas-tools.js","getTimezoneOffset":null,"timezoneOffset":0,"useUTC":true},"lang":{"contextButtonTitle":"Chart context menu","decimalPoint":".","downloadCSV":"Download CSV","downloadJPEG":"Download JPEG image","downloadPDF":"Download PDF document","downloadPNG":"Download PNG image","downloadSVG":"Download SVG vector image","downloadXLS":"Download XLS","drillUpText":"◁ Back to {series.name}","exitFullscreen":"Exit from full screen","exportData":{"annotationHeader":"Annotations","categoryDatetimeHeader":"DateTime","categoryHeader":"Category"},"hideData":"Hide data table","invalidDate":null,"loading":"Loading...","months":["January","February","March","April","May","June","July","August","September","October","November","December"],"noData":"No data to display","numericSymbolMagnitude":1000,"numericSymbols":["k","M","G","T","P","E"],"printChart":"Print chart","resetZoom":"Reset zoom","resetZoomTitle":"Reset zoom level 1:1","shortMonths":["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"],"shortWeekdays":["Sat","Sun","Mon","Tue","Wed","Thu","Fri"],"thousandsSep":" ","viewData":"View data table","viewFullscreen":"View in full screen","weekdays":["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]}},"type":"chart","fonts":"Cardo","debug":false},"evals":[],"jsHooks":[]}
```
