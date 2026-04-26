# Helper to transform data frame for boxplot highcharts format

Helper to transform data frame for boxplot highcharts format

## Usage

``` r
data_to_boxplot(
  data,
  variable,
  group_var = NULL,
  group_var2 = NULL,
  add_outliers = FALSE,
  ...
)
```

## Arguments

- data:

  The data frame containing variables.

- variable:

  The variable to calculate the box plot data.

- group_var:

  A variable to split calculation

- group_var2:

  A second variable to create separate series.

- add_outliers:

  A logical value indicating if outliers series should be calculated.
  Default to `FALSE`.

- ...:

  Arguments defined in
  <https://api.highcharts.com/highcharts/plotOptions.series>.

## Examples

``` r
data(pokemon)

dat <- data_to_boxplot(pokemon, height)

highchart() |>
  hc_xAxis(type = "category") |>
  hc_add_series_list(dat)

{"x":{"hc_opts":{"chart":{"reflow":true},"title":{"text":null},"yAxis":{"title":{"text":null}},"credits":{"enabled":false},"exporting":{"enabled":false},"boost":{"enabled":false},"plotOptions":{"series":{"label":{"enabled":false},"turboThreshold":0},"treemap":{"layoutAlgorithm":"squarified"}},"xAxis":{"type":"category"},"series":[{"name":null,"data":[{"name":0,"low":1,"q1":5,"median":10,"q3":15,"high":30}],"id":null,"type":"boxplot"}]},"theme":{"chart":{"backgroundColor":"transparent"},"colors":["#7cb5ec","#434348","#90ed7d","#f7a35c","#8085e9","#f15c80","#e4d354","#2b908f","#f45b5b","#91e8e1"]},"conf_opts":{"global":{"Date":null,"VMLRadialGradientURL":"http =//code.highcharts.com/list(version)/gfx/vml-radial-gradient.png","canvasToolsURL":"http =//code.highcharts.com/list(version)/modules/canvas-tools.js","getTimezoneOffset":null,"timezoneOffset":0,"useUTC":true},"lang":{"contextButtonTitle":"Chart context menu","decimalPoint":".","downloadCSV":"Download CSV","downloadJPEG":"Download JPEG image","downloadPDF":"Download PDF document","downloadPNG":"Download PNG image","downloadSVG":"Download SVG vector image","downloadXLS":"Download XLS","drillUpText":"◁ Back to {series.name}","exitFullscreen":"Exit from full screen","exportData":{"annotationHeader":"Annotations","categoryDatetimeHeader":"DateTime","categoryHeader":"Category"},"hideData":"Hide data table","invalidDate":null,"loading":"Loading...","months":["January","February","March","April","May","June","July","August","September","October","November","December"],"noData":"No data to display","numericSymbolMagnitude":1000,"numericSymbols":["k","M","G","T","P","E"],"printChart":"Print chart","resetZoom":"Reset zoom","resetZoomTitle":"Reset zoom level 1:1","shortMonths":["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"],"shortWeekdays":["Sat","Sun","Mon","Tue","Wed","Thu","Fri"],"thousandsSep":" ","viewData":"View data table","viewFullscreen":"View in full screen","weekdays":["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]}},"type":"chart","fonts":[],"debug":false},"evals":[],"jsHooks":[]}
dat <- data_to_boxplot(pokemon, height, type_1, name = "height in meters")

highchart() |>
  hc_xAxis(type = "category") |>
  hc_add_series_list(dat)

{"x":{"hc_opts":{"chart":{"reflow":true},"title":{"text":null},"yAxis":{"title":{"text":null}},"credits":{"enabled":false},"exporting":{"enabled":false},"boost":{"enabled":false},"plotOptions":{"series":{"label":{"enabled":false},"turboThreshold":0},"treemap":{"layoutAlgorithm":"squarified"}},"xAxis":{"type":"category"},"series":[{"name":"height in meters","data":[{"name":"bug","low":1,"q1":4,"median":8,"q3":12,"high":24},{"name":"dark","low":4,"q1":6,"median":10.5,"q3":15,"high":18},{"name":"dragon","low":3,"q1":10.5,"median":16,"q3":21.5,"high":32},{"name":"electric","low":2,"q1":4,"median":8,"q3":15,"high":23},{"name":"fairy","low":1,"q1":3,"median":6,"q3":11,"high":15},{"name":"fighting","low":5,"q1":7,"median":12.5,"q3":15.5,"high":23},{"name":"fire","low":3,"q1":6,"median":10,"q3":17,"high":30},{"name":"flying","low":2,"q1":6.5,"median":8,"q3":15,"high":22},{"name":"ghost","low":1,"q1":5,"median":10,"q3":15,"high":22},{"name":"grass","low":2,"q1":4,"median":8,"q3":12,"high":22},{"name":"ground","low":2,"q1":7,"median":10,"q3":19.5,"high":38},{"name":"ice","low":3,"q1":8,"median":12,"q3":15,"high":25},{"name":"normal","low":2,"q1":5,"median":9,"q3":13,"high":23},{"name":"poison","low":4,"q1":6,"median":10,"q3":16.5,"high":27},{"name":"psychic","low":1,"q1":4,"median":8.5,"q3":14,"high":24},{"name":"rock","low":3,"q1":6,"median":11.5,"q3":15,"high":28},{"name":"steel","low":2,"q1":6,"median":11,"q3":19,"high":30},{"name":"water","low":2,"q1":6,"median":10,"q3":15,"high":25}],"id":null,"type":"boxplot"}]},"theme":{"chart":{"backgroundColor":"transparent"},"colors":["#7cb5ec","#434348","#90ed7d","#f7a35c","#8085e9","#f15c80","#e4d354","#2b908f","#f45b5b","#91e8e1"]},"conf_opts":{"global":{"Date":null,"VMLRadialGradientURL":"http =//code.highcharts.com/list(version)/gfx/vml-radial-gradient.png","canvasToolsURL":"http =//code.highcharts.com/list(version)/modules/canvas-tools.js","getTimezoneOffset":null,"timezoneOffset":0,"useUTC":true},"lang":{"contextButtonTitle":"Chart context menu","decimalPoint":".","downloadCSV":"Download CSV","downloadJPEG":"Download JPEG image","downloadPDF":"Download PDF document","downloadPNG":"Download PNG image","downloadSVG":"Download SVG vector image","downloadXLS":"Download XLS","drillUpText":"◁ Back to {series.name}","exitFullscreen":"Exit from full screen","exportData":{"annotationHeader":"Annotations","categoryDatetimeHeader":"DateTime","categoryHeader":"Category"},"hideData":"Hide data table","invalidDate":null,"loading":"Loading...","months":["January","February","March","April","May","June","July","August","September","October","November","December"],"noData":"No data to display","numericSymbolMagnitude":1000,"numericSymbols":["k","M","G","T","P","E"],"printChart":"Print chart","resetZoom":"Reset zoom","resetZoomTitle":"Reset zoom level 1:1","shortMonths":["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"],"shortWeekdays":["Sat","Sun","Mon","Tue","Wed","Thu","Fri"],"thousandsSep":" ","viewData":"View data table","viewFullscreen":"View in full screen","weekdays":["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]}},"type":"chart","fonts":[],"debug":false},"evals":[],"jsHooks":[]}if (FALSE) { # \dontrun{

} # }
```
