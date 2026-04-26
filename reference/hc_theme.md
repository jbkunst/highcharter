# Creating highcharter themes

Highcharts is very flexible so you can modify every element of the
chart. There are some exiting themes so you can apply style to charts
with few lines of code.

## Usage

``` r
hc_theme(...)
```

## Arguments

- ...:

  A list of named parameters.

## Details

More examples and details in
<https://www.highcharts.com/docs/chart-design-and-style/themes>.

## Examples

``` r
hc <- highcharts_demo()

hc

{"x":{"hc_opts":{"chart":{"reflow":true},"title":{"text":"Monthly Average Temperature"},"yAxis":{"title":{"text":"Temperature"}},"credits":{"enabled":true,"text":"Made with highcharter","href":"http://jkunst.com/highcharter/"},"exporting":{"enabled":false},"boost":{"enabled":false},"plotOptions":{"series":{"label":{"enabled":false},"turboThreshold":0},"treemap":{"layoutAlgorithm":"squarified"}},"subtitle":{"text":"Source: WorldClimate.com"},"caption":{"text":"This is a caption text to show the style of this type of text"},"xAxis":{"title":{"text":"Months"},"categories":["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]},"series":[{"data":[7,6.9,9.5,14.5,18.2,21.5,25.2,26.5,23.3,18.3,13.9,9.6],"name":"Tokyo"},{"data":[3.9,4.2,5.7,8.5,11.9,15.2,17,16.6,14.2,10.3,6.6,4.8],"name":"London"},{"data":[-0.9,0.6,3.5,8.4,13.5,17,18.6,17.9,14.3,9,3.9,1],"name":"Berlin"}]},"theme":{"chart":{"backgroundColor":"transparent"},"colors":["#7cb5ec","#434348","#90ed7d","#f7a35c","#8085e9","#f15c80","#e4d354","#2b908f","#f45b5b","#91e8e1"]},"conf_opts":{"global":{"Date":null,"VMLRadialGradientURL":"http =//code.highcharts.com/list(version)/gfx/vml-radial-gradient.png","canvasToolsURL":"http =//code.highcharts.com/list(version)/modules/canvas-tools.js","getTimezoneOffset":null,"timezoneOffset":0,"useUTC":true},"lang":{"contextButtonTitle":"Chart context menu","decimalPoint":".","downloadCSV":"Download CSV","downloadJPEG":"Download JPEG image","downloadPDF":"Download PDF document","downloadPNG":"Download PNG image","downloadSVG":"Download SVG vector image","downloadXLS":"Download XLS","drillUpText":"◁ Back to {series.name}","exitFullscreen":"Exit from full screen","exportData":{"annotationHeader":"Annotations","categoryDatetimeHeader":"DateTime","categoryHeader":"Category"},"hideData":"Hide data table","invalidDate":null,"loading":"Loading...","months":["January","February","March","April","May","June","July","August","September","October","November","December"],"noData":"No data to display","numericSymbolMagnitude":1000,"numericSymbols":["k","M","G","T","P","E"],"printChart":"Print chart","resetZoom":"Reset zoom","resetZoomTitle":"Reset zoom level 1:1","shortMonths":["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"],"shortWeekdays":["Sat","Sun","Mon","Tue","Wed","Thu","Fri"],"thousandsSep":" ","viewData":"View data table","viewFullscreen":"View in full screen","weekdays":["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]}},"type":"chart","fonts":[],"debug":false},"evals":[],"jsHooks":[]}
thm <- hc_theme(
  colors = c("red", "green", "blue"),
  chart = list(
    backgroundColor = "#15C0DE"
  ),
  title = list(
    style = list(
      color = "#333333",
      fontFamily = "Erica One"
    )
  ),
  subtitle = list(
    style = list(
      color = "#666666",
      fontFamily = "Shadows Into Light"
    )
  ),
  legend = list(
    itemStyle = list(
      fontFamily = "Tangerine",
      color = "black"
    ),
    itemHoverStyle = list(
      color = "gray"
    )
  )
)

hc_add_theme(hc, thm)

{"x":{"hc_opts":{"chart":{"reflow":true},"title":{"text":"Monthly Average Temperature"},"yAxis":{"title":{"text":"Temperature"}},"credits":{"enabled":true,"text":"Made with highcharter","href":"http://jkunst.com/highcharter/"},"exporting":{"enabled":false},"boost":{"enabled":false},"plotOptions":{"series":{"label":{"enabled":false},"turboThreshold":0},"treemap":{"layoutAlgorithm":"squarified"}},"subtitle":{"text":"Source: WorldClimate.com"},"caption":{"text":"This is a caption text to show the style of this type of text"},"xAxis":{"title":{"text":"Months"},"categories":["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]},"series":[{"data":[7,6.9,9.5,14.5,18.2,21.5,25.2,26.5,23.3,18.3,13.9,9.6],"name":"Tokyo"},{"data":[3.9,4.2,5.7,8.5,11.9,15.2,17,16.6,14.2,10.3,6.6,4.8],"name":"London"},{"data":[-0.9,0.6,3.5,8.4,13.5,17,18.6,17.9,14.3,9,3.9,1],"name":"Berlin"}]},"theme":{"colors":["red","green","blue"],"chart":{"backgroundColor":"#15C0DE"},"title":{"style":{"color":"#333333","fontFamily":"Erica One"}},"subtitle":{"style":{"color":"#666666","fontFamily":"Shadows Into Light"}},"legend":{"itemStyle":{"fontFamily":"Tangerine","color":"black"},"itemHoverStyle":{"color":"gray"}}},"conf_opts":{"global":{"Date":null,"VMLRadialGradientURL":"http =//code.highcharts.com/list(version)/gfx/vml-radial-gradient.png","canvasToolsURL":"http =//code.highcharts.com/list(version)/modules/canvas-tools.js","getTimezoneOffset":null,"timezoneOffset":0,"useUTC":true},"lang":{"contextButtonTitle":"Chart context menu","decimalPoint":".","downloadCSV":"Download CSV","downloadJPEG":"Download JPEG image","downloadPDF":"Download PDF document","downloadPNG":"Download PNG image","downloadSVG":"Download SVG vector image","downloadXLS":"Download XLS","drillUpText":"◁ Back to {series.name}","exitFullscreen":"Exit from full screen","exportData":{"annotationHeader":"Annotations","categoryDatetimeHeader":"DateTime","categoryHeader":"Category"},"hideData":"Hide data table","invalidDate":null,"loading":"Loading...","months":["January","February","March","April","May","June","July","August","September","October","November","December"],"noData":"No data to display","numericSymbolMagnitude":1000,"numericSymbols":["k","M","G","T","P","E"],"printChart":"Print chart","resetZoom":"Reset zoom","resetZoomTitle":"Reset zoom level 1:1","shortMonths":["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"],"shortWeekdays":["Sat","Sun","Mon","Tue","Wed","Thu","Fri"],"thousandsSep":" ","viewData":"View data table","viewFullscreen":"View in full screen","weekdays":["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]}},"type":"chart","fonts":["Erica+One","Shadows+Into+Light","Tangerine"],"debug":false},"evals":[],"jsHooks":[]}
```
