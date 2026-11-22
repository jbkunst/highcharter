# Prepare chart data with data helpers

When each row already describes a point, pass the table straight to
[`hchart()`](https://jkunst.com/highcharter/reference/hchart.md). Use a
`data_to_*` helper when you need to calculate boxplot statistics, count
transitions or reorganize rows into the structure a chart expects.

| What you have | Helper | What to do with the result |
|----|----|----|
| Several measurements per observation | [`data_to_parallel_coordinates()`](https://jkunst.com/highcharter/reference/data_to_parallel_coordinates.md) | Add one line per row with [`hc_add_series_list()`](https://jkunst.com/highcharter/reference/hc_add_series_list.md). |
| A numeric measurement and optional groups | [`data_to_boxplot()`](https://jkunst.com/highcharter/reference/data_to_boxplot.md) | Add the boxes and optional outlier series with [`hc_add_series_list()`](https://jkunst.com/highcharter/reference/hc_add_series_list.md). |
| One column per stage in a journey | [`data_to_sankey()`](https://jkunst.com/highcharter/reference/data_to_sankey.md) | Pass the weighted links to `hchart(links, type = "sankey")`. |
| Nested groups and a numeric size | [`data_to_hierarchical()`](https://jkunst.com/highcharter/reference/data_to_hierarchical.md) | Pass the nodes to `hchart(nodes, type = "treemap")` or `hchart(nodes, type = "sunburst")`. |
| Coordinates and text for labels | [`data_to_annotation_labels()`](https://jkunst.com/highcharter/reference/data_to_annotation_labels.md) | Pass the labels to [`hc_add_annotation()`](https://jkunst.com/highcharter/reference/hc_add_annotation.md) on an existing chart. |

``` r

library(highcharter)
hc_set_theme("hcrt", colors = hc_theme("smpl")$colors)
```

## Parallel coordinates

Each flower in `iris` becomes a line crossing four measurement axes.
Select the numeric columns in display order. Use translucent lines to
reveal where flowers overlap. The row number identifies each specimen,
and color distinguishes the three species.

``` r

measurements <- iris[1:4]
series <- data_to_parallel_coordinates(
  measurements,
  name = paste(iris$Species, seq_len(nrow(iris)), sep = " · "),
  color = hex_to_rgba(colorize(iris$Species), alpha = 0.36)
)

highchart() |>
  hc_chart(type = "line", parallelCoordinates = TRUE) |>
  hc_xAxis(categories = names(measurements)) |>
  hc_add_series_list(series) |>
  hc_tooltip(
    formatter = JS(
      "function () {
    const axes = this.series.xAxis.categories;
    const rows = this.series.points.map(p => {
      const value = p.isNull ? '—' : Highcharts.numberFormat(p.y, 1) + ' cm';
      const row = axes[p.x] + ': ' + value;
      return p.x === this.x ? '<b>' + row + '</b>' : row;
    });
    return ['<b>' + this.series.name + '</b>', ...rows].join('<br>');
  }"
    )
  )
```

Hover over any axis to see the four measurements for that flower. The
tooltip reads the points already stored in its series and emphasizes the
current axis. Highcharts scales each axis independently. A constant
column keeps its value, and a missing measurement leaves a gap in that
flower’s line.

## Boxplots

To compare petal lengths across species, let the helper calculate one
box per group. With `add_outliers = TRUE`, it also returns a scatter
series for the observations beyond the whiskers. Click the legend to
hide or show the boxes and their outliers together.

``` r

boxes <- data_to_boxplot(
  iris,
  Petal.Length,
  Species,
  add_outliers = TRUE,
  name = "Petal length",
  color = hc_theme("smpl")$colors[[1]]
)

highchart() |>
  hc_chart(style = list(fontFamily = "IBM Plex Sans", fontWeight = "300")) |>
  hc_xAxis(categories = levels(iris$Species)) |>
  hc_yAxis(title = list(text = "Petal length (cm)")) |>
  hc_legend(itemStyle = list(fontWeight = "300")) |>
  hc_add_series_list(boxes)
```

## Sankey links

Which airlines connected New York’s three airports to the Midwest? Each
row is one flight with a recorded arrival in January 2013 at one of six
selected destinations. Order the columns as origin → airline →
destination.
[`data_to_sankey()`](https://jkunst.com/highcharter/reference/data_to_sankey.md)
counts the flights between each pair of adjacent stages. For example,
the links into Chicago O’Hare (ORD) sum to 1,230 arrivals.

``` r

flights <- read.csv("data/nyc-midwest-flights.csv.gz")
links <- data_to_sankey(flights[c("origin", "carrier", "dest")])

hchart(links, "sankey", name = "Flights", nodeWidth = 14, nodePadding = 12) |>
  hc_title(text = "From New York to the Midwest") |>
  hc_subtitle(text = "3,445 flights · January 2013") |>
  hc_tooltip(valueDecimals = 0)
```

[Flight data from nycflights13](https://nycflights13.tidyverse.org/) ·
[Download the three flight
columns](https://jkunst.com/highcharter/articles/data/nyc-midwest-flights.csv.gz).
The same layout can display [parallel sets in
D3](https://observablehq.com/@d3/parallel-sets).

## Hierarchy nodes

Count Pokémon by primary and secondary type.
[`data_to_hierarchical()`](https://jkunst.com/highcharter/reference/data_to_hierarchical.md)
turns each primary type into a parent node and each observed combination
into a leaf. Pokémon with a single type get their own leaf, such as
“Only Electric”.

In this [treemap from
Showcase](https://jkunst.com/highcharter/articles/showcase.html#pokemon),
the area of each rectangle shows the number of Pokémon. Click a primary
type to explore its secondary types.

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

label_style <- list(fontFamily = "Shadows Into Light", fontSize = "15px")

hchart(
  nodes,
  type = "treemap",
  name = "All Pokémon",
  allowTraversingTree = TRUE,
  breadcrumbs = list(
    buttonTheme = list(style = label_style),
    separator = list(style = label_style)
  ),
  dataLabels = list(
    style = c(
      label_style,
      list(fontWeight = "normal", color = "contrast", textOutline = "none")
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
  hc_tooltip(style = label_style) |>
  hc_size(height = 480)
```

## Annotation labels

Stage 8 of the 2017 Tour de France has three kinds of landmarks: towns,
summits and climbs. Each row supplies its distance (`x`), elevation
(`y`) and label (`text`). Convert each table with the same helper, then
give its labels a placement suited to the terrain. Here 12 labels share
a single elevation series.

[Original annotated stage
profile](https://jkunst.com/blog/posts/2020-06-02-30diasdegraficos-parte-3/)
· [Download the elevation profile
(CSV)](https://jkunst.com/highcharter/articles/data/tour-2017-stage-8.csv).

``` r

stage <- read.csv("data/tour-2017-stage-8.csv")
towns <- data.frame(
  x = c(27.98, 45.5, 63, 84, 129.5, 159),
  y = c(255, 611, 651, 789, 382, 443),
  text = c(
    "Arbois",
    "Montrond",
    "Mont-sur-Monnet",
    "Bonlieu",
    "Chassal",
    "Saint-Claude"
  )
)
climbs <- data.frame(
  x = c(96.2, 134.5, 172.2),
  y = c(783, 540, 925),
  text = c("6.1 km · 4.6%", "7.6 km · 5.2%", "11.7 km · 6.4%")
)
summits <- data.frame(
  x = c(101.44, 138.5, 176.4),
  y = c(1026, 748, 1202),
  text = c(
    "Col de la Joux",
    "Côte de Viry",
    "Montée de la Combe<br>de Laisia Les Molunes"
  )
)

hchart(
  stage,
  "area",
  hcaes(distance, elevation),
  name = "Elevation",
  fillOpacity = 0.25
) |>
  hc_title(text = "Tour de France 2017 · Stage 8") |>
  hc_xAxis(title = list(text = "Distance (km)")) |>
  hc_yAxis(title = list(text = "Elevation (m)")) |>
  hc_tooltip(valueSuffix = " m") |>
  hc_add_annotation(
    labels = data_to_annotation_labels(towns),
    labelOptions = list(
      verticalAlign = "top",
      y = 10,
      backgroundColor = "rgba(255,255,255,0.85)"
    )
  ) |>
  hc_add_annotation(labels = data_to_annotation_labels(summits)) |>
  hc_add_annotation(
    labels = data_to_annotation_labels(climbs),
    labelOptions = list(shape = "connector", align = "right", x = -8, y = -32)
  )
```
