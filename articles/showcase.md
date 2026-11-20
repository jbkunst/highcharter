# Showcase

Explore complete charts and expand **Show R code** below each one to see
how it was built. For short examples grouped by data shape, see [Chart
types](https://jkunst.com/highcharter/articles/chart-types.md).

## HIMYM example

> This is a bar graph describing my favorite pies including a pie chart
> describing my favorite bars. - *Marshall Eriksen*

Show R code

``` r

favorite_bars <- data.frame(
  bar = c(
    "Mclaren's",
    "McGee's",
    "P & G",
    "White Horse Tavern",
    "King Cole Bar"
  ),
  percent = c(30, 28, 27, 12, 3)
)
favorite_pies <- data.frame(
  pie = c(
    "Strawberry Rhubarb",
    "Pumpkin",
    "Lemon Meringue",
    "Blueberry",
    "Key Lime"
  ),
  percent = c(85, 64, 75, 100, 57)
)

highchart() |>
  # Data
  hc_add_series(
    favorite_pies,
    "column",
    hcaes(
      x = pie,
      y = percent
    ),
    name = "Pie"
  ) |>
  hc_add_series(
    favorite_bars,
    "pie",
    hcaes(
      name = bar,
      y = percent
    ),
    name = "Bars"
  ) |>
  # Options for each type of series
  hc_plotOptions(
    series = list(
      showInLegend = FALSE,
      pointFormat = "{point.y}%",
      colorByPoint = TRUE
    ),
    pie = list(
      center = c("83%", "46%"),
      size = "62%",
      dataLabels = list(enabled = FALSE)
    )
  ) |>
  # Axis
  hc_yAxis(
    width = "64%",
    title = list(text = "percentage of tastiness"),
    labels = list(format = "{value}%"),
    max = 100
  ) |>
  hc_xAxis(
    width = "64%",
    categories = favorite_pies$pie
  ) |>
  # Titles, subtitle, caption and credits
  hc_title(
    text = "How I Met Your Mother: Pie Chart Bar Graph"
  ) |>
  hc_subtitle(
    text = "This is a bar graph describing my favorite pies
    including a pie chart describing my favorite bars"
  ) |>
  hc_caption(
    text = "The values represented are in percentage of tastiness and awesomeness."
  ) |>
  hc_credits(
    enabled = TRUE,
    text = "Source: HIMYM",
    href = "https://www.youtube.com/watch?v=f_J8QU1m0Ng",
    style = list(fontSize = "12px")
  )
```

## Charts inside tooltips

These two Gapminder examples come from [Using tooltips in unexpected
ways](https://jkunst.com/blog/posts/2019-02-04-using-tooltips-in-unexpected-ways/).

### A country’s population over time

Each bubble is a country in 2007. Hover over one to see its population
from 1952 to 2007. The `ttdata` column holds that country’s observations
as a list of points.

Show R code

``` r

library(dplyr)
library(purrr)
library(highcharter)

gp <- gapminder::gapminder |>
  arrange(desc(year)) |>
  distinct(country, .keep_all = TRUE)
gp2 <- gapminder::gapminder |>
  select(country, x = year, y = pop) |>
  group_nest(country, .key = "ttdata") |>
  mutate(ttdata = map(ttdata, list_parse))

gptot <- left_join(gp, gp2, by = "country")

hchart(
  gptot,
  "point",
  hcaes(lifeExp, gdpPercap, name = country, size = pop, group = continent)
) |>
  hc_yAxis(type = "logarithmic") |>
  hc_tooltip(
    useHTML = TRUE,
    headerFormat = "<b>{point.key}</b>",
    pointFormatter = tooltip_chart(
      accesor = "ttdata",
      hc_opts = list(
        series = list(list(name = "point.name")),
        tooltip = list(
          headerFormat = "{point.x}<br>",
          pointFormat = "{series.name}: {point.y:,.0f}"
        )
      )
    )
  )
```

### A scatter plot inside a donut

Each slice represents a continent’s share of the 2007 population. Hover
over a slice to see its countries in the center of the donut. The
scatter plot shows life expectancy on the horizontal axis and GDP per
capita on the vertical axis.

Show R code

``` r

library(dplyr)
library(purrr)
library(highcharter)

gp <- gapminder::gapminder |>
  arrange(desc(year)) |>
  distinct(country, .keep_all = TRUE)
donutdata <- gp |>
  group_by(continent) |>
  summarise(pop = sum(as.double(pop)), .groups = "drop")

donutdata2 <- gp |>
  select(continent, name = country, x = lifeExp, y = gdpPercap) |>
  group_nest(continent, .key = "ttdata") |>
  mutate(ttdata = map(ttdata, list_parse)) |>
  left_join(donutdata, by = "continent")

hchart(
  donutdata2,
  "pie",
  hcaes(name = continent, y = pop),
  name = "Population share",
  innerSize = "78%"
) |>
  hc_tooltip(
    useHTML = TRUE,
    headerFormat = "<b>{point.key}</b>",
    pointFormatter = tooltip_chart(
      accesor = "ttdata",
      hc_opts = list(
        chart = list(type = "scatter"),
        series = list(list(name = "point.name")),
        tooltip = list(
          headerFormat = "<b>{point.name}</b><br>",
          pointFormat = "Life expectancy: {point.x:.1f} years<br>GDP per capita: ${point.y:,.0f}"
        ),
        credits = list(enabled = FALSE),
        plotOptions = list(scatter = list(marker = list(radius = 2)))
      ),
      width = 200,
      height = 150
    ),
    positioner = JS(
      "function (width, height) {
      const chart = this.chart, center = chart.series[0].center;
      return {
        x: chart.plotLeft + center[0] - width / 2,
        y: chart.plotTop + center[1] - height / 2
      };
    }"
    ),
    shadow = FALSE,
    borderWidth = 0,
    backgroundColor = "transparent",
    hideDelay = 1000
  )
```

## Pokemon

Select a Pokémon type to explore its secondary types.

Show R code

``` r

library(highcharter)
library(dplyr)

counts <- pokemon |>
  count(type_1, type_2, type_1_color, name = "n") |>
  mutate(type_2 = coalesce(type_2, paste("Only", type_1)))

nodes <- data_to_hierarchical(counts, c(type_1, type_2), n)
palette <- setNames(pokemon$type_1_color, pokemon$type_1)
nodes <- lapply(nodes, function(node) {
  if (node$level == 1L) {
    node$color <- unname(palette[node$name])
  }
  node$name <- tools::toTitleCase(node$name)
  node
})

hchart(
  nodes,
  type = "treemap",
  name = "All Pokémon",
  allowTraversingTree = TRUE,
  dataLabels = list(
    style = list(
      fontFamily = "Shadows Into Light",
      fontWeight = "normal",
      fontSize = "15px",
      color = "contrast",
      textOutline = "none"
    )
  ),
  layoutAlgorithm = "squarified",
  levelIsConstant = FALSE,
  levels = list(list(level = 1, dataLabels = list(enabled = TRUE)))
) |>
  hc_title(
    text = "Pokémon by type",
    style = list(fontFamily = "Shadows Into Light", fontWeight = "normal")
  ) |>
  hc_size(height = 480)
```

## A reading survey on a Likert scale

Where do readers agree, and where are they divided? Each row in this
illustrative survey adds to 100%. The midpoint of the neutral response
sits at zero. Click **Neutral** in the legend to toggle both halves
together.

Show R code

``` r

survey <- data.frame(
  item = c("I read for pleasure", "I discuss books", "I prefer print"),
  strongly_disagree = c(5, 12, 15),
  disagree = c(10, 28, 20),
  neutral = c(15, 20, 30),
  agree = c(40, 30, 20),
  strongly_agree = c(30, 10, 15)
)

highchart() |>
  hc_chart(type = "bar") |>
  hc_title(text = "How do you feel about reading?") |>
  hc_xAxis(categories = survey$item) |>
  hc_yAxis(
    min = -100,
    max = 100,
    title = list(text = "Share of responses"),
    labels = list(
      formatter = JS("function () { return Math.abs(this.value) + '%'; }")
    )
  ) |>
  hc_plotOptions(series = list(stacking = "normal", borderWidth = 0)) |>
  hc_add_series(
    name = "Strongly disagree",
    data = -survey$strongly_disagree,
    color = "#96422f",
    legendIndex = 0
  ) |>
  hc_add_series(
    name = "Disagree",
    data = -survey$disagree,
    color = "#dc9b82",
    legendIndex = 1
  ) |>
  hc_add_series(
    name = "Strongly agree",
    data = survey$strongly_agree,
    color = "#22685d",
    legendIndex = 4
  ) |>
  hc_add_series(
    name = "Agree",
    data = survey$agree,
    color = "#76b5a4",
    legendIndex = 3
  ) |>
  hc_add_series(
    name = "Neutral",
    id = "neutral",
    data = survey$neutral / 2,
    color = "#c8c8c8",
    legendIndex = 2
  ) |>
  hc_add_series(
    name = "Neutral",
    linkedTo = "neutral",
    data = -survey$neutral / 2,
    color = "#c8c8c8"
  ) |>
  hc_tooltip(
    formatter = JS(
      "function () {
    const share = Math.abs(this.y) * (this.series.name === 'Neutral' ? 2 : 1);
    return this.category + '<br>' + this.series.name + ': ' + share + '%';
  }"
    )
  )
```

## Daily temperature range

Inspired by [Weather Radials](http://weather-radials.com/), each spoke
shows one day in Santiago in 2025. Its ends mark the minimum and maximum
temperature, and its color reflects the daily mean. The monthly lines in
[`highcharts_demo()`](https://jkunst.com/highcharter/reference/highcharts_demo.md)
average those same daily means for each city.

Show R code

``` r

santiago <- subset(city_weather, city == "Santiago")

hchart(
  santiago,
  type = "columnrange",
  hcaes(x = date, low = temp_min, high = temp_max, color = temp_mean)
) |>
  hc_chart(polar = TRUE) |>
  hc_yAxis(
    title = list(text = NULL),
    labels = list(format = "{value} °C"),
    showFirstLabel = FALSE
  ) |>
  hc_xAxis(
    title = list(text = NULL),
    gridLineWidth = 0.5,
    labels = list(format = "{value:%b}")
  ) |>
  hc_tooltip(
    headerFormat = "<b>{point.x:%e %B %Y}</b><br>",
    pointFormat = "Min: {point.low} °C<br>Mean: {point.temp_mean} °C<br>Max: {point.high} °C"
  ) |>
  hc_title(text = "Daily temperature range in Santiago, 2025") |>
  hc_subtitle(text = "ERA5 reanalysis via Open-Meteo") |>
  hc_size(
    height = 600
  )
```

## Stars

Inspired by Nadieh Bremer’s
[block](http://bl.ocks.org/nbremer/eb0d1fd4118b731d069e2ff98dfadc47).
[Download the star sample
(CSV)](https://jkunst.com/highcharter/articles/data/stars.csv).

Show R code

``` r

stars <- read.csv("data/stars.csv")

colors <- c(
  "#FB1108",
  "#FD150B",
  "#FA7806",
  "#FBE426",
  "#FCFB8F",
  "#F3F5E7",
  "#C7E4EA",
  "#ABD6E6",
  "#9AD2E1"
)

stars$color <- highcharter::colorize(log(stars$temp), colors)

x <- c("Luminosity", "Temperature", "Distance", "Radius")
y <- sprintf("{point.%s:.2f}", c("lum", "temp", "distance", "radiussun"))

tltip <- tooltip_table(x, y)

hchart(
  stars,
  "scatter",
  hcaes(
    temp,
    lum,
    size = radiussun,
    color = color
  ),
  minSize = 2,
  maxSize = 20
) |>
  hc_chart(
    # backgroundColor = "black"
    backgroundColor = hex_to_rgba("#071426", 0.88),
    divBackgroundImage = "../stars-field.jpg"
  ) |>
  hc_xAxis(
    title = list(text = "Temperature", style = list(color = "#F2F6FF")),
    type = "logarithmic",
    gridLineWidth = 0,
    reversed = TRUE,
    labels = list(style = list(color = "#F2F6FF")),
    lineColor = "#A9B9D2"
  ) |>
  hc_yAxis(
    title = list(text = "Luminosity", style = list(color = "#F2F6FF")),
    type = "logarithmic",
    gridLineWidth = 0,
    labels = list(style = list(color = "#F2F6FF")),
    lineColor = "#A9B9D2"
  ) |>
  hc_title(
    style = list(color = "#F2F6FF"),
    text = "Our nearest Stars"
  ) |>
  hc_subtitle(
    style = list(color = "#DCE5EF"),
    text = "In a Hertzsprung-Russell diagram"
  ) |>
  hc_tooltip(
    useHTML = TRUE,
    headerFormat = "",
    pointFormat = tltip
  ) |>
  hc_size(
    height = 700
  )
```

Background photograph: [ESO/Digitized Sky Survey 2, around the Hubble
Ultra Deep Field](https://www.eso.org/public/images/eso1832b/). The dark
overlay keeps both axes legible over the stars.

## Word cloud

The 160 most frequent terms in R’s graphics manual fill the cloud. Word
size reflects the number of mentions across help-page descriptions.

Show R code

``` r

manual <- tools::Rd_db("graphics")
descriptions <- vapply(
  manual,
  function(topic) {
    description <- Filter(
      function(x) identical(attr(x, "Rd_tag"), "\\description"),
      topic
    )
    paste(unlist(description), collapse = " ")
  },
  character(1)
)

words <- unlist(strsplit(tolower(descriptions), "[^a-z]+"))
stopwords <- c(
  "this",
  "that",
  "with",
  "from",
  "which",
  "given",
  "used",
  "using",
  "will",
  "function",
  "functions",
  "specified",
  "their",
  "other",
  "these"
)
counts <- sort(
  table(words[nchar(words) > 3 & !words %in% stopwords]),
  decreasing = TRUE
)
terms <- head(
  data.frame(name = names(counts), weight = as.integer(counts)),
  160
)

hchart(
  terms,
  "wordcloud",
  name = "Mentions",
  placementStrategy = "center",
  spiral = "rectangular",
  rotation = list(from = -45, to = 45, orientations = 5),
  minFontSize = 8,
  maxFontSize = 42,
  style = list(fontFamily = "Georgia, serif", fontWeight = "bold")
) |>
  hc_colors(c("#143f50", "#276774", "#347c74", "#9a5435", "#614876")) |>
  hc_title(text = "The language of R graphics") |>
  hc_tooltip(
    valueDecimals = 0,
    pointFormat = "{point.weight:,.0f} mentions in the graphics manual"
  ) |>
  hc_size(height = 420)
```

## Gantt schedules

Follow a release from data import to publication. Arrows connect
prerequisites and the filled portion of each bar shows completion.

Show R code

``` r

tasks <- data.frame(
  name = c("Import", "Clean", "Explore", "Model", "Review", "Publish"),
  id = c("import", "clean", "explore", "model", "review", "publish"),
  start = datetime_to_timestamp(as.Date("2025-06-02") + c(0, 2, 5, 5, 10, 12)),
  end = datetime_to_timestamp(as.Date("2025-06-02") + c(2, 5, 8, 10, 12, 13)),
  completed = c(1, 1, 1, 0.6, 0, 0)
)
tasks$dependency <- list(
  NA,
  "import",
  "clean",
  "clean",
  c("explore", "model"),
  "review"
)
tasks$color <- c(
  "#326b65",
  "#326b65",
  "#326b65",
  "#4678a8",
  "#ac7955",
  "#ac7955"
)

hchart(tasks, "gantt", name = "Release plan") |>
  hc_title(text = "From raw data to release") |>
  hc_subtitle(
    text = "Exploration and modelling run in parallel before review"
  ) |>
  hc_yAxis(
    labels = list(
      levels = list(list(level = 1, style = list(fontWeight = "normal")))
    )
  ) |>
  hc_plotOptions(
    gantt = list(
      completed = list(fill = "#21434c"),
      dataLabels = list(
        style = list(
          fontWeight = "normal",
          color = "#FFFFFF",
          textOutline = "none"
        )
      )
    )
  ) |>
  hc_size(height = 355)
```

## Volcanoes along the southern Andes

Eight volcanoes form a chain inland from the offshore boundary of the
Nazca and South American plates. Hover over a triangle to identify a
volcano. The GeoJSON contains the boundary as a line and the volcanoes
as points, so the two layers get separate legend entries. [Download the
map
layers](https://jkunst.com/highcharter/articles/data/southern-andes.geojson).

Volcano locations come from the [Smithsonian Global Volcanism
Program](https://volcano.si.edu/). The boundary comes from Peter Bird’s
[PB2002 model](https://doi.org/10.1029/2001GC000252), converted to
GeoJSON by [Hugo Ahlenius, Nordpil and
contributors](https://github.com/fraxen/tectonicplates).

Show R code

``` r

andes <- geojsonio::geojson_list(geojsonio::as.json(
  "data/southern-andes.geojson"
))

hcmap(
  "cl",
  name = "Chile",
  nullColor = "#e5eceb",
  enableMouseTracking = FALSE,
  showInLegend = FALSE
) |>
  hc_add_series(data = andes, name = c("Plate boundary", "Volcanoes")) |>
  hc_mapView(
    fitToGeometry = list(
      type = "MultiPoint",
      coordinates = list(c(-76, -42.5), c(-70.4, -35.7))
    )
  ) |>
  hc_plotOptions(
    mapline = list(color = "#265675", lineWidth = 3),
    mappoint = list(
      color = "#b34e30",
      marker = list(symbol = "triangle", radius = 5),
      dataLabels = list(
        filter = list(property = "name", operator = "==", value = "Villarrica")
      )
    )
  ) |>
  hc_legend(enabled = TRUE) |>
  hc_title(text = "Volcanoes along the southern Andes") |>
  hc_tooltip(headerFormat = "", pointFormat = "{point.name}")
```

### Explore the global distribution

Switch from the regional view to the full Holocene catalogue. Each
triangle marks a volcano, including submarine features. Hover for its
name, country, landform and elevation. Toggle the plate boundaries in
the legend to compare the volcanic arcs around the Pacific with
volcanoes in plate interiors.

Show R code

``` r

volcanoes <- read.csv("data/holocene-volcanoes.csv.gz")
plates <- jsonlite::read_json("data/plate-boundaries.geojson.gz")

hcmap(
  "custom/world.topo.json",
  name = "Land",
  showInLegend = FALSE,
  nullColor = "rgba(92,126,118,0.20)",
  borderWidth = 0.3,
  enableMouseTracking = FALSE
) |>
  hc_add_series(
    type = "mapline",
    name = "Plate boundaries",
    data = lapply(plates$features, function(f) list(geometry = f$geometry)),
    color = "#547682",
    lineWidth = 1.2,
    enableMouseTracking = FALSE
  ) |>
  hc_add_series(
    volcanoes,
    "mappoint",
    hcaes(name = name, lon = lon, lat = lat),
    name = "Holocene volcanoes",
    color = "rgba(175,68,40,0.76)",
    marker = list(symbol = "triangle", radius = 3),
    dataLabels = list(enabled = FALSE),
    turboThreshold = 0
  ) |>
  hc_title(text = "Volcanoes and plate boundaries") |>
  hc_subtitle(
    text = "1,215 Holocene volcanoes · Smithsonian Global Volcanism Program"
  ) |>
  hc_legend(enabled = TRUE) |>
  hc_mapNavigation(enabled = TRUE, enableMouseWheelZoom = FALSE) |>
  hc_tooltip(
    headerFormat = "",
    pointFormat = "<b>{point.name}</b> · {point.country}<br>{point.landform}<br>Elevation: {point.elevation:,.0f} m"
  ) |>
  hc_caption(
    text = "Volcanoes: Smithsonian GVP · Boundaries: Peter Bird (PB2002), via Nordpil."
  )
```

[Download the volcano catalogue
extract](https://jkunst.com/highcharter/articles/data/holocene-volcanoes.csv.gz)
· [Download the simplified plate
boundaries](https://jkunst.com/highcharter/articles/data/plate-boundaries.geojson.gz).

## South Atlantic wind field

On 27 March 2004, Hurricane Catarina approached southern Brazil. This
snapshot shows ERA5 wind at 10 m at 18:00 UTC. Each arrow points
downwind and its color gives the speed. Sampling the 0.25° reanalysis
every 0.75° keeps the circulation legible at this scale. Hover over an
arrow for its speed and bearing. [Copernicus
ERA5](https://doi.org/10.24381/cds.adbb2d47) · [NASA satellite image of
Catarina](https://science.nasa.gov/earth/earth-observatory/rare-south-atlantic-tropical-cyclone-12939/).

Show R code

``` r

wind <- read.csv(system.file(
  "extdata",
  "catarina-wind.csv",
  package = "highcharter"
))
wind$speed <- sqrt(wind$u^2 + wind$v^2)
wind$bearing <- (atan2(wind$u, wind$v) * 180 / pi + 360) %% 360

# Draw each arrow in local east/north coordinates, then convert to longitude/latitude.
arrows <- lapply(seq_len(nrow(wind)), function(i) {
  cell <- wind[i, ]
  angle <- cell$bearing * pi / 180
  along <- c(-0.24, 0.24, 0.08, 0.24, 0.08)
  across <- c(0, 0, -0.09, 0, 0.09)
  east <- along * sin(angle) + across * cos(angle)
  north <- along * cos(angle) - across * sin(angle)
  coordinates <- Map(
    c,
    cell$lon + east / cos(cell$lat * pi / 180),
    cell$lat + north
  )
  list(
    value = cell$speed,
    bearing = cell$bearing,
    lon = cell$lon,
    lat = cell$lat,
    geometry = list(type = "LineString", coordinates = coordinates)
  )
})

hcmap(
  "custom/world.topo.json",
  nullColor = "#f0eee8",
  borderColor = "#a8b1af",
  showInLegend = FALSE,
  enableMouseTracking = FALSE
) |>
  hc_chart(plotBackgroundColor = "#eaf3f6") |>
  hc_mapView(
    projection = list(name = "WebMercator"),
    padding = 0,
    fitToGeometry = list(
      type = "MultiPoint",
      coordinates = list(c(-56, -33.5), c(-40.5, -22.75))
    )
  ) |>
  hc_add_series(
    type = "mapline",
    name = "10 m wind",
    data = arrows,
    colorKey = "value",
    lineWidth = 2,
    tooltip = list(
      pointFormat = "{point.lat:.1f}°, {point.lon:.1f}° · {point.value:.1f} m/s towards {point.bearing:.0f}°"
    )
  ) |>
  hc_colorAxis(
    min = 0,
    max = 15,
    tickPositions = c(0, 3, 6, 9, 12, 15),
    stops = color_stops(colors = c("#497991", "#137b78", "#c87b21", "#a63742"))
  ) |>
  hc_legend(
    layout = "horizontal",
    align = "center",
    title = list(text = "Wind speed (m/s)")
  ) |>
  hc_add_series(
    type = "mappoint",
    name = "Coastal cities",
    showInLegend = FALSE,
    color = "#45434a",
    marker = list(radius = 2),
    data = list(
      list(name = "Florianópolis", lon = -48.55, lat = -27.60),
      list(name = "Porto Alegre", lon = -51.23, lat = -30.03)
    ),
    dataLabels = list(
      enabled = TRUE,
      format = "{point.name}",
      align = "right",
      style = list(fontSize = "10px", fontWeight = "normal")
    )
  ) |>
  hc_caption(
    text = "Wind: Copernicus Climate Change Service (ERA5), sampled at 0.75°."
  ) |>
  hc_title(text = "Catarina off the coast of Brazil") |>
  hc_subtitle(text = "Surface wind · 27 March 2004, 18:00 UTC") |>
  hc_size(height = 500)
```

## Tile map

Each hexagon represents one country, colored by region. Hover over a
tile to read its country name. The layout follows [Maarten Lambrechts’
world tile
grid](https://gist.github.com/maartenzam/787498bbc07ae06b637447dbd430ea0a).

Show R code

``` r

grid_file <- system.file(
  "extdata",
  "world-tile-grid.csv",
  package = "highcharter"
)
data <- utils::read.csv(grid_file, na.strings = character())

hchart(data, "tilemap", hcaes(x = x, y = y, name = name, group = region)) |>
  hc_title(text = "One country, one tile") |>
  hc_chart(type = "tilemap") |>
  hc_plotOptions(
    series = list(
      dataLabels = list(
        enabled = TRUE,
        format = "{point.alpha_2}",
        color = "white",
        style = list(textOutline = FALSE)
      )
    )
  ) |>
  hc_tooltip(
    headerFormat = "",
    pointFormat = "<b>{point.name}</b> is in <b>{point.region}</b>"
  ) |>
  hc_xAxis(visible = FALSE) |>
  hc_yAxis(visible = FALSE) |>
  hc_size(height = 800)
```

## Icons and pictograms

### Icons as markers

The [fontawesome package](https://rstudio.github.io/fontawesome/)
provides SVG icons that can be used in markers and tooltips. These are
the original R and Python examples, with the same data and colors.
Embedding the SVG directly keeps the icons sharp and avoids an
intermediate PNG file.

Show R code

``` r

library(fontawesome)

set.seed(123)
df <- data.frame(
  a = round(rnorm(10), 2),
  b = round(rnorm(10), 2)
)

fa_to_data_uri <- function(name, fill, width = 22) {
  size <- paste0(width, "px")
  icon <- fontawesome::fa(name, fill = fill, width = size, height = size)
  svg <- as.character(icon)
  # Standalone images need an XML namespace and intrinsic pixel dimensions.
  svg <- sub(
    "<svg",
    sprintf(
      '<svg xmlns="http://www.w3.org/2000/svg" width="%s" height="%s"',
      width,
      width
    ),
    svg,
    fixed = TRUE
  )
  svg <- sub(
    'preserveAspectRatio="none"',
    'preserveAspectRatio="xMidYMid meet"',
    svg,
    fixed = TRUE
  )
  paste0(
    "data:image/svg+xml,",
    utils::URLencode(svg, reserved = TRUE)
  )
}

# Reuse the same colors in markers, series and tooltips.
rcol <- "#4C83B6"
pcol <- "#3CAB48"
rproj <- fa_to_data_uri("r-project", fill = rcol)
pthon <- fa_to_data_uri("python", fill = pcol)

highchart() |>
  hc_title(text = "Font Awesome icons") |>
  hc_add_series(
    df,
    "scatter",
    hcaes(a, b),
    name = "R icons",
    color = rcol,
    marker = list(symbol = paste0("url(", rproj, ")")),
    icon = as.character(fontawesome::fa(
      "r-project",
      fill = rcol,
      height = "15px",
      vertical_align = "middle"
    ))
  ) |>
  hc_add_series(
    df,
    "scatter",
    hcaes(b, a),
    name = "Python icons",
    color = pcol,
    marker = list(symbol = paste0("url(", pthon, ")")),
    icon = as.character(fontawesome::fa(
      "python",
      fill = pcol,
      height = "15px",
      vertical_align = "middle"
    ))
  ) |>
  hc_tooltip(
    useHTML = TRUE,
    pointFormat = paste0(
      "<b>",
      "{series.options.icon} ",
      "[{point.x}, {point.y}]",
      "</b>"
    )
  )
```

### Count with pictograms

This example, inspired by [waffle](https://github.com/hrbrmstr/waffle),
uses the original food categories, counts and colors. Each symbol
represents one unit.

Show R code

``` r

library(dplyr)
library(purrr)

df2 <- tibble(
  type = c("fruit", "samminch", "pizza"),
  amount = c(46, 54, 80),
  faico = c("apple", "bread-slice", "pizza-slice"),
  col = c("#d35400", "#907E4D", "#F89101")
)


df2 <- df2 |>
  mutate(
    uri = map2_chr(faico, col, ~ fa_to_data_uri(.x, fill = .y)),
    marker = map(uri, ~ list(symbol = paste0("url(", .x, ")")))
  )

hchart(
  df2,
  "item",
  hcaes(name = type, y = amount),
  name = "What I eat",
  showInLegend = TRUE
) |>
  hc_legend(labelFormat = "{name} <span style='opacity: 0.4'>{y}</span>") |>
  hc_colors(pull(df2, col))
```

See the [Highcharts item chart
guide](https://www.highcharts.com/docs/chart-and-series-types/item-chart)
for other layouts and symbol options.
