# Chart types

## Measurements and ranges

Each row is one day. Its position supplies `x`, `name` labels the day
and `y` is the mean temperature in °C. A range column extends from the
day’s `low` to its `high`. With these names,
`hchart(temperatures, "columnrange")` reads the columns directly. Use
`hcaes(low = minimum, high = maximum)` if your columns have different
names.

Show temperature data

``` r

# fmt: skip
temperatures <- tibble::tribble(
  ~name, ~y, ~low, ~high,
  "Mon", 15,   12,    18,
  "Tue", 17,   13,    21,
  "Wed", 14,   11,    17,
  "Thu", 16,   12,    20,
  "Fri", 18,   14,    22
)
```

Show all temperature charts in R

``` r

gallery(
  c(
    "line",
    "spline",
    "area",
    "streamgraph",
    "areaspline",
    "arearange",
    "areasplinerange",
    "columnrange",
    "errorbar",
    "dumbbell",
    "polar line",
    "polar columnrange"
  ),
  function(label) {
    type <- sub("^polar ", "", label)
    hchart(
      temperatures,
      type,
      name = "Temperature",
      colorByPoint = TRUE,
      lineColor = "#2980b9",
      fillColor = "#2980b966",
      tooltip = list(valueSuffix = " °C")
    ) |>
      hc_chart(
        type = type,
        polar = startsWith(label, "polar")
      ) |>
      hc_xAxis(categories = temperatures$name) |>
      hc_yAxis(title = list(text = ""), visible = type != "streamgraph")
  }
)
```

## Quantities by category

Each visit appears once, at the last shopping step it reached (`name`).
Bars, columns, cylinders and slices show how the 100 visits ended (`y`).
Bars and columns start at zero; polar columns arrange the same
quantities around a circle. A funnel counts everyone who reached each
step: 100 viewed products, 66 added to cart, 42 started checkout and 24
purchased. For variable-width columns and variable-radius slices, `z` is
the illustrative average session duration in minutes, available for all
four steps. Variwide uses it for column width; variable pie uses it for
radius, with zero as the lower bound. The treemap and packed bubbles
split each stage by acquisition source. The word cloud compares stage
and source totals.

Show shopping data

``` r

# fmt: skip
shopping <- tibble::tribble(
  ~name,         ~y, ~z,
  "Viewed",      34,  2.5,
  "Added",       24,    6,
  "Checkout",    18,    9,
  "Purchased",   24,    8
)

# fmt: skip
shopping_sources <- tibble::tribble(
  ~stage,      ~source, ~value,
  "Viewed",   "Search",     18,
  "Viewed",   "Social",     10,
  "Viewed",   "Direct",      6,
  "Added",    "Search",     13,
  "Added",    "Social",      7,
  "Added",    "Direct",      4,
  "Checkout", "Search",      9,
  "Checkout", "Social",      6,
  "Checkout", "Direct",      3,
  "Purchased","Search",    12,
  "Purchased","Social",     8,
  "Purchased","Direct",     4
)
```

Show all shopping charts in R

