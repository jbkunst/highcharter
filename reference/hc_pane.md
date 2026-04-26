# Pane options for highcharter objects

The pane serves as a container for axes and backgrounds for circular
gauges and polar charts. When used in Highcharts.setOptions for theming,
the pane must be a single object, otherwise arrays are supported.

## Usage

``` r
hc_pane(hc, ...)
```

## Arguments

- hc:

  A `highchart` `htmlwidget` object.

- ...:

  Arguments defined in <https://api.highcharts.com/highcharts/pane>.

## Examples

``` r
highchart() |> 
  hc_chart(
  type = "gauge",
  plotBackgroundColor = NULL,
  plotBackgroundImage = NULL,
  plotBorderWidth = 0,
  plotShadow = FALSE
  ) |> 
  hc_title(
    text = "Speedometer"
  ) |> 
  hc_pane(
    startAngle = -150,
    endAngle = 150,
    background = list(list(
      backgroundColor = list(
        linearGradient = list( x1 = 0, y1 = 0, x2 = 0, y2 = 1),
        stops = list(
          list(0, "#FFF"),
          list(1, "#333")
        )
      ),
      borderWidth = 0,
      outerRadius = "109%"
    ), list(
      backgroundColor = list(
        linearGradient = list( x1 = 0, y1 = 0, x2 = 0, y2 = 1),
        stops = list(
          list(0, "#333"),
          list(1, "#FFF")
        )
      ),
      borderWidth = 1,
      outerRadius = "107%"
    ), list(
      # default background
    ), list(
      backgroundColor = "#DDD",
      borderWidth = 0,
      outerRadius = "105%",
      innerRadius = "103%"
    ))
  ) |> 
  hc_add_series(
    data = list(80), name = "speed", tooltip = list(valueSuffix = " km/h")
  ) |> 
  
  
  hc_yAxis(
    min = 0,
    max = 200,
    
    minorTickInterval = "auto",
    minorTickWidth = 1,
    minorTickLength = 10,
    minorTickPosition = "inside",
    minorTickColor = "#666",
    
    tickPixelInterval = 30,
    tickWidth = 2,
    tickPosition = "inside",
    tickLength = 10,
    tickColor = "#666",
    
    labels = list(
      step = 2,
      rotation = "auto"
    ),
    title = list(
      text = "km/h"
    ),
    
    plotBands = list(
      list(from =   0, to = 120, color = "#55BF3B"),
      list(from = 120, to = 160, color = "#DDDF0D"),
      list(from = 160, to = 200, color = "#DF5353")
    )
    
  )

{"x":{"hc_opts":{"chart":{"reflow":true,"type":"gauge","plotBorderWidth":0,"plotShadow":false},"title":{"text":"Speedometer"},"yAxis":{"title":{"text":"km/h"},"min":0,"max":200,"minorTickInterval":"auto","minorTickWidth":1,"minorTickLength":10,"minorTickPosition":"inside","minorTickColor":"#666","tickPixelInterval":30,"tickWidth":2,"tickPosition":"inside","tickLength":10,"tickColor":"#666","labels":{"step":2,"rotation":"auto"},"plotBands":[{"from":0,"to":120,"color":"#55BF3B"},{"from":120,"to":160,"color":"#DDDF0D"},{"from":160,"to":200,"color":"#DF5353"}]},"credits":{"enabled":false},"exporting":{"enabled":false},"boost":{"enabled":false},"plotOptions":{"series":{"label":{"enabled":false},"turboThreshold":0},"treemap":{"layoutAlgorithm":"squarified"}},"pane":{"startAngle":-150,"endAngle":150,"background":[{"backgroundColor":{"linearGradient":{"x1":0,"y1":0,"x2":0,"y2":1},"stops":[[0,"#FFF"],[1,"#333"]]},"borderWidth":0,"outerRadius":"109%"},{"backgroundColor":{"linearGradient":{"x1":0,"y1":0,"x2":0,"y2":1},"stops":[[0,"#333"],[1,"#FFF"]]},"borderWidth":1,"outerRadius":"107%"},[],{"backgroundColor":"#DDD","borderWidth":0,"outerRadius":"105%","innerRadius":"103%"}]},"series":[{"data":[80],"name":"speed","tooltip":{"valueSuffix":" km/h"}}]},"theme":{"chart":{"backgroundColor":"transparent"},"colors":["#7cb5ec","#434348","#90ed7d","#f7a35c","#8085e9","#f15c80","#e4d354","#2b908f","#f45b5b","#91e8e1"]},"conf_opts":{"global":{"Date":null,"VMLRadialGradientURL":"http =//code.highcharts.com/list(version)/gfx/vml-radial-gradient.png","canvasToolsURL":"http =//code.highcharts.com/list(version)/modules/canvas-tools.js","getTimezoneOffset":null,"timezoneOffset":0,"useUTC":true},"lang":{"contextButtonTitle":"Chart context menu","decimalPoint":".","downloadCSV":"Download CSV","downloadJPEG":"Download JPEG image","downloadPDF":"Download PDF document","downloadPNG":"Download PNG image","downloadSVG":"Download SVG vector image","downloadXLS":"Download XLS","drillUpText":"◁ Back to {series.name}","exitFullscreen":"Exit from full screen","exportData":{"annotationHeader":"Annotations","categoryDatetimeHeader":"DateTime","categoryHeader":"Category"},"hideData":"Hide data table","invalidDate":null,"loading":"Loading...","months":["January","February","March","April","May","June","July","August","September","October","November","December"],"noData":"No data to display","numericSymbolMagnitude":1000,"numericSymbols":["k","M","G","T","P","E"],"printChart":"Print chart","resetZoom":"Reset zoom","resetZoomTitle":"Reset zoom level 1:1","shortMonths":["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"],"shortWeekdays":["Sat","Sun","Mon","Tue","Wed","Thu","Fri"],"thousandsSep":" ","viewData":"View data table","viewFullscreen":"View in full screen","weekdays":["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]}},"type":"chart","fonts":[],"debug":false},"evals":[],"jsHooks":[]}
```
