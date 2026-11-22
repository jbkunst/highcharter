# Helper for make table in tooltips

Helper to make table in tooltips for the `pointFormat` parameter in
`hc_tooltip`

## Usage

``` r
tooltip_table(x, y, title = NULL, img = NULL, ...)
```

## Arguments

- x:

  A string vector with description text

- y:

  A string with accessors example: `point.series.name`, `point.x`

- title:

  A title tag with accessors or string

- img:

  Image tag

- ...:

  html attributes for the table element

## Examples

``` r

hchart(mtcars, "scatter", hcaes(wt, mpg, name = rownames(mtcars))) |>
  hc_tooltip(
    useHTML = TRUE,
    pointFormat = tooltip_table(
      c("Model", "Weight (1,000 lb)", "Miles per gallon"),
      c("{point.name}", "{point.x:.2f}", "{point.y:.1f}")
    )
  )

{"x":{"hc_opts":{"chart":{"reflow":true},"title":{"text":null},"yAxis":{"title":{"text":"mpg"},"type":"linear"},"credits":{"enabled":false},"exporting":{"enabled":false},"boost":{"enabled":false},"plotOptions":{"series":{"label":{"enabled":false},"turboThreshold":0.0},"treemap":{"layoutAlgorithm":"squarified","levels":[{"level":1,"colorByPoint":true}]},"sunburst":{"levels":[{"level":1,"colorByPoint":true}]},"scatter":{"marker":{"symbol":"circle"}}},"series":[{"group":"group","data":[{"mpg":21.0,"cyl":6.0,"disp":160.0,"hp":110.0,"drat":3.9,"wt":2.62,"qsec":16.46,"vs":0.0,"am":1.0,"gear":4.0,"carb":4.0,"x":2.62,"y":21.0,"name":"Mazda RX4"},{"mpg":21.0,"cyl":6.0,"disp":160.0,"hp":110.0,"drat":3.9,"wt":2.875,"qsec":17.02,"vs":0.0,"am":1.0,"gear":4.0,"carb":4.0,"x":2.875,"y":21.0,"name":"Mazda RX4 Wag"},{"mpg":22.8,"cyl":4.0,"disp":108.0,"hp":93.0,"drat":3.85,"wt":2.32,"qsec":18.61,"vs":1.0,"am":1.0,"gear":4.0,"carb":1.0,"x":2.32,"y":22.8,"name":"Datsun 710"},{"mpg":21.4,"cyl":6.0,"disp":258.0,"hp":110.0,"drat":3.08,"wt":3.215,"qsec":19.44,"vs":1.0,"am":0.0,"gear":3.0,"carb":1.0,"x":3.215,"y":21.4,"name":"Hornet 4 Drive"},{"mpg":18.7,"cyl":8.0,"disp":360.0,"hp":175.0,"drat":3.15,"wt":3.44,"qsec":17.02,"vs":0.0,"am":0.0,"gear":3.0,"carb":2.0,"x":3.44,"y":18.7,"name":"Hornet Sportabout"},{"mpg":18.1,"cyl":6.0,"disp":225.0,"hp":105.0,"drat":2.76,"wt":3.46,"qsec":20.22,"vs":1.0,"am":0.0,"gear":3.0,"carb":1.0,"x":3.46,"y":18.1,"name":"Valiant"},{"mpg":14.3,"cyl":8.0,"disp":360.0,"hp":245.0,"drat":3.21,"wt":3.57,"qsec":15.84,"vs":0.0,"am":0.0,"gear":3.0,"carb":4.0,"x":3.57,"y":14.3,"name":"Duster 360"},{"mpg":24.4,"cyl":4.0,"disp":146.7,"hp":62.0,"drat":3.69,"wt":3.19,"qsec":20.0,"vs":1.0,"am":0.0,"gear":4.0,"carb":2.0,"x":3.19,"y":24.4,"name":"Merc 240D"},{"mpg":22.8,"cyl":4.0,"disp":140.8,"hp":95.0,"drat":3.92,"wt":3.15,"qsec":22.9,"vs":1.0,"am":0.0,"gear":4.0,"carb":2.0,"x":3.15,"y":22.8,"name":"Merc 230"},{"mpg":19.2,"cyl":6.0,"disp":167.6,"hp":123.0,"drat":3.92,"wt":3.44,"qsec":18.3,"vs":1.0,"am":0.0,"gear":4.0,"carb":4.0,"x":3.44,"y":19.2,"name":"Merc 280"},{"mpg":17.8,"cyl":6.0,"disp":167.6,"hp":123.0,"drat":3.92,"wt":3.44,"qsec":18.9,"vs":1.0,"am":0.0,"gear":4.0,"carb":4.0,"x":3.44,"y":17.8,"name":"Merc 280C"},{"mpg":16.4,"cyl":8.0,"disp":275.8,"hp":180.0,"drat":3.07,"wt":4.070000000000001,"qsec":17.4,"vs":0.0,"am":0.0,"gear":3.0,"carb":3.0,"x":4.070000000000001,"y":16.4,"name":"Merc 450SE"},{"mpg":17.3,"cyl":8.0,"disp":275.8,"hp":180.0,"drat":3.07,"wt":3.73,"qsec":17.6,"vs":0.0,"am":0.0,"gear":3.0,"carb":3.0,"x":3.73,"y":17.3,"name":"Merc 450SL"},{"mpg":15.2,"cyl":8.0,"disp":275.8,"hp":180.0,"drat":3.07,"wt":3.78,"qsec":18.0,"vs":0.0,"am":0.0,"gear":3.0,"carb":3.0,"x":3.78,"y":15.2,"name":"Merc 450SLC"},{"mpg":10.4,"cyl":8.0,"disp":472.0,"hp":205.0,"drat":2.93,"wt":5.25,"qsec":17.98,"vs":0.0,"am":0.0,"gear":3.0,"carb":4.0,"x":5.25,"y":10.4,"name":"Cadillac Fleetwood"},{"mpg":10.4,"cyl":8.0,"disp":460.0,"hp":215.0,"drat":3.0,"wt":5.424,"qsec":17.82,"vs":0.0,"am":0.0,"gear":3.0,"carb":4.0,"x":5.424,"y":10.4,"name":"Lincoln Continental"},{"mpg":14.7,"cyl":8.0,"disp":440.0,"hp":230.0,"drat":3.23,"wt":5.345,"qsec":17.42,"vs":0.0,"am":0.0,"gear":3.0,"carb":4.0,"x":5.345,"y":14.7,"name":"Chrysler Imperial"},{"mpg":32.4,"cyl":4.0,"disp":78.7,"hp":66.0,"drat":4.08,"wt":2.2,"qsec":19.47,"vs":1.0,"am":1.0,"gear":4.0,"carb":1.0,"x":2.2,"y":32.4,"name":"Fiat 128"},{"mpg":30.4,"cyl":4.0,"disp":75.7,"hp":52.0,"drat":4.93,"wt":1.615,"qsec":18.52,"vs":1.0,"am":1.0,"gear":4.0,"carb":2.0,"x":1.615,"y":30.4,"name":"Honda Civic"},{"mpg":33.9,"cyl":4.0,"disp":71.1,"hp":65.0,"drat":4.22,"wt":1.835,"qsec":19.9,"vs":1.0,"am":1.0,"gear":4.0,"carb":1.0,"x":1.835,"y":33.9,"name":"Toyota Corolla"},{"mpg":21.5,"cyl":4.0,"disp":120.1,"hp":97.0,"drat":3.7,"wt":2.465,"qsec":20.01,"vs":1.0,"am":0.0,"gear":3.0,"carb":1.0,"x":2.465,"y":21.5,"name":"Toyota Corona"},{"mpg":15.5,"cyl":8.0,"disp":318.0,"hp":150.0,"drat":2.76,"wt":3.52,"qsec":16.87,"vs":0.0,"am":0.0,"gear":3.0,"carb":2.0,"x":3.52,"y":15.5,"name":"Dodge Challenger"},{"mpg":15.2,"cyl":8.0,"disp":304.0,"hp":150.0,"drat":3.15,"wt":3.435,"qsec":17.3,"vs":0.0,"am":0.0,"gear":3.0,"carb":2.0,"x":3.435,"y":15.2,"name":"AMC Javelin"},{"mpg":13.3,"cyl":8.0,"disp":350.0,"hp":245.0,"drat":3.73,"wt":3.84,"qsec":15.41,"vs":0.0,"am":0.0,"gear":3.0,"carb":4.0,"x":3.84,"y":13.3,"name":"Camaro Z28"},{"mpg":19.2,"cyl":8.0,"disp":400.0,"hp":175.0,"drat":3.08,"wt":3.845,"qsec":17.05,"vs":0.0,"am":0.0,"gear":3.0,"carb":2.0,"x":3.845,"y":19.2,"name":"Pontiac Firebird"},{"mpg":27.3,"cyl":4.0,"disp":79.0,"hp":66.0,"drat":4.08,"wt":1.935,"qsec":18.9,"vs":1.0,"am":1.0,"gear":4.0,"carb":1.0,"x":1.935,"y":27.3,"name":"Fiat X1-9"},{"mpg":26.0,"cyl":4.0,"disp":120.3,"hp":91.0,"drat":4.43,"wt":2.14,"qsec":16.7,"vs":0.0,"am":1.0,"gear":5.0,"carb":2.0,"x":2.14,"y":26.0,"name":"Porsche 914-2"},{"mpg":30.4,"cyl":4.0,"disp":95.1,"hp":113.0,"drat":3.77,"wt":1.513,"qsec":16.9,"vs":1.0,"am":1.0,"gear":5.0,"carb":2.0,"x":1.513,"y":30.4,"name":"Lotus Europa"},{"mpg":15.8,"cyl":8.0,"disp":351.0,"hp":264.0,"drat":4.22,"wt":3.17,"qsec":14.5,"vs":0.0,"am":1.0,"gear":5.0,"carb":4.0,"x":3.17,"y":15.8,"name":"Ford Pantera L"},{"mpg":19.7,"cyl":6.0,"disp":145.0,"hp":175.0,"drat":3.62,"wt":2.77,"qsec":15.5,"vs":0.0,"am":1.0,"gear":5.0,"carb":6.0,"x":2.77,"y":19.7,"name":"Ferrari Dino"},{"mpg":15.0,"cyl":8.0,"disp":301.0,"hp":335.0,"drat":3.54,"wt":3.57,"qsec":14.6,"vs":0.0,"am":1.0,"gear":5.0,"carb":8.0,"x":3.57,"y":15.0,"name":"Maserati Bora"},{"mpg":21.4,"cyl":4.0,"disp":121.0,"hp":109.0,"drat":4.110000000000001,"wt":2.78,"qsec":18.6,"vs":1.0,"am":1.0,"gear":4.0,"carb":2.0,"x":2.78,"y":21.4,"name":"Volvo 142E"}],"type":"scatter"}],"xAxis":{"type":"linear","title":{"text":"wt"}},"tooltip":{"useHTML":true,"pointFormat":"<table>\n  <tr>\n    <th>Model\u003c/th>\n    <td>{point.name}\u003c/td>\n  \u003c/tr>\n  <tr>\n    <th>Weight (1,000 lb)\u003c/th>\n    <td>{point.x:.2f}\u003c/td>\n  \u003c/tr>\n  <tr>\n    <th>Miles per gallon\u003c/th>\n    <td>{point.y:.1f}\u003c/td>\n  \u003c/tr>\n\u003c/table>"}},"theme":{"symbols":["circle","circle","circle","circle","circle"],"colors":["#47475c","#61BC7B","#508CC8","#F49952","#9C9EDB","#6699a1"],"chart":{"style":{"fontFamily":"IBM Plex Sans","color":"#666666"}},"title":{"align":"left","style":{"fontFamily":"Alegreya Sans SC","fontSize":"24px","fontWeight":"normal"}},"subtitle":{"align":"left","style":{"fontFamily":"IBM Plex Sans","fontSize":"16px"}},"caption":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"14px"}},"credits":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"10px"}},"legend":{"align":"right","verticalAlign":"bottom","itemStyle":{"fontWeight":"normal","color":"#666666"}},"xAxis":{"gridLineWidth":1,"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"yAxis":{"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"plotOptions":{"series":{"dataLabels":{"style":{"fontWeight":"normal"}}},"line":{"marker":{"enabled":false}},"spline":{"marker":{"enabled":false}},"area":{"marker":{"enabled":false}},"areaspline":{"marker":{"enabled":false}},"arearange":{"marker":{"enabled":false}},"bubble":{"maxSize":"10%"}},"tooltip":{"className":"highcharter-regular-tooltip","valueDecimals":2.0}},"conf_opts":{"lang":{"locale":"en"}},"type":"chart"},"evals":[],"jsHooks":[]}
```