``` r

gallery(
  c(
    "bar",
    "column",
    "cylinder",
    "columnpyramid",
    "variwide",
    "polar column",
    "pie",
    "variablepie",
    "lollipop",
    "dotplot",
    "item",
    "waterfall",
    "packedbubble",
    "treemap",
    "wordcloud",
    "funnel",
    "pyramid",
    "funnel3d",
    "pyramid3d"
  ),
  function(label) {
    type <- sub("^polar ", "", label)
    points <- shopping
    if (type %in% c("funnel", "pyramid", "funnel3d", "pyramid3d")) {
      points$y <- rev(cumsum(rev(points$y)))
    }
    if (type == "packedbubble") {
      return(hchart(
        shopping_sources,
        type,
        hcaes(group = stage, name = source, value = value),
        minSize = "16%",
        maxSize = "49%",
        zMin = 0,
        layoutAlgorithm = list(splitSeries = TRUE, seriesInteraction = FALSE),
        dataLabels = list(
          enabled = TRUE,
          format = "{point.name}",
          style = list(fontSize = "9px")
        ),
        tooltip = list(
          pointFormat = "{series.name} / {point.name}: {point.value} visits"
        )
      ))
    }
    if (type == "treemap") {
      nodes <- bind_rows(
        transmute(shopping, id = name, name),
        transmute(
          shopping_sources,
          id = paste(stage, source, sep = "-"),
          parent = stage,
          name = source,
          value
        )
      )
      return(hchart(
        nodes,
        type,
        levels = list(
          list(
            level = 1,
            colorByPoint = TRUE,
            dataLabels = list(
              enabled = TRUE,
              align = "left",
              verticalAlign = "top",
              format = "{point.name}",
              style = list(fontSize = "10px", fontWeight = "normal")
            )
          ),
          list(level = 2, colorVariation = list(key = "brightness", to = 0.35))
        ),
        dataLabels = list(enabled = FALSE),
        tooltip = list(
          pointFormat = "{point.parent} / {point.name}: {point.value} visits"
        )
      ))
    }
    if (type == "wordcloud") {
      words <- bind_rows(
        transmute(shopping, name, weight = y),
        summarise(
          group_by(shopping_sources, name = source),
          weight = sum(value)
        )
      )
      return(hchart(
        words,
        type,
        name = "Visits",
        rotation = list(from = 0, to = 0)
      ))
    }
    hchart(points, type, name = "Visits", colorByPoint = TRUE) |>
      hc_plotOptions(
        pie = list(dataLabels = list(distance = 8)),
        variablepie = list(
          zMin = 0,
          dataLabels = list(distance = 8),
          tooltip = list(
            pointFormat = "{point.name}: {point.y} visits<br>Average session: {point.z} min"
          )
        ),
        variwide = list(
          tooltip = list(
            pointFormat = "{point.name}: {point.y} visits<br>Average session: {point.z} min"
          )
        )
      ) |>
      hc_xAxis(
        categories = points$name,
        labels = if (startsWith(label, "polar")) {
          list(distance = 5, style = list(fontSize = "10px"))
        }
      ) |>
      hc_chart(
        type = type,
        polar = startsWith(label, "polar"),
        options3d = list(
          enabled = type %in% c("cylinder", "funnel3d", "pyramid3d"),
          alpha = 12,
          beta = 15
        )
      )
  }
)
```

## Relationships and hierarchies

Each row connects a parent team (`from`) to a subteam (`to`). The link’s
`weight` is the subteam’s headcount. Tree and sunburst charts express
the same hierarchy with `id` and `parent`. Network nodes use
`marker.radius` to show team size.

Show team data

``` r

# fmt: skip
teams <- tibble::tribble(
  ~from,     ~to,       ~weight,
  "Studio",  "Design",       12,
  "Studio",  "Build",        18,
  "Design",  "Web",           7,
  "Design",  "Print",         5,
  "Build",   "Apps",         10,
  "Build",   "Data",          5,
  "Build",   "Tools",         3
)

team_sizes <- bind_rows(
  teams |>
    group_by(from) |>
    summarise(headcount = sum(weight), .groups = "drop") |>
    rename(id = from),
  transmute(teams, id = to, headcount = weight)
) |>
  distinct(id, .keep_all = TRUE) |>
  mutate(
    marker = lapply(
      4 + 10 * sqrt(headcount / max(headcount)),
      function(radius) list(radius = radius)
    )
  )
```

Show all team charts in R

``` r

gallery(
  c(
    "sankey",
    "dependencywheel",
    "arcdiagram",
    "networkgraph",
    "organization",
    "treegraph",
    "sunburst"
  ),
  function(type) {
    if (type == "networkgraph") {
      return(hchart(
        teams,
        type,
        nodes = list_parse(team_sizes),
        layoutAlgorithm = list(enableSimulation = FALSE),
        dataLabels = list(
          enabled = TRUE,
          linkFormat = "",
          style = list(
            fontSize = "9px",
            textOutline = "none",
            fontWeight = "normal"
          )
        ),
        tooltip = list(nodeFormat = "{point.name}: {point.headcount} people")
      ))
    }
    if (type == "organization") {
      return(hchart(
        teams,
        type,
        color = "#47475c",
        colorByPoint = FALSE,
        nodeWidth = 54,
        nodePadding = 8,
        dataLabels = list(
          nodeFormat = "{point.name}",
          style = list(
            color = "#ffffff",
            fontSize = "10px",
            fontWeight = "normal",
            textOutline = "none"
          )
        )
      ))
    }
    if (type %in% c("treegraph", "sunburst")) {
      nodes <- bind_rows(
        tibble(id = "Studio", name = "Studio"),
        transmute(teams, id = to, parent = from, name = to, value = weight)
      )
      if (type == "sunburst") {
        return(hchart(
          nodes,
          type,
          levels = list(list(level = 2, colorByPoint = TRUE))
        ))
      }
      return(hchart(nodes, type))
    }
    hchart(teams, type)
  }
)
```

