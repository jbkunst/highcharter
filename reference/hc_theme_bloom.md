# Bloomberg Graphics theme for highcharts

Bloomberg Graphics theme for highcharts

## Usage

``` r
hc_theme_bloom(...)
```

## Arguments

- ...:

  A named parameters to modify the theme.

## Examples

``` r
highcharts_demo() |>
  hc_add_theme(hc_theme_bloom())

{"x":{"hc_opts":{"chart":{"reflow":true},"title":{"text":"Monthly Average Temperature"},"yAxis":{"title":{"text":"Temperature"}},"credits":{"enabled":true,"text":"Made with highcharter","href":"http://jkunst.com/highcharter/"},"exporting":{"enabled":false},"boost":{"enabled":false},"plotOptions":{"series":{"label":{"enabled":false},"turboThreshold":0},"treemap":{"layoutAlgorithm":"squarified"}},"subtitle":{"text":"Source: WorldClimate.com"},"caption":{"text":"This is a caption text to show the style of this type of text"},"xAxis":{"title":{"text":"Months"},"categories":["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]},"series":[{"data":[7,6.9,9.5,14.5,18.2,21.5,25.2,26.5,23.3,18.3,13.9,9.6],"name":"Tokyo"},{"data":[3.9,4.2,5.7,8.5,11.9,15.2,17,16.6,14.2,10.3,6.6,4.8],"name":"London"},{"data":[-0.9,0.6,3.5,8.4,13.5,17,18.6,17.9,14.3,9,3.9,1],"name":"Berlin"}]},"theme":{"colors":["#E10033","#000000","#767676","#E4E4E4"],"chart":{"backgroundColor":"#FFFFFF","style":{"fontFamily":"Roboto","color":"#000000"}},"title":{"align":"left","style":{"fontFamily":"Roboto","color":"#000000","fontWeight":"bold"}},"subtitle":{"align":"left","style":{"fontFamily":"Roboto","color":"#000000","fontWeight":"bold"}},"xAxis":{"lineColor":"#000000","lineWidth":2,"tickColor":"#000000","tickWidth":2,"labels":{"style":{"color":"black"}},"title":{"style":{"color":"black"}}},"yAxis":{"opposite":true,"gridLineWidth":2,"gridLineColor":"#F3F3F3","lineColor":"#CEC6B9","minorGridLineColor":"#CEC6B9","labels":{"align":"left","style":{"color":"black"},"x":0,"y":-2},"tickLength":0,"tickColor":"#CEC6B9","tickWidth":1,"title":{"style":{"color":"black"}}},"tooltip":{"backgroundColor":"#FFFFFF","borderColor":"#76c0c1","style":{"color":"#000000"}},"legend":{"layout":"horizontal","align":"left","verticalAlign":"top","itemStyle":{"color":"#3C3C3C"},"itemHiddenStyle":{"color":"#606063"}},"credits":{"style":{"color":"#666"}},"labels":{"style":{"color":"#D7D7D8"}},"drilldown":{"activeAxisLabelStyle":{"color":"#F0F0F3"},"activeDataLabelStyle":{"color":"#F0F0F3"}},"navigation":{"buttonOptions":{"symbolStroke":"#DDDDDD","theme":{"fill":"#505053"}}},"legendBackgroundColor":"rgba(0, 0, 0, 0.5)","background2":"#505053","dataLabelsColor":"#B0B0B3","textColor":"#C0C0C0","contrastTextColor":"#F0F0F3","maskColor":"rgba(255,255,255,0.3)"},"conf_opts":{"global":{"Date":null,"VMLRadialGradientURL":"http =//code.highcharts.com/list(version)/gfx/vml-radial-gradient.png","canvasToolsURL":"http =//code.highcharts.com/list(version)/modules/canvas-tools.js","getTimezoneOffset":null,"timezoneOffset":0,"useUTC":true},"lang":{"contextButtonTitle":"Chart context menu","decimalPoint":".","downloadCSV":"Download CSV","downloadJPEG":"Download JPEG image","downloadPDF":"Download PDF document","downloadPNG":"Download PNG image","downloadSVG":"Download SVG vector image","downloadXLS":"Download XLS","drillUpText":"◁ Back to {series.name}","exitFullscreen":"Exit from full screen","exportData":{"annotationHeader":"Annotations","categoryDatetimeHeader":"DateTime","categoryHeader":"Category"},"hideData":"Hide data table","invalidDate":null,"loading":"Loading...","months":["January","February","March","April","May","June","July","August","September","October","November","December"],"noData":"No data to display","numericSymbolMagnitude":1000,"numericSymbols":["k","M","G","T","P","E"],"printChart":"Print chart","resetZoom":"Reset zoom","resetZoomTitle":"Reset zoom level 1:1","shortMonths":["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"],"shortWeekdays":["Sat","Sun","Mon","Tue","Wed","Thu","Fri"],"thousandsSep":" ","viewData":"View data table","viewFullscreen":"View in full screen","weekdays":["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]}},"type":"chart","fonts":"Roboto","debug":false},"evals":[],"jsHooks":[]}
```
