# Scrollbar options for highcharter objects

The scrollbar is a means of panning over the X axis of a stock chart.
Scrollbars can also be applied to other types of axes. Another approach
to scrollable charts is the chart.scrollablePlotArea option that is
especially suitable for simpler cartesian charts on mobile. In styled
mode, all the presentational options for the scrollbar are replaced by
the classes .highcharts-scrollbar-thumb, .highcharts-scrollbar-arrow,
.highcharts-scrollbar-button, .highcharts-scrollbar-rifles and
.highcharts-scrollbar-track.

## Usage

``` r
hc_scrollbar(hc, ...)
```

## Arguments

- hc:

  A `highchart` `htmlwidget` object.

- ...:

  Arguments defined in <https://api.highcharts.com/highstock/scrollbar>.

## Examples

``` r
highchart(type = "stock") |> 
  hc_add_series(AirPassengers) |> 
  hc_rangeSelector(selected = 4) |> 
  hc_scrollbar(
    barBackgroundColor = "gray",
    barBorderRadius = 7,
    barBorderWidth = 0,
    buttonBackgroundColor = "gray",
    buttonBorderWidth = 0,
    buttonArrowColor = "yellow",
    buttonBorderRadius = 7,
    rifleColor = "yellow",
    trackBackgroundColor = "white",
    trackBorderWidth = 1,
    trackBorderColor = "silver",
    trackBorderRadius = 7
  )

{"x":{"hc_opts":{"chart":{"reflow":true},"title":{"text":null},"yAxis":{"title":{"text":null}},"credits":{"enabled":false},"exporting":{"enabled":false},"boost":{"enabled":false},"plotOptions":{"series":{"label":{"enabled":false},"turboThreshold":0},"treemap":{"layoutAlgorithm":"squarified"}},"series":[{"data":[[-662688000000,112],[-660009600000,118],[-657590400000,132],[-654912000000,129],[-652320000000,121],[-649641600000,135],[-647049600000,148],[-644371200000,148],[-641692800000,136],[-639100800000,119],[-636422400000,104],[-633830400000,118],[-631152000000,115],[-628473600000,126],[-626054400000,141],[-623376000000,135],[-620784000000,125],[-618105600000,149],[-615513600000,170],[-612835200000,170],[-610156800000,158],[-607564800000,133],[-604886400000,114],[-602294400000,140],[-599616000000,145],[-596937600000,150],[-594518400000,178],[-591840000000,163],[-589248000000,172],[-586569600000,178],[-583977600000,199],[-581299200000,199],[-578620800000,184],[-576028800000,162],[-573350400000,146],[-570758400000,166],[-568080000000,171],[-565401600000,180],[-562896000000,193],[-560217600000,181],[-557625600000,183],[-554947200000,218],[-552355200000,230],[-549676800000,242],[-546998400000,209],[-544406400000,191],[-541728000000,172],[-539136000000,194],[-536457600000,196],[-533779200000,196],[-531360000000,236],[-528681600000,235],[-526089600000,229],[-523411200000,243],[-520819200000,264],[-518140800000,272],[-515462400000,237],[-512870400000,211],[-510192000000,180],[-507600000000,201],[-504921600000,204],[-502243200000,188],[-499824000000,235],[-497145600000,227],[-494553600000,234],[-491875200000,264],[-489283200000,302],[-486604800000,293],[-483926400000,259],[-481334400000,229],[-478656000000,203],[-476064000000,229],[-473385600000,242],[-470707200000,233],[-468288000000,267],[-465609600000,269],[-463017600000,270],[-460339200000,315],[-457747200000,364],[-455068800000,347],[-452390400000,312],[-449798400000,274],[-447120000000,237],[-444528000000,278],[-441849600000,284],[-439171200000,277],[-436665600000,317],[-433987200000,313],[-431395200000,318],[-428716800000,374],[-426124800000,413],[-423446400000,405],[-420768000000,355],[-418176000000,306],[-415497600000,271],[-412905600000,306],[-410227200000,315],[-407548800000,301],[-405129600000,356],[-402451200000,348],[-399859200000,355],[-397180800000,422],[-394588800000,465],[-391910400000,467],[-389232000000,404],[-386640000000,347],[-383961600000,305],[-381369600000,336],[-378691200000,340],[-376012800000,318],[-373593600000,362],[-370915200000,348],[-368323200000,363],[-365644800000,435],[-363052800000,491],[-360374400000,505],[-357696000000,404],[-355104000000,359],[-352425600000,310],[-349833600000,337],[-347155200000,360],[-344476800000,342],[-342057600000,406],[-339379200000,396],[-336787200000,420],[-334108800000,472],[-331516800000,548],[-328838400000,559],[-326160000000,463],[-323568000000,407],[-320889600000,362],[-318297600000,405],[-315619200000,417],[-312940800000,391],[-310435200000,419],[-307756800000,461],[-305164800000,472],[-302486400000,535],[-299894400000,622],[-297216000000,606],[-294537600000,508],[-291945600000,461],[-289267200000,390],[-286675200000,432]]}],"rangeSelector":{"selected":4},"scrollbar":{"barBackgroundColor":"gray","barBorderRadius":7,"barBorderWidth":0,"buttonBackgroundColor":"gray","buttonBorderWidth":0,"buttonArrowColor":"yellow","buttonBorderRadius":7,"rifleColor":"yellow","trackBackgroundColor":"white","trackBorderWidth":1,"trackBorderColor":"silver","trackBorderRadius":7}},"theme":{"chart":{"backgroundColor":"transparent"},"colors":["#7cb5ec","#434348","#90ed7d","#f7a35c","#8085e9","#f15c80","#e4d354","#2b908f","#f45b5b","#91e8e1"]},"conf_opts":{"global":{"Date":null,"VMLRadialGradientURL":"http =//code.highcharts.com/list(version)/gfx/vml-radial-gradient.png","canvasToolsURL":"http =//code.highcharts.com/list(version)/modules/canvas-tools.js","getTimezoneOffset":null,"timezoneOffset":0,"useUTC":true},"lang":{"contextButtonTitle":"Chart context menu","decimalPoint":".","downloadCSV":"Download CSV","downloadJPEG":"Download JPEG image","downloadPDF":"Download PDF document","downloadPNG":"Download PNG image","downloadSVG":"Download SVG vector image","downloadXLS":"Download XLS","drillUpText":"◁ Back to {series.name}","exitFullscreen":"Exit from full screen","exportData":{"annotationHeader":"Annotations","categoryDatetimeHeader":"DateTime","categoryHeader":"Category"},"hideData":"Hide data table","invalidDate":null,"loading":"Loading...","months":["January","February","March","April","May","June","July","August","September","October","November","December"],"noData":"No data to display","numericSymbolMagnitude":1000,"numericSymbols":["k","M","G","T","P","E"],"printChart":"Print chart","resetZoom":"Reset zoom","resetZoomTitle":"Reset zoom level 1:1","shortMonths":["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"],"shortWeekdays":["Sat","Sun","Mon","Tue","Wed","Thu","Fri"],"thousandsSep":" ","viewData":"View data table","viewFullscreen":"View in full screen","weekdays":["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]}},"type":"stock","fonts":[],"debug":false},"evals":[],"jsHooks":[]}
```