For a network with an `igraph` layout, see the [igraph
example](https://jkunst.com/highcharter/articles/hchart.html#igraph-package).

## Positions, bubbles and wind

Each point is a South American capital or seat of government at its
longitude (`x`) and latitude (`y`). The rounded coordinates come from
[Natural Earth’s populated
places](https://github.com/nvkelso/natural-earth-vector/blob/master/geojson/ne_10m_populated_places_simple.geojson).
Illustrative wind speed in m/s supplies bubble size and the third
dimension (`z`), vector `length` and wind-barb `value`. `direction`
gives the angle in degrees. Hover over a point to see the city and wind
speed. The 3D scatter also labels the cities. A hollow circle in a
wind-barb series means calm wind (below 0.3 m/s). All the illustrative
speeds here are at least 3 m/s.

Show capital data and illustrative winds

``` r

# fmt: skip
capitals <- tibble::tribble(
  ~name,             ~x,     ~y, ~speed, ~direction,
  "Bogotá",      -74.09,   4.60,      6,         70,
  "Caracas",     -66.92,  10.50,      7,        100,
  "Georgetown",  -58.17,   6.80,      4,         80,
  "Paramaribo",  -55.17,   5.84,      5,         65,
  "Quito",       -78.50,  -0.21,      4,        160,
  "Lima",        -77.05, -12.05,      8,        180,
  "La Paz",      -68.15, -16.50,      6,        225,
  "Sucre",       -65.26, -19.04,      5,        250,
  "Brasília",    -47.92, -15.78,      3,         90,
  "Asunción",    -57.63, -25.29,      7,        120,
  "Santiago",    -70.65, -33.44,      5,        210,
  "Montevideo",  -56.19, -34.91,      9,        150,
  "Buenos Aires",-58.43, -34.61,     11,        135
) |> mutate(z = speed)
```

Show all capital charts in R

``` r

gallery(
  c("scatter", "bubble", "scatter3d", "vector", "windbarb", "polygon"),
  function(type) {
    points <- arrange(capitals, x)
    if (type == "polygon") {
      points <- points[chull(points$x, points$y), ]
    }
    if (type == "windbarb") {
      hc <- hchart(
        points,
        "scatter",
        id = "cities",
        color = "#47475c",
        marker = list(enabled = FALSE),
        dataLabels = list(enabled = FALSE),
        enableMouseTracking = FALSE,
        showInLegend = FALSE
      ) |>
        hc_add_series(
          points,
          "windbarb",
          hcaes(value = speed),
          color = "#47475c",
          dataGrouping = list(enabled = FALSE),
          onSeries = "cities",
          yOffset = 0,
          name = "Wind"
        )
    } else if (type == "vector") {
      hc <- hchart(
        points,
        type,
        hcaes(length = speed),
        color = "#47475c",
        vectorLength = 24,
        lineWidth = 2,
        name = "Wind"
      )
    } else {
      hc <- hchart(points, type, name = "Capitals", color = "#47475c")
    }
    hc |>
      hc_chart(
        type = if (type == "windbarb") "scatter" else type,
        options3d = list(
          enabled = type == "scatter3d",
          alpha = 20,
          beta = 32,
          depth = 160
        )
      ) |>
      hc_plotOptions(
        series = list(
          dataLabels = list(
            enabled = type == "scatter3d",
            format = "{point.name}",
            style = list(fontSize = "9px", fontWeight = "normal")
          )
        ),
        bubble = list(zMin = 0, minSize = 5, maxSize = "18%")
      ) |>
      hc_tooltip(
        headerFormat = "",
        pointFormat = "{point.name}: {point.speed} m/s"
      ) |>
      hc_xAxis(min = -82, max = -43, title = list(text = "Longitude")) |>
      hc_yAxis(min = -40, max = 15, title = list(text = "Latitude"))
  }
)
```

## Gridded measurements

Each cell has a column (`x`), a row (`y`) and a measurement (`value`). A
heatmap colors rectangular cells, a tilemap uses hexagons, and a contour
joins locations with the same value.

Show R code

``` r

volcano_colors <- c("#000004", "#56106E", "#BB3754", "#F98C0A", "#FCFFA4")
cells <- expand.grid(x = 0:5, y = 0:5) |> mutate(value = sin(x) + cos(y))
```

Show R code

``` r

gallery(c("heatmap", "tilemap", "contour"), function(type) {
  hchart(cells, type) |>
    hc_colorAxis(
      min = -2,
      max = 2,
      stops = color_stops(colors = volcano_colors)
    )
})
```

## Other examples

Intervals use start and end positions. A Venn diagram sizes
intersections by `sets` and `value`, and a solid gauge displays a single
measurement (`y`).

### Timeline

Five milestones in Albert Einstein’s life. Spacing follows calendar
years. [ETH Library
biography](https://library.ethz.ch/en/collections-and-archives/short-portraits/einstein-albert-1879-1955.html).

Show R code

``` r

event_colors <- unlist(hc_theme("smpl")$colors)[c(2, 3, 1, 4, 5)]
events <- tibble::tibble(
  color = event_colors,
  x = c(1879, 1905, 1921, 1933, 1955),
  name = c(
    "Born in Ulm",
    "Special relativity",
    "Physics Nobel",
    "Princeton",
    "Dies in Princeton"
  ),
  # Deeper shades of the five marker colors keep the white lettering legible.
  dataLabels = lapply(
    c("#246E9E", "#17774B", "#B34605", "#846707", "#354D63"),
    function(fill) list(backgroundColor = fill)
  )
)
hchart(
  events,
  "timeline",
  hcaes(color = color),
  name = "Albert Einstein",
  colorByPoint = TRUE,
  dataLabels = list(
    format = "{point.x} · {point.name}",
    color = "#FFFFFF",
    borderWidth = 0,
    style = list(
      fontSize = "11px",
      fontWeight = "normal",
      textOutline = "none"
    )
  )
) |>
  hc_xAxis(type = "linear", visible = FALSE) |>
  hc_yAxis(visible = FALSE, title = list(text = NULL)) |>
  hc_tooltip(headerFormat = "", pointFormat = "{point.x} · {point.name}") |>
  hc_size(height = 300)
```

### Task intervals

Each row spans two dates. Map the start to `x`, the end to `x2` and the
lane’s zero-based index to `y`. Here, twelve tasks share four team
lanes. The three phases use different series and colors.
`grouping = FALSE` places each series on the same team lane, while the
start and finish dates determine its horizontal position.

Show R code

``` r

# fmt: skip
tasks <- tibble::tribble(
  ~team,      ~phase,    ~task,        ~offset, ~days, ~progress,
  "Data",     "Prepare","Extract",         0,     3,         1,
  "Data",     "Build",  "Clean",           3,     4,         1,
  "Data",     "Review", "Validate",        7,     3,       0.8,
  "Research", "Prepare","Scope",           0,     4,         1,
  "Research", "Build",  "Analyse",         4,     5,       0.8,
  "Research", "Review", "Review",          9,     3,       0.3,
  "Design",   "Prepare","Wireframes",      1,     3,         1,
  "Design",   "Build",  "Prototype",       4,     4,       0.9,
  "Design",   "Review", "Test",            8,     4,       0.2,
  "Platform", "Prepare","Configure",       0,     2,         1,
  "Platform", "Build",  "Integrate",       5,     5,       0.5,
  "Platform", "Review", "Deploy",         11,     2,         0
) |>
  mutate(
    phase = factor(phase, levels = c("Prepare", "Build", "Review")),
    start = base::as.Date("2025-01-06") + offset,
    finish = start + days,
    lane = match(team, unique(team)) - 1L
  )
hchart(
  tasks,
  "xrange",
  hcaes(
    x = start,
    x2 = finish,
    y = lane,
    group = phase,
    name = task,
    partialFill = progress
  ),
  colorByPoint = FALSE,
  dataLabels = list(
    enabled = TRUE,
    format = "{point.name}",
    style = list(
      fontSize = "10px",
      color = "contrast",
      fontWeight = "normal",
      textOutline = "1px contrast"
    )
  )
) |>
  hc_xAxis(title = list(text = "")) |>
  hc_yAxis(
    categories = unique(tasks$team),
    reversed = TRUE,
    title = list(text = "")
  ) |>
  hc_colors(event_colors[1:3]) |>
  hc_plotOptions(xrange = list(grouping = FALSE, pointWidth = 22)) |>
  hc_tooltip(
    pointFormat = "{point.name}<br>{point.x:%e %b} to {point.x2:%e %b}"
  ) |>
  hc_size(height = 330)
```

The same twelve intervals can be shown as Gantt tasks. Assign an ID to
each task and link the tasks within each team with `dependency`.

Show R code

``` r

schedule <- tasks |>
  group_by(team) |>
  mutate(id = paste(team, row_number(), sep = "-"), dependency = lag(id)) |>
  ungroup() |>
  transmute(
    color = event_colors[as.integer(phase)],
    name = paste(team, task, sep = ": "),
    id,
    start = datetime_to_timestamp(start),
    end = datetime_to_timestamp(finish),
    completed = progress,
    dependency
  )
hchart(schedule, "gantt", hcaes(color = color), name = "Tasks") |>
  hc_yAxis(
    labels = list(
      levels = list(list(level = 1, style = list(fontWeight = "normal")))
    )
  ) |>
  hc_plotOptions(
    gantt = list(
      dataLabels = list(
        style = list(
          fontWeight = "normal",
          color = "#FFFFFF",
          textOutline = "none"
        )
      )
    )
  ) |>
  hc_size(height = 500)
```

[See the release schedule with dependencies and completion
bars](https://jkunst.com/highcharter/articles/showcase.html#gantt-schedules).

### Venn intersections

These illustrative counts describe overlapping skills among 100
analysts. Pairwise intersections include the ten analysts who use all
three tools.

Show R code

``` r

skills <- tibble::tibble(
  sets = list(
    list("R"),
    list("Python"),
    list("SQL"),
    list("R", "Python"),
    list("R", "SQL"),
    list("Python", "SQL"),
    list("R", "Python", "SQL")
  ),
  name = c(
    "R",
    "Python",
    "SQL",
    "R and Python",
    "R and SQL",
    "Python and SQL",
    "All three"
  ),
  value = c(57, 48, 45, 20, 22, 18, 10)
) |>
  dplyr::mutate(label = ifelse(lengths(sets) == 1L, name, as.character(value)))

hchart(
  skills,
  "venn",
  name = "Analysts",
  opacity = 1,
  borderColor = "#ffffff",
  borderWidth = 2,
  dataLabels = list(
    format = "{point.label}",
    style = list(
      fontSize = "11px",
      color = "#ffffff",
      fontWeight = "normal",
      textOutline = "2px #253238"
    )
  )
) |>
  hc_colors(c("#216595", "#367444", "#936816")) |>
  hc_tooltip(pointFormat = "{point.name}: {point.value} analysts") |>
  hc_caption(
    text = "Illustrative skills of 100 analysts; intersection counts include all three tools.",
    style = list(fontSize = "11px")
  ) |>
  hc_size(height = 310)
```

### solidgauge

Show R code

``` r

col_stops <- data.frame(
  q = c(0.15, 0.4, .8),
  c = c('#55BF3B', '#DDDF0D', '#DF5353'),
  stringsAsFactors = FALSE
)

highchart() |>
  hc_chart(type = "solidgauge") |>
  hc_pane(
    startAngle = -90,
    endAngle = 90,
    background = list(
      outerRadius = '100%',
      innerRadius = '60%',
      shape = "arc"
    )
  ) |>
  hc_tooltip(enabled = FALSE) |>
  hc_yAxis(
    stops = list_parse2(col_stops),
    lineWidth = 0,
    minorTickWidth = 0,
    tickAmount = 2,
    min = 0,
    max = 100,
    labels = list(y = 26, style = list(fontSize = "22px"))
  ) |>
  hc_add_series(
    data = 90,
    dataLabels = list(
      y = -50,
      borderWidth = 0,
      useHTML = TRUE,
      style = list(fontSize = "40px")
    )
  ) |>
  hc_size(height = 300)
```

### Related articles

Explore the finished [world tile
map](https://jkunst.com/highcharter/articles/showcase.html#tile-map),
[word
cloud](https://jkunst.com/highcharter/articles/showcase.html#word-cloud)
and [wind
map](https://jkunst.com/highcharter/articles/showcase.html#south-atlantic-wind-field)
in Showcase.

See [Icons and
pictograms](https://jkunst.com/highcharter/articles/showcase.html#icons-and-pictograms)
for image markers, icons in tooltips and symbols that represent
individual items.

The [Maps](https://jkunst.com/highcharter/articles/maps.md) and
[Stock](https://jkunst.com/highcharter/articles/stock.md) articles cover
geographic and financial series. The [bundle
gallery](https://jkunst.com/highcharter/bundle-gallery.md) has an
example for every registered series type.

Show the gallery layout code

``` r

gallery <- function(types, draw) {
  charts <- lapply(types, function(type) {
    draw(type) |>
      hc_title(text = type, style = list(fontSize = "16px")) |>
      hc_legend(enabled = FALSE) |>
      hc_tooltip(outside = TRUE) |>
      hc_size(height = 235)
  })
  htmltools::div(class = "chart-grid", charts)
}
```

### Distributions

For a histogram in R, pass the result of `hist(..., plot = FALSE)` to
[`hchart()`](https://jkunst.com/highcharter/reference/hchart.md). See
the [precomputed histogram
example](https://jkunst.com/highcharter/articles/hchart.html#precomputed-histograms).

A box plot reads five fields per group, `low`, `q1`, `median`, `q3` and
`high`.

Show R code

``` r

waits <- data.frame(
  clinic = c("North", "South", "East", "West", "Central", "Coast"),
  lower = c(4, 6, 3, 5, 7, 2),
  p25 = c(6, 8, 5, 8, 10, 5),
  p50 = c(10, 12, 9, 13, 15, 8),
  p75 = c(14, 15, 13, 17, 21, 12),
  upper = c(19, 22, 18, 24, 29, 17)
)
hchart(
  waits,
  "boxplot",
  hcaes(x = clinic, low = lower, q1 = p25, median = p50, q3 = p75, high = upper)
)
```

The `bellcurve` series fits a normal curve using the sample mean and
standard deviation. This example uses all 32 fuel-economy observations
in `mtcars`. For a kernel density estimate, see
[Densities](https://jkunst.com/highcharter/articles/hchart.html#densities).

Show R code

``` r

fuel <- mtcars |> transmute(x = row_number(), y = mpg)
hchart(fuel, "scatter", id = "fuel", visible = FALSE, showInLegend = FALSE) |>
  hc_add_series(
    type = "bellcurve",
    baseSeries = "fuel",
    name = "Normal curve"
  ) |>
  hc_xAxis(title = list(text = "Fuel economy (mpg)"))
```

### Comparing a measurement with a target

The bullet compares ten daily means (`y`) with a `target` of 18 °C.

Show R code

``` r

daily <- tibble::tibble(
  name = paste(rep(c("W1", "W2"), each = 5), rep(temperatures$name, 2)),
  y = c(temperatures$y, 18, 19, 17, 20, 18)
)
hchart(
  daily,
  "bullet",
  hcaes(x = name, y = y, target = 18),
  colorByPoint = TRUE
) |>
  hc_yAxis(title = list(text = "Temperature (°C)")) |>
  hc_size(height = 300)
```
