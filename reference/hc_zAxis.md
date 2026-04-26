# Zaxis options for highcharter objects

The Z axis or depth axis for 3D plots. See the Axis class for
programmatic access to the axis.

## Usage

``` r
hc_zAxis(hc, ...)
```

## Arguments

- hc:

  A `highchart` `htmlwidget` object.

- ...:

  Arguments defined in <https://api.highcharts.com/highcharts/zAxis>.

## Examples

``` r
df <- data.frame(
  x = sample(1:5),
  y = sample(1:5),
  z = sample(1:5)
)

highchart() |>
  hc_add_series(data = df, "scatter3d", hcaes(x = x, y = y, z = z)) |> 
  hc_chart(
    type = "scatter3d",
    options3d = list(
      enabled = TRUE,
      alpha = 20,
      beta = 30,
      depth = 200,
      viewDistance = 5,
      frame = list(
        bottom = list(
          size = 1,
          color = "rgba(0,0,0,0.05)"
        )
      )
    )
  ) |> 
  hc_zAxis(
    title = list(text = "Z axis is here"),
    startOnTick = FALSE,
    tickInterval = 2,
    tickLength = 4,
    tickWidth = 1,
    gridLineColor = "red",
    gridLineDashStyle = "dot"
  )

{"x":{"hc_opts":{"chart":{"reflow":true,"type":"scatter3d","options3d":{"enabled":true,"alpha":20,"beta":30,"depth":200,"viewDistance":5,"frame":{"bottom":{"size":1,"color":"rgba(0,0,0,0.05)"}}}},"title":{"text":null},"yAxis":{"title":{"text":null}},"credits":{"enabled":false},"exporting":{"enabled":false},"boost":{"enabled":false},"plotOptions":{"series":{"label":{"enabled":false},"turboThreshold":0},"treemap":{"layoutAlgorithm":"squarified"}},"series":[{"group":"group","data":[{"x":1,"y":2,"z":4},{"x":2,"y":1,"z":3},{"x":5,"y":5,"z":1},{"x":3,"y":3,"z":2},{"x":4,"y":4,"z":5}],"type":"scatter3d"}],"zAxis":{"title":{"text":"Z axis is here"},"startOnTick":false,"tickInterval":2,"tickLength":4,"tickWidth":1,"gridLineColor":"red","gridLineDashStyle":"dot"}},"theme":{"chart":{"backgroundColor":"transparent"},"colors":["#7cb5ec","#434348","#90ed7d","#f7a35c","#8085e9","#f15c80","#e4d354","#2b908f","#f45b5b","#91e8e1"]},"conf_opts":{"global":{"Date":null,"VMLRadialGradientURL":"http =//code.highcharts.com/list(version)/gfx/vml-radial-gradient.png","canvasToolsURL":"http =//code.highcharts.com/list(version)/modules/canvas-tools.js","getTimezoneOffset":null,"timezoneOffset":0,"useUTC":true},"lang":{"contextButtonTitle":"Chart context menu","decimalPoint":".","downloadCSV":"Download CSV","downloadJPEG":"Download JPEG image","downloadPDF":"Download PDF document","downloadPNG":"Download PNG image","downloadSVG":"Download SVG vector image","downloadXLS":"Download XLS","drillUpText":"◁ Back to {series.name}","exitFullscreen":"Exit from full screen","exportData":{"annotationHeader":"Annotations","categoryDatetimeHeader":"DateTime","categoryHeader":"Category"},"hideData":"Hide data table","invalidDate":null,"loading":"Loading...","months":["January","February","March","April","May","June","July","August","September","October","November","December"],"noData":"No data to display","numericSymbolMagnitude":1000,"numericSymbols":["k","M","G","T","P","E"],"printChart":"Print chart","resetZoom":"Reset zoom","resetZoomTitle":"Reset zoom level 1:1","shortMonths":["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"],"shortWeekdays":["Sat","Sun","Mon","Tue","Wed","Thu","Fri"],"thousandsSep":" ","viewData":"View data table","viewFullscreen":"View in full screen","weekdays":["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]}},"type":"chart","fonts":[],"debug":false},"evals":[],"jsHooks":[]}
```
