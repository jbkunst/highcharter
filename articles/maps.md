# Maps

## Draw a map and join selected regions

Pass a two-letter country code to
[`hcmap()`](https://jkunst.com/highcharter/reference/hcmap.md) to draw
its installed boundaries. Use
[`hc_maps()`](https://jkunst.com/highcharter/reference/hc_maps.md) to
list the available countries and regional maps.

``` r

hcmap("jp", nullColor = "rgba(106,120,124,0.16)", showInLegend = FALSE) |>
  hc_title(text = "Prefectures of Japan")
```

Keep the full map and supply a table for just the prefectures you want
to highlight. Here `joinBy` matches the map’s `name` property to the
table’s `prefecture` column. Hover over a highlighted prefecture to see
its mountain road.

``` r

# fmt: skip
roads <- tibble::tribble(
  ~prefecture, ~road,
  "Gunma",     "Mount Haruna",
  "Tochigi",   "Irohazaka",
  "Saitama",   "Shomaru Pass",
  "Ibaraki",   "Tsukuba Fruits Line",
  "Kanagawa",  "Hakone Turnpike"
) |> mutate(selected = 1)

hcmap(
  "jp",
  data = roads,
  value = "selected",
  joinBy = c("name", "prefecture"),
  nullColor = "rgba(106,120,124,0.16)",
  borderColor = "#879392",
  borderWidth = 0.5
) |>
  hc_colorAxis(
    visible = FALSE,
    dataClasses = list(list(from = 1, to = 1, color = "rgba(177,85,45,0.65)"))
  ) |>
  hc_title(text = "Mountain roads in Japan") |>
  hc_mapNavigation(enabled = TRUE, enableMouseWheelZoom = FALSE) |>
  hc_tooltip(
    headerFormat = "",
    pointFormat = "<b>{point.name}</b><br>{point.road}"
  )
```

To discover the join keys on another map, inspect its properties with
[`get_data_from_map()`](https://jkunst.com/highcharter/reference/get_data_from_map.md).
Collection paths such as `"countries/jp/jp-all"` also work. Use
[`download_map_data()`](https://jkunst.com/highcharter/reference/download_map_data.md)
to save other [collection
boundaries](https://code.highcharts.com/mapdata/) for offline use.

## Drill through geographic levels

Click **South America**, then any of its 12 countries to explore its
administrative divisions. For example, Chile opens its 16 regions. Use
the breadcrumbs to return one level or jump back to the continents.

Each clickable point has a `drilldown` ID matching a child series. All
three levels use geographic coordinates and the same projection. With
`mapZooming = TRUE`, the view zooms toward the selection as the series
changes. The geometry is bundled with this article, so a click works
offline.

``` r

atlas <- jsonlite::read_json("data/drilldown-south-america.json.gz")
atlas$cl <- readRDS(system.file("maps/cl.rds", package = "highcharter"))
codes <- setdiff(names(atlas), c("continents", "south_america"))
countries <- data.frame(code = codes, value = 1, drilldown = codes)

divisions <- lapply(codes, function(code) {
  list(
    id = code,
    name = atlas[[code]]$title,
    type = "map",
    mapData = atlas[[code]],
    colorAxis = FALSE,
    nullColor = "rgba(57,131,113,0.35)",
    nullInteraction = TRUE
  )
})
```

``` r

continents <- data.frame(code = "sa", value = 1, drilldown = "countries")
south_america <- list(
  id = "countries",
  name = "South America",
  type = "map",
  mapData = atlas$south_america,
  data = list_parse(countries),
  joinBy = c("hc-key", "code")
)

hcmap(
  atlas$continents,
  data = continents,
  value = "value",
  joinBy = c("hc-key", "code"),
  name = "Continents"
) |>
  hc_mapView(projection = list(name = "EqualEarth")) |>
  hc_plotOptions(map = list(nullColor = "rgba(106,120,124,0.16)")) |>
  hc_colorAxis(
    visible = FALSE,
    dataClasses = list(list(from = 1, to = 1, color = "rgba(24,124,101,0.62)"))
  ) |>
  hc_drilldown(
    mapZooming = TRUE,
    animation = list(duration = 650),
    series = c(list(south_america), divisions)
  ) |>
  hc_title(text = "Explore administrative divisions") |>
  hc_tooltip(
    headerFormat = "",
    pointFormat = "{point.name}",
    nullFormat = "{point.name}"
  )
```

## Map a continuous value on a globe

An orthographic projection shows one hemisphere at a time. Drag the
globe to rotate it. Join the 2024 World Bank income data to the country
codes in the geographic world map. The fill uses a logarithmic scale in
current US dollars per person. Gray indicates missing data. The
graticule marks parallels and meridians. The ocean circle uses the
radius of the orthographic projection and shares the graticule’s
transform during rotation and zoom.

``` r

hcmap(
  "custom/world.topo.json",
  data = subset(world_income, year == 2024),
  value = "gni_per_capita",
  joinBy = c("iso-a3", "iso3"),
  name = "GNI per capita",
  nullColor = "rgba(106,120,124,0.22)",
  borderWidth = 0.3,
  zIndex = 1
) |>
  hc_add_series(
    id = "graticule",
    data = geojsonio::geojson_list(sf::st_graticule()),
    type = "mapline",
    color = "rgba(86,121,130,0.35)",
    colorAxis = FALSE,
    lineWidth = 0.6,
    enableMouseTracking = FALSE,
    showInLegend = FALSE
  ) |>
  hc_chart(
    events = list(
      render = JS(
        "function () {
    const group = this.get('graticule').transformGroups[0];
    if (!group.ocean) {
      const radius = this.mapView.projection.def.bounds.x2;
      group.ocean = this.renderer.circle(0, 0, radius)
        .attr({ fill: '#e4f3fa', zIndex: -1, 'pointer-events': 'none' }).add(group);
    }
  }"
      )
    )
  ) |>
  hc_mapView(projection = list(name = "Orthographic", rotation = c(60, 15))) |>
  hc_colorAxis(
    type = "logarithmic",
    stops = color_stops(colors = c("#3B245F", "#AF4664", "#F29145", "#FFEA99"))
  ) |>
  hc_title(text = "Gross national income per capita, 2024") |>
  hc_mapNavigation(enabled = TRUE, enableMouseWheelZoom = FALSE) |>
  hc_tooltip(valuePrefix = "$", valueDecimals = 0)
```

## Color regions by category

Use `dataClasses` to give discrete groups their own colors and legend
entries. These European countries are grouped by standard time. Summer
time is excluded.

``` r

zones <- data.frame(
  # fmt: skip
  country = c("PT", "IE", "GB", "IS", "FR", "DE", "ES", "IT", "NO", "SE",
              "PL", "AT", "CH", "FI", "EE", "LV", "LT", "GR", "RO", "BG"),
  value = c(rep(0, 4), rep(1, 9), rep(2, 7))
)
hcmap(
  "custom/europe",
  data = zones,
  value = "value",
  joinBy = c("iso-a2", "country"),
  name = "Standard time",
  nullColor = "rgba(106,120,124,0.16)"
) |>
  hc_colorAxis(
    dataClasses = list(
      list(from = 0, to = 0, name = "UTC", color = "rgba(110,79,140,0.72)"),
      list(from = 1, to = 1, name = "UTC + 1", color = "rgba(46,135,116,0.72)"),
      list(from = 2, to = 2, name = "UTC + 2", color = "rgba(192,115,43,0.72)")
    )
  ) |>
  hc_title(text = "Standard time in Europe")
```

## Overlay point locations and a vector field

`mappoint` places airports by longitude and latitude. For a geographic
vector field, `flowmap` draws an arrow between two coordinate pairs.
This example places a simulated tornado over the lower Paraná, near the
Río de la Plata. The footprint is enlarged so the rotation is visible at
a regional scale. Arrow length shows relative speed. The airports are
geographic reference points.

``` r

# fmt: skip
airports <- tibble::tribble(
  ~name,                     ~code, ~lon,   ~lat,
  "Rosario",                 "ROS", -60.79, -32.90,
  "Buenos Aires Aeroparque", "AEP", -58.42, -34.56,
  "Buenos Aires Ezeiza",     "EZE", -58.54, -34.82,
  "Montevideo Carrasco",     "MVD", -56.03, -34.84
)

wind <- data.frame(
  radius = rep(c(0.32, 0.65, 0.98), c(6, 12, 18)),
  angle = 2 * pi * c((0:5) / 6, (0:11) / 12, (0:17) / 18)
)
wind <- wind |>
  mutate(
    east = cos(angle),
    north = sin(angle),
    lon = -59.65 + radius * east / cos(-33.85 * pi / 180),
    lat = -33.85 + radius * north,
    speed = 1 - 0.6 * radius
  )

arrows <- with(
  wind,
  Map(
    function(lon, lat, east, north, speed) {
      list(
        from = c(lon, lat),
        to = c(
          lon + 0.36 * speed * (north - 0.25 * east) / cos(lat * pi / 180),
          lat - 0.36 * speed * (east + 0.25 * north)
        )
      )
    },
    lon,
    lat,
    east,
    north,
    speed
  )
)
```

``` r

hcmap(
  atlas$ar,
  nullColor = "rgba(106,120,124,0.12)",
  borderColor = "#ACB8B5",
  showInLegend = FALSE
) |>
  hc_add_series(
    type = "map",
    mapData = atlas$uy,
    nullColor = "rgba(106,120,124,0.12)",
    borderColor = "#ACB8B5",
    showInLegend = FALSE
  ) |>
  hc_mapView(
    projection = list(name = "WebMercator"),
    fitToGeometry = list(
      type = "MultiPoint",
      coordinates = list(c(-61.45, -35.25), c(-55.55, -32.55))
    )
  ) |>
  hc_add_series(
    data = arrows,
    type = "flowmap",
    name = "Simulated wind",
    color = "#237469",
    fillOpacity = 0.9,
    width = 1.6,
    markerEnd = list(width = 3, height = 6),
    curveFactor = 0,
    enableMouseTracking = FALSE
  ) |>
  hc_add_series(
    data = airports,
    type = "mappoint",
    name = "Airports",
    hcaes(lon = lon, lat = lat, name = name),
    color = "#934426",
    marker = list(symbol = "circle", radius = 3),
    dataLabels = list(enabled = TRUE, format = "{point.code}")
  ) |>
  hc_title(text = "A simulated wind field over the lower Paraná") |>
  hc_tooltip(headerFormat = "", pointFormat = "{point.name} ({point.code})") |>
  hc_mapNavigation(enabled = TRUE, enableMouseWheelZoom = FALSE)
```

## Overlay geometry on web tiles

Put a `tiledwebmap` series first, then add the Laguna Seca circuit. The
satellite imagery loads online as you pan or zoom. The track surface,
pit lane and corner apexes come from one local GeoJSON file. The
translucent surface lets you see the pavement under the overlay.

``` r

path <- system.file("extdata", "laguna-seca.geojson", package = "highcharter")
circuit <- geojsonio::geojson_list(geojsonio::as.json(path))

highchart(type = "map") |>
  hc_add_series(
    type = "tiledwebmap",
    provider = list(type = "Esri", theme = "WorldImagery"),
    showInLegend = FALSE
  ) |>
  hc_add_series(
    data = circuit,
    name = c("Track surface", "Pit lane", "Apexes")
  ) |>
  hc_mapView(projection = list(name = "WebMercator"), padding = "6%") |>
  hc_plotOptions(
    map = list(color = "rgba(92,213,211,0.32)", borderColor = "#87DED7"),
    mapline = list(color = "#FFD166", lineWidth = 3),
    mappoint = list(
      color = "#FF905E",
      marker = list(symbol = "circle", radius = 4)
    ),
    series = list(dataLabels = list(enabled = FALSE))
  ) |>
  hc_title(text = "Laguna Seca") |>
  hc_mapNavigation(enabled = TRUE, enableMouseWheelZoom = FALSE) |>
  hc_tooltip(headerFormat = "", pointFormat = "<b>{point.name}</b>") |>
  hc_legend(enabled = TRUE) |>
  hc_credits(enabled = TRUE) |>
  hc_caption(
    text = "Circuit: Track Atlas · <a href='https://www.openstreetmap.org/copyright'>© OpenStreetMap contributors (ODbL)</a>"
  )
```

Toggle **Track surface** to compare the outline with the imagery. [Track
Atlas circuit
data](https://github.com/tobi/track-atlas/blob/8c12ac414ea74ffe4a3ef74b294a2eafab7ee60d/tracks/laguna-seca/raw/layers/gp.surface.geojson).

## Bring your own GeoJSON or TopoJSON

### Join a table to a TopoJSON file

Read your boundary file with
[`jsonlite::read_json()`](https://rdrr.io/pkg/jsonlite/man/read_json.html)
to preserve nested coordinates. Inspect its properties to choose a join
key. Here the boundary file stores district codes as text, including the
leading zeros.

``` r

path <- system.file("extdata", "districts.topo.json", package = "highcharter")
districts <- jsonlite::read_json(path)
get_data_from_map(districts) |> select(name, code)
```

    ## # A tibble: 2 × 2
    ##   name  code 
    ##   <chr> <chr>
    ## 1 West  01   
    ## 2 East  02

``` r

visits <- data.frame(district_id = c("01", "02"), visits = c(18, 42))
hcmap(
  districts,
  data = visits,
  value = "visits",
  joinBy = c("code", "district_id")
) |>
  hc_colorAxis(
    minColor = "rgba(44,130,113,0.20)",
    maxColor = "rgba(44,130,113,0.85)"
  ) |>
  hc_title(text = "Visits by district") |>
  hc_tooltip(pointFormat = "{point.name}: {point.value} visits")
```

### Layer mixed GeoJSON over a basemap

Manchester Airport is a single GeoJSON FeatureCollection. Its 26
polygons outline terminals and aprons, 254 lines trace runways and
taxiways, and 136 points mark gates and other airfield features. Pass
the collection to
[`hchart()`](https://jkunst.com/highcharter/reference/hchart.md) to draw
the three layers. Hover over a gate to see its reference, such as **Gate
21**.

``` r

path <- system.file(
  "extdata",
  "manchester-airport.geojson",
  package = "highcharter"
)
airport <- geojsonio::geojson_list(geojsonio::as.json(path))
```

``` r

hchart(airport, name = c("Areas", "Lines", "Points")) |>
  hc_tooltip(headerFormat = "", pointFormat = "<b>{point.name}</b>") |>
  hc_mapNavigation(enabled = TRUE, enableMouseWheelZoom = FALSE)
```

The map shows the three geometry layers over a local MapLibre basemap.
Toggle a layer in the legend or use the zoom buttons to explore. The
GeoJSON preserves named features and labels the others with their
airfield category and reference where available. [Airport data from
POSCON
UK](https://github.com/POSCON-United-Kingdom/UK-Radar-Data/blob/6a020b03fbfeffe9f7eb53e4b4559de48134e351/AirfieldGeoJson/EGCC.geojson)
· [Basemap example
code](https://github.com/jbkunst/highcharter/blob/main/vignettes/_manchester.Rmd).
