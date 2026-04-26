# Yaxis options for highcharter objects

The Y axis or value axis. Normally this is the vertical axis, though if
the chart is inverted this is the horizontal axis. In case of multiple
axes, the yAxis node is an array of configuration objects. See the Axis
object for programmatic access to the axis.

## Usage

``` r
hc_yAxis(hc, ...)
```

## Arguments

- hc:

  A `highchart` `htmlwidget` object.

- ...:

  Arguments defined in <https://api.highcharts.com/highcharts/yAxis>.

## Examples

``` r
highchart() |>
  hc_add_series(
    data = c(7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6),
    type = "spline"
  ) |> 
  hc_yAxis(
    title = list(text = "y Axis at right"),
    opposite = TRUE,
    alternateGridColor = "#FAFAFA",
    minorTickInterval = "auto",
    minorGridLineDashStyle = "LongDashDotDot",
    showFirstLabel = FALSE,
    showLastLabel = FALSE,
    plotBands = list(
      list(
        from = 13,
        to = 17,
        color = "rgba(100, 0, 0, 0.1)",
        label = list(text = "This is a plotBand")
        )
      )
    ) 

{"x":{"hc_opts":{"chart":{"reflow":true},"title":{"text":null},"yAxis":{"title":{"text":"y Axis at right"},"opposite":true,"alternateGridColor":"#FAFAFA","minorTickInterval":"auto","minorGridLineDashStyle":"LongDashDotDot","showFirstLabel":false,"showLastLabel":false,"plotBands":[{"from":13,"to":17,"color":"rgba(100, 0, 0, 0.1)","label":{"text":"This is a plotBand"}}]},"credits":{"enabled":false},"exporting":{"enabled":false},"boost":{"enabled":false},"plotOptions":{"series":{"label":{"enabled":false},"turboThreshold":0},"treemap":{"layoutAlgorithm":"squarified"}},"series":[{"data":[7,6.9,9.5,14.5,18.2,21.5,25.2,26.5,23.3,18.3,13.9,9.6],"type":"spline"}]},"theme":{"chart":{"backgroundColor":"transparent"},"colors":["#7cb5ec","#434348","#90ed7d","#f7a35c","#8085e9","#f15c80","#e4d354","#2b908f","#f45b5b","#91e8e1"]},"conf_opts":{"global":{"Date":null,"VMLRadialGradientURL":"http =//code.highcharts.com/list(version)/gfx/vml-radial-gradient.png","canvasToolsURL":"http =//code.highcharts.com/list(version)/modules/canvas-tools.js","getTimezoneOffset":null,"timezoneOffset":0,"useUTC":true},"lang":{"contextButtonTitle":"Chart context menu","decimalPoint":".","downloadCSV":"Download CSV","downloadJPEG":"Download JPEG image","downloadPDF":"Download PDF document","downloadPNG":"Download PNG image","downloadSVG":"Download SVG vector image","downloadXLS":"Download XLS","drillUpText":"◁ Back to {series.name}","exitFullscreen":"Exit from full screen","exportData":{"annotationHeader":"Annotations","categoryDatetimeHeader":"DateTime","categoryHeader":"Category"},"hideData":"Hide data table","invalidDate":null,"loading":"Loading...","months":["January","February","March","April","May","June","July","August","September","October","November","December"],"noData":"No data to display","numericSymbolMagnitude":1000,"numericSymbols":["k","M","G","T","P","E"],"printChart":"Print chart","resetZoom":"Reset zoom","resetZoomTitle":"Reset zoom level 1:1","shortMonths":["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"],"shortWeekdays":["Sat","Sun","Mon","Tue","Wed","Thu","Fri"],"thousandsSep":" ","viewData":"View data table","viewFullscreen":"View in full screen","weekdays":["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]}},"type":"chart","fonts":[],"debug":false},"evals":[],"jsHooks":[]}
```
