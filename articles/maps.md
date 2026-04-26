# Maps with highmaps

The highcharter package include
[highmaps](https://www.highcharts.com/demo/maps) libraries from
highchartsJS to chart maps, choropleths and geojson.

## Basics

The easiest way to chart a map with highcharter is using
[`hcmap()`](https://jkunst.com/highcharter/reference/hcmap.md) function.
Select a map (a url) from the highmaps collection
<https://code.highcharts.com/mapdata/>. and use the url as a map in
[`hcmap()`](https://jkunst.com/highcharter/reference/hcmap.md) function.
This will download the map and create a `highchart` object using the
info as a `mapData` argument.

Let’s try some maps:

``` r
library(highcharter)

hcmap("countries/nz/nz-all")
```

``` r
hcmap("custom/usa-and-canada", showInLegend = FALSE)
```

``` r
hcmap("countries/us/us-ca-all") |>
  hc_title(text = "California") |> 
  hc_subtitle(text = "You can use the same functions to modify your map!")
```

**Note**: *The copyright information is added to the chart credits by
default, but please be aware that you will have to display this
information somewhere else if you choose to disable chart credits.
Copyright information for each map can be found as properties in the
GeoJSON and Javascript files*.

## Choropleths

What about add data to get a choropleth? Every map downloaded from the
highchartsJS maps collection have keys to join data. There are 2
functions to help to know what are the regions coded to know how to join
the map and data:

- [`download_map_data()`](https://jkunst.com/highcharter/reference/download_map_data.md):
  Download the geojson data from the highchartsJS collection.
- [`get_data_from_map()`](https://jkunst.com/highcharter/reference/get_data_from_map.md):
  Get the properties for each region in the map, as the keys from the
  map data.

``` r
require(dplyr)

mapdata <- get_data_from_map(download_map_data("custom/usa-and-canada"))

glimpse(mapdata)
```

    ## Rows: 64
    ## Columns: 21
    ## $ `hc-group`    <chr> "admin1", "admin1", "admin1", "admin1", "admin1", "admin…
    ## $ `hc-middle-x` <dbl> 0.40, 0.50, 0.52, 0.59, 0.48, 0.50, 0.47, 0.48, 0.51, 0.…
    ## $ `hc-middle-y` <dbl> 0.53, 0.51, 0.50, 0.50, 0.55, 0.49, 0.35, 0.50, 0.54, 0.…
    ## $ `hc-key`      <chr> "us-ca", "us-or", "us-nd", "ca-sk", "us-mt", "us-az", "u…
    ## $ `hc-a2`       <chr> "CA", "OR", "ND", "SK", "MT", "AZ", "NV", "AL", "NM", "C…
    ## $ labelrank     <chr> "0", "0", "0", "2", "0", "0", "0", "0", "0", "0", "0", "…
    ## $ hasc          <chr> "US.CA", "US.OR", "US.ND", "CA.SK", "US.MT", "US.AZ", "U…
    ## $ `alt-name`    <chr> "CA|Calif.", "OR|Ore.", "ND|N.D.", NA, "MT|Mont.", "AZ|A…
    ## $ `woe-id`      <chr> "2347563", "2347596", "2347593", "2344925", "2347585", "…
    ## $ subregion     <chr> "Pacific", "Pacific", "West North Central", "Prairies", …
    ## $ fips          <chr> "US06", "US41", "US38", "CA11", "US30", "US04", "US32", …
    ## $ `postal-code` <chr> "CA", "OR", "ND", "SK", "MT", "AZ", "NV", "AL", "NM", "C…
    ## $ name          <chr> "California", "Oregon", "North Dakota", "Saskatchewan", …
    ## $ country       <chr> "United States of America", "United States of America", …
    ## $ `type-en`     <chr> "State", "State", "State", "Province", "State", "State",…
    ## $ region        <chr> "West", "West", "Midwest", "Western Canada", "West", "We…
    ## $ longitude     <chr> "-119.591", "-120.386", "-100.302", "-105.682", "-110.04…
    ## $ `woe-name`    <chr> "California", "Oregon", "North Dakota", "Saskatchewan", …
    ## $ latitude      <chr> "36.7496", "43.8333", "47.4675", "54.4965", "46.9965", "…
    ## $ `woe-label`   <chr> "California, US, United States", "Oregon, US, United Sta…
    ## $ type          <chr> "State", "State", "State", "Province", "State", "State",…

``` r
data_fake <- mapdata |>
  select(code = `hc-a2`) |>
  mutate(value = 1e5 * abs(rt(nrow(mapdata), df = 10)))

glimpse(data_fake)
```

    ## Rows: 64
    ## Columns: 2
    ## $ code  <chr> "CA", "OR", "ND", "SK", "MT", "AZ", "NV", "AL", "NM", "CO", "WY"…
    ## $ value <dbl> 134224.53215, 512.22371, 212153.17183, 141045.54780, 50829.44759…

If we compare this 2 data frames the `hc-key` is same code that `code`.
So we’ll use these columns as keys:

``` r
hcmap(
  "custom/usa-and-canada",
  data = data_fake,
  value = "value",
  joinBy = c("hc-a2", "code"),
  name = "Fake data",
  dataLabels = list(enabled = TRUE, format = "{point.name}"),
  borderColor = "#FAFAFA",
  borderWidth = 0.1,
  tooltip = list(
    valueDecimals = 2,
    valuePrefix = "$",
    valueSuffix = "USD"
  )
)
```

## Categorized areas

``` r
data <- tibble(
  country = 
    c("PT", "IE", "GB", "IS",
      
      "NO", "SE", "DK", "DE", "NL", "BE", "LU", "ES", "FR", "PL", "CZ", "AT",
      "CH", "LI", "SK", "HU", "SI", "IT", "SM", "HR", "BA", "YF", "ME", "AL", "MK",
      
      "FI", "EE", "LV", "LT", "BY", "UA", "MD", "RO", "BG", "GR", "TR", "CY",
      
      "RU"),  
  tz = c(rep("UTC", 4), rep("UTC + 1",25), rep("UCT + 2",12), "UTC + 3")
  )

# auxiliar variable
data <- data |> 
  mutate(value = cumsum(!duplicated(tz)))


# now we'll create the dataClasses
dta_clss <- data |> 
  mutate(value = cumsum(!duplicated(tz))) |> 
  group_by(tz) |> 
  summarise(value = unique(value)) |> 
  arrange(value) |> 
  rename(name = tz, from = value) |> 
  mutate(to = from + 1) |> 
  list_parse()

hcmap(
  map = "custom/europe",
  data = data, 
  joinBy = c("iso-a2","country"),
  name = "Time zone",
  value = "value",
  tooltip = list(pointFormat = "{point.name} {point.tz}"),
  dataLabels = list(enabled = TRUE, format = "{point.country}")
  ) |>
  hc_colorAxis(
    dataClassColor = "category",
    dataClasses = dta_clss
    ) |> 
  hc_title(text = "Europe Time Zones")
```

Example from <https://www.highcharts.com/demo/maps/category-map>.

## Adding Points

With highcharter is possible add data as points or bubbles. For this it
is necessary a data frame with `lat`, `lon` columns, and `name`, `z` are
optional:

``` r
cities <- data.frame(
  name = c("London", "Birmingham", "Glasgow", "Liverpool"),
  lat = c(51.507222, 52.483056, 55.858, 53.4),
  lon = c(-0.1275, -1.893611, -4.259, -3),
  z = c(1, 2, 3, 2)
)

hcmap("countries/gb/gb-all", showInLegend = FALSE) |>
  hc_add_series(
    data = cities, 
    type = "mappoint",
    name = "Cities", 
    minSize = "1%",
    maxSize = "5%"
    ) |>
  hc_mapNavigation(enabled = TRUE)
```

``` r
hcmap("countries/gb/gb-all", showInLegend = FALSE) |>
  hc_add_series(
    data = cities, 
    type = "mapbubble",
    name = "Cities", 
    minSize = "1%",
    maxSize = "5%"
    ) |>
  hc_mapNavigation(enabled = TRUE)
```

Another example:

``` r
library(dplyr)

airports <- read.csv(
  # "https://raw.githubusercontent.com/ajdapretnar/datasets/master/data/global_airports.csv",
  "https://datacatalogfiles.worldbank.org/ddh-published/0038117/2/DR0046411/airport_volume_airport_locations.csv",
  stringsAsFactors = FALSE
  )

south_america_countries <- c(
    "Brazil", "Ecuador", "Venezuela",
    "Chile", "Argentina", "Peru",
    "Uruguay", "Paraguay", "Bolivia", 
    "Suriname", "Guyana", "Colombia"
  ) 

airports <- airports |>
  filter(Country.Name %in% south_america_countries) |>
  rename(lat = Airport1Latitude, lon = Airport1Longitude) |>
  filter(lon < -30)

hcmap(
  "custom/south-america",
  name = "South America",
  showInLegend = FALSE
) |>
  hc_add_series(
    data = airports,
    type = "mappoint",
    name = "Airports",
    color = hex_to_rgba("darkred", alpha = 0.3),
    maxSize = "10",
    tooltip = list(
      pointFormat = "{point.name}: {point.altitude:,.0f} feets <br>
      ({point.lat:,.2f}, {point.lon:,.2f})"
    )
  ) |>
  hc_chart(zoomType = "xy")
```

## `geojsonio` Package

highchartsJS support `geo_json` classes from the `geojsonio` package. So
you can use `hc_add_series` as usual without use `geojson = TRUE`
parameter/argument.

``` r
library(httr)
library(jsonlite)
library(geojsonio)

ausgeojson <- GET("https://raw.githubusercontent.com/johan/world.geo.json/master/countries/AUS.geo.json") |>
  content() |>
  fromJSON(simplifyVector = FALSE) |>
  as.json()

ausmap <- highchart(type = "map") |>
  hc_add_series(mapData = ausgeojson, showInLegend = FALSE)

ausmap
```

We can still adding data:

``` r
airports <- read.csv(
  # "https://raw.githubusercontent.com/ajdapretnar/datasets/master/data/global_airports.csv",
  "https://datacatalogfiles.worldbank.org/ddh-published/0038117/2/DR0046411/airport_volume_airport_locations.csv",
  stringsAsFactors = FALSE
  )

airports <- airports |> 
  filter(Country.Name == "Australia", Name != "Roma Street Railway Station") |> 
  rename(name = Name)

airp_geojson <- geojson_json(airports, lat = "Airport1Latitude", lon = "Airport1Longitude")

class(airp_geojson)
```

    ## [1] "geofeaturecollection" "geojson"              "geo_json"            
    ## [4] "json"

``` r
ausmap |>
  hc_add_series(
    data = airp_geojson,
    type = "mappoint",
    dataLabels = list(enabled = FALSE),
    name = "Airports",
    tooltip = list(pointFormat = "{point.name}")
  )
```

## Advanced Example

Let’s download some geojson files and make a map.

``` r
library(jsonlite)

geojson <- fromJSON(
  "https://cdn.jsdelivr.net/gh/highcharts/highcharts@v7.0.0/samples/data/australia.geo.json",
  simplifyVector = FALSE
)

features <- geojson$features

map_features <- Filter(
  \(x) x$geometry$type %in% c("Polygon", "MultiPolygon"),
  features
)

line_features <- Filter(
  \(x) x$geometry$type %in% c("LineString", "MultiLineString"),
  features
)

point_features <- Filter(
  \(x) x$geometry$type == "Point",
  features
)

geojson_map <- geojson
geojson_map$features <- map_features

geojson_lines <- geojson
geojson_lines$features <- line_features

geojson_points <- geojson
geojson_points$features <- point_features


highchart(type = "map") |>
  hc_add_series(
    type = "map",
    mapData = geojson_map,
    name = "Map areas",
    data = list()
  ) |>
  hc_add_series(
    type = "mapline",
    data = line_features,
    name = "Lines"
  ) |>
  hc_add_series(
    type = "mappoint",
    data = point_features,
    name = "Points"
  )
```

``` r
`%||%` <- function(x, y) if (is.null(x)) y else x
point_data <- lapply(point_features, \(f) {
  coords <- f$geometry$coordinates

  list(
    name = f$properties$name %||% NA_character_,
    lon = coords[[1]],
    lat = coords[[2]]
  )
})

highchart(type = "map") |>
  hc_add_series(
    type = "map",
    mapData = geojson_map,
    name = "Map",
    color = "#8b8a",
    nullColor = "#8b8a",
    dataLabels = list(
      enabled = TRUE,
      format = '{point.name}',
      style = list(
        width = "80px", # force line-wrap
        textTransform = "uppercase",
        fontWeight = "normal",
        textOutline = "none",
        color = "var(--highcharts-neutral-color-100, black)",
        opacity = 0.5
      )
    ),
    tooltip = list(
      pointFormat = "{point.name}"
    )
  ) |>
  hc_add_series(
    type = "mapline",
    data = line_features,
    name = "Rivers",
    states = list(
      hover = list(
        lineWidth = 3
      )
    ),
    color = "#2B8CBE", # river blue
    tooltip = list(
      pointFormat = "{point.properties.NAME}"
    )
  ) |>
  hc_add_series(
    type = "mappoint",
    data = point_data,
    name = "Cities",
    type = "mappoint",
    color = "black",
    marker = list(
      radius = 2
    ),
    dataLabels = list(
      align = "left",
      verticalAlign = "middle"
    ),
    animation = FALSE
  )
```
