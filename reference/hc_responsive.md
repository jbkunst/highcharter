# Responsive options for highcharter objects

Allows setting a set of rules to apply for different screen or chart
sizes. Each rule specifies additional chart options.

## Usage

``` r
hc_responsive(hc, ...)
```

## Arguments

- hc:

  A `highchart` `htmlwidget` object.

- ...:

  Arguments defined in
  <https://api.highcharts.com/highcharts/responsive>.

## Examples

``` r
leg_500_opts <- list(enabled = FALSE)
leg_900_opts <- list(align = "right", verticalAlign = "middle",  layout = "vertical")


# change the with of the container/windows to see the effect
highchart() |> 
  hc_add_series(data = cumsum(rnorm(100))) |> 
  hc_responsive(
    rules = list(
      # remove legend if there is no much space
      list(
        condition = list(maxWidth  = 500),
        chartOptions = list(legend = leg_500_opts)
      ),
      # put legend on the right when there is much space
      list(
        condition = list(minWidth  = 900),
        chartOptions = list(legend = leg_900_opts)
      )
    )
  )

{"x":{"hc_opts":{"chart":{"reflow":true},"title":{"text":null},"yAxis":{"title":{"text":null}},"credits":{"enabled":false},"exporting":{"enabled":false},"boost":{"enabled":false},"plotOptions":{"series":{"label":{"enabled":false},"turboThreshold":0},"treemap":{"layoutAlgorithm":"squarified"}},"series":[{"data":[-1.388668826900913,-0.9514546213572332,-0.6355925347756081,-0.4409820000269732,-0.8967441270842464,-0.08420913830750371,0.1908334549745918,0.1968428663240452,2.207029277992909,2.520838100678521,1.674675388512553,1.540034343107114,3.010866543085317,1.535740807316732,1.740240490774329,1.398472069916208,3.240629717979879,3.034720182902398,4.536951460620294,4.779139520807766,4.832595240503964,4.707448930980205,4.955236168653934,4.32862359057842,5.011501124800195,5.601107180974,4.786139860581988,4.440340873638969,4.496869920933698,3.930103739866838,3.887266283287194,2.605706986656701,3.573289228864445,4.602338082283702,2.435912827829942,2.132564604994439,2.31183264440185,3.739228464291622,3.119281869061926,2.987439419073537,3.254991168302256,1.798212650325839,2.032553170561162,1.081025116118866,2.979464517388657,1.936693971817843,0.6029476862633458,2.367672496054682,2.873735926530832,2.218443709715745,2.885952548761135,4.258828695089109,4.853410673955014,5.662718111018573,4.733366394776696,3.764483821786266,3.201000773284332,5.089489480521864,4.972719873609125,4.922941434551825,5.335472329831703,5.67447854631963,5.455014609075588,5.175092632207983,4.990626010014589,3.859584820433465,4.458652963423773,4.1136285038271,4.442312131617778,4.440310338184823,2.796669867699098,3.626814447254731,4.938115229288735,4.212406252701964,3.824061187653286,2.78165283337853,3.521618370721743,3.142390381567007,3.997430787472607,4.927157598793472,4.415737292428893,4.991344019104691,3.811583281234338,4.685506007689912,5.43816096976003,6.070113915870253,6.559165586481682,7.052631758507215,5.027963019580961,4.912616386590773,5.315577586007777,3.986024371094988,4.836056646445464,5.941738568977219,6.345880474812493,6.222738963653992,6.67158668388778,8.739740432109011,7.490203590024104,7.270672414826568]}],"responsive":{"rules":[{"condition":{"maxWidth":500},"chartOptions":{"legend":{"enabled":false}}},{"condition":{"minWidth":900},"chartOptions":{"legend":{"align":"right","verticalAlign":"middle","layout":"vertical"}}}]}},"theme":{"chart":{"backgroundColor":"transparent"},"colors":["#7cb5ec","#434348","#90ed7d","#f7a35c","#8085e9","#f15c80","#e4d354","#2b908f","#f45b5b","#91e8e1"]},"conf_opts":{"global":{"Date":null,"VMLRadialGradientURL":"http =//code.highcharts.com/list(version)/gfx/vml-radial-gradient.png","canvasToolsURL":"http =//code.highcharts.com/list(version)/modules/canvas-tools.js","getTimezoneOffset":null,"timezoneOffset":0,"useUTC":true},"lang":{"contextButtonTitle":"Chart context menu","decimalPoint":".","downloadCSV":"Download CSV","downloadJPEG":"Download JPEG image","downloadPDF":"Download PDF document","downloadPNG":"Download PNG image","downloadSVG":"Download SVG vector image","downloadXLS":"Download XLS","drillUpText":"◁ Back to {series.name}","exitFullscreen":"Exit from full screen","exportData":{"annotationHeader":"Annotations","categoryDatetimeHeader":"DateTime","categoryHeader":"Category"},"hideData":"Hide data table","invalidDate":null,"loading":"Loading...","months":["January","February","March","April","May","June","July","August","September","October","November","December"],"noData":"No data to display","numericSymbolMagnitude":1000,"numericSymbols":["k","M","G","T","P","E"],"printChart":"Print chart","resetZoom":"Reset zoom","resetZoomTitle":"Reset zoom level 1:1","shortMonths":["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"],"shortWeekdays":["Sat","Sun","Mon","Tue","Wed","Thu","Fri"],"thousandsSep":" ","viewData":"View data table","viewFullscreen":"View in full screen","weekdays":["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]}},"type":"chart","fonts":[],"debug":false},"evals":[],"jsHooks":[]}
```
