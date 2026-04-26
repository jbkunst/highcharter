# Chalk theme for highcharts

Chalk theme for highcharts

## Usage

``` r
hc_theme_chalk(...)
```

## Arguments

- ...:

  A named parameters to modify the theme.

  Chalk theme for highcharts was inspired by
  <https://www.amcharts.com/demos/>.

## Examples

``` r
highcharts_demo() |>
  hc_add_theme(hc_theme_chalk())

{"x":{"hc_opts":{"chart":{"reflow":true},"title":{"text":"Monthly Average Temperature"},"yAxis":{"title":{"text":"Temperature"}},"credits":{"enabled":true,"text":"Made with highcharter","href":"http://jkunst.com/highcharter/"},"exporting":{"enabled":false},"boost":{"enabled":false},"plotOptions":{"series":{"label":{"enabled":false},"turboThreshold":0},"treemap":{"layoutAlgorithm":"squarified"}},"subtitle":{"text":"Source: WorldClimate.com"},"caption":{"text":"This is a caption text to show the style of this type of text"},"xAxis":{"title":{"text":"Months"},"categories":["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]},"series":[{"data":[7,6.9,9.5,14.5,18.2,21.5,25.2,26.5,23.3,18.3,13.9,9.6],"name":"Tokyo"},{"data":[3.9,4.2,5.7,8.5,11.9,15.2,17,16.6,14.2,10.3,6.6,4.8],"name":"London"},{"data":[-0.9,0.6,3.5,8.4,13.5,17,18.6,17.9,14.3,9,3.9,1],"name":"Berlin"}]},"theme":{"colors":["#FFFFFF","#D8D7D6","#B2B0AD","#8C8984"],"chart":{"divBackgroundImage":"https://www.amcharts.com/inspiration/chalk/bg.jpg","backgroundColor":"transparent","style":{"fontFamily":"Shadows Into Light","color":"#FFFFFF"}},"plotOptions":{"scatter":{"marker":{"radius":10}}},"title":{"style":{"fontSize":"30px","color":"#FFFFFF"}},"subtitle":{"style":{"fontSize":"20px","color":"#FFFFFF"}},"legend":{"enabled":true,"itemStyle":{"fontSize":"20px","color":"#FFFFFF"}},"credits":{"enabled":false},"xAxis":{"lineWidth":1,"tickWidth":1,"gridLineColor":"transparent","labels":{"enabled":true,"style":{"color":"#FFFFFF","fontSize":"20px"}},"title":{"enabled":true,"style":{"color":"#FFFFFF","fontSize":"20px"}}},"yAxis":{"lineWidth":1,"tickWidth":1,"gridLineColor":"transparent","labels":{"enabled":true,"style":{"color":"#FFFFFF","fontSize":"20px"}},"title":{"enabled":true,"style":{"color":"#FFFFFF","fontSize":"20px"}}},"tooltip":{"backgroundColor":"#333333","style":{"color":"#FFFFFF","fontSize":"20px","padding":"10px"}}},"conf_opts":{"global":{"Date":null,"VMLRadialGradientURL":"http =//code.highcharts.com/list(version)/gfx/vml-radial-gradient.png","canvasToolsURL":"http =//code.highcharts.com/list(version)/modules/canvas-tools.js","getTimezoneOffset":null,"timezoneOffset":0,"useUTC":true},"lang":{"contextButtonTitle":"Chart context menu","decimalPoint":".","downloadCSV":"Download CSV","downloadJPEG":"Download JPEG image","downloadPDF":"Download PDF document","downloadPNG":"Download PNG image","downloadSVG":"Download SVG vector image","downloadXLS":"Download XLS","drillUpText":"◁ Back to {series.name}","exitFullscreen":"Exit from full screen","exportData":{"annotationHeader":"Annotations","categoryDatetimeHeader":"DateTime","categoryHeader":"Category"},"hideData":"Hide data table","invalidDate":null,"loading":"Loading...","months":["January","February","March","April","May","June","July","August","September","October","November","December"],"noData":"No data to display","numericSymbolMagnitude":1000,"numericSymbols":["k","M","G","T","P","E"],"printChart":"Print chart","resetZoom":"Reset zoom","resetZoomTitle":"Reset zoom level 1:1","shortMonths":["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"],"shortWeekdays":["Sat","Sun","Mon","Tue","Wed","Thu","Fri"],"thousandsSep":" ","viewData":"View data table","viewFullscreen":"View in full screen","weekdays":["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]}},"type":"chart","fonts":"Shadows+Into+Light","debug":false},"evals":[],"jsHooks":[]}
```
