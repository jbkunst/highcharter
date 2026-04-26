# Caption options for highcharter objects

The chart's caption, which will render below the chart and will be part
of exported charts. The caption can be updated after chart
initialization through the Chart.update or Chart.caption.update methods.

## Usage

``` r
hc_caption(hc, ...)
```

## Arguments

- hc:

  A `highchart` `htmlwidget` object.

- ...:

  Arguments defined in <https://api.highcharts.com/highcharts/caption>.

## Examples

``` r
highchart() |> 
  hc_title(text= "Chart with a caption") |> 
  hc_subtitle(text= "This is the subtitle") |> 
  hc_xAxis(categories = c("Apples", "Pears", "Banana", "Orange")) |> 
  hc_add_series(
    data = c(1, 4, 3, 5),
    type = "column",
    name = "Fruits"
  ) |> 
  hc_caption(
    text = "<b>The caption renders in the bottom, and is part of the exported
    chart.</b><br><em>Lorem ipsum dolor sit amet, consectetur adipiscing elit,
    sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim
    ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip 
    ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate 
    velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat 
    cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est
    laborum.</em>'"
  )

{"x":{"hc_opts":{"chart":{"reflow":true},"title":{"text":"Chart with a caption"},"yAxis":{"title":{"text":null}},"credits":{"enabled":false},"exporting":{"enabled":false},"boost":{"enabled":false},"plotOptions":{"series":{"label":{"enabled":false},"turboThreshold":0},"treemap":{"layoutAlgorithm":"squarified"}},"subtitle":{"text":"This is the subtitle"},"xAxis":{"categories":["Apples","Pears","Banana","Orange"]},"series":[{"data":[1,4,3,5],"type":"column","name":"Fruits"}],"caption":{"text":"<b>The caption renders in the bottom, and is part of the exported\n    chart.<\/b><br><em>Lorem ipsum dolor sit amet, consectetur adipiscing elit,\n    sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim\n    ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip \n    ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate \n    velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat \n    cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est\n    laborum.<\/em>'"}},"theme":{"chart":{"backgroundColor":"transparent"},"colors":["#7cb5ec","#434348","#90ed7d","#f7a35c","#8085e9","#f15c80","#e4d354","#2b908f","#f45b5b","#91e8e1"]},"conf_opts":{"global":{"Date":null,"VMLRadialGradientURL":"http =//code.highcharts.com/list(version)/gfx/vml-radial-gradient.png","canvasToolsURL":"http =//code.highcharts.com/list(version)/modules/canvas-tools.js","getTimezoneOffset":null,"timezoneOffset":0,"useUTC":true},"lang":{"contextButtonTitle":"Chart context menu","decimalPoint":".","downloadCSV":"Download CSV","downloadJPEG":"Download JPEG image","downloadPDF":"Download PDF document","downloadPNG":"Download PNG image","downloadSVG":"Download SVG vector image","downloadXLS":"Download XLS","drillUpText":"◁ Back to {series.name}","exitFullscreen":"Exit from full screen","exportData":{"annotationHeader":"Annotations","categoryDatetimeHeader":"DateTime","categoryHeader":"Category"},"hideData":"Hide data table","invalidDate":null,"loading":"Loading...","months":["January","February","March","April","May","June","July","August","September","October","November","December"],"noData":"No data to display","numericSymbolMagnitude":1000,"numericSymbols":["k","M","G","T","P","E"],"printChart":"Print chart","resetZoom":"Reset zoom","resetZoomTitle":"Reset zoom level 1:1","shortMonths":["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"],"shortWeekdays":["Sat","Sun","Mon","Tue","Wed","Thu","Fri"],"thousandsSep":" ","viewData":"View data table","viewFullscreen":"View in full screen","weekdays":["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]}},"type":"chart","fonts":[],"debug":false},"evals":[],"jsHooks":[]}
```
