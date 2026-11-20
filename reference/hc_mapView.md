# mapView options for highcharter objects

The `mapView` options control the initial view of the chart, and how
projection is set up for raw geoJSON maps (beta as of v9.3).

## Usage

``` r
hc_mapView(hc, ...)
```

## Arguments

- hc:

  A `highchart` `htmlwidget` object.

- ...:

  Options defined in <https://api.highcharts.com/highmaps/mapView>.

## Details

To set the view dynamically after chart generation, see mapView.setView.

## Examples

``` r
highchart(type = "map") |>
  hc_add_series(
    type = "mappoint",
    name = "Cities",
    data = list(
      list(name = "Santiago", lon = -70.67, lat = -33.45),
      list(name = "Valparaíso", lon = -71.62, lat = -33.05)
    )
  ) |>
  hc_mapView(
    projection = list(name = "WebMercator"),
    center = c(-71.1, -33.3),
    zoom = 7
  )

{"x":{"hc_opts":{"chart":{"reflow":true},"title":{"text":null},"yAxis":{"title":{"text":null}},"credits":{"enabled":false},"exporting":{"enabled":false},"boost":{"enabled":false},"plotOptions":{"series":{"label":{"enabled":false},"turboThreshold":0.0},"treemap":{"layoutAlgorithm":"squarified","levels":[{"level":1,"colorByPoint":true}]},"sunburst":{"levels":[{"level":1,"colorByPoint":true}]}},"series":[{"data":[{"name":"Santiago","lon":-70.67,"lat":-33.45000000000001},{"name":"Valparaíso","lon":-71.62,"lat":-33.05}],"type":"mappoint","name":"Cities"}],"mapView":{"projection":{"name":"WebMercator"},"center":[-71.1,-33.3],"zoom":7.0}},"theme":{"symbols":["circle","circle","circle","circle","circle"],"colors":["#47475c","#61BC7B","#508CC8","#F49952","#9C9EDB","#6699a1"],"chart":{"style":{"fontFamily":"IBM Plex Sans","color":"#666666"}},"title":{"align":"left","style":{"fontFamily":"Alegreya Sans SC","fontSize":"24px","fontWeight":"normal"}},"subtitle":{"align":"left","style":{"fontFamily":"IBM Plex Sans","fontSize":"16px"}},"caption":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"14px"}},"credits":{"style":{"fontFamily":"IBM Plex Sans","fontSize":"10px"}},"legend":{"align":"right","verticalAlign":"bottom","itemStyle":{"fontWeight":"normal","color":"#666666"}},"xAxis":{"gridLineWidth":1,"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"yAxis":{"gridLineColor":"#F3F3F3","lineColor":"#F3F3F3","minorGridLineColor":"#F3F3F3","tickColor":"#F3F3F3","tickWidth":1},"plotOptions":{"series":{"dataLabels":{"style":{"fontWeight":"normal"}}},"line":{"marker":{"enabled":false}},"spline":{"marker":{"enabled":false}},"area":{"marker":{"enabled":false}},"areaspline":{"marker":{"enabled":false}},"arearange":{"marker":{"enabled":false}},"bubble":{"maxSize":"10%"}},"tooltip":{"className":"highcharter-regular-tooltip","valueDecimals":2.0}},"conf_opts":{"lang":{"locale":"en"}},"type":"map"},"evals":[],"jsHooks":[]}
```
