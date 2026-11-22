# hchart Function

[`hchart()`](https://jkunst.com/highcharter/reference/hchart.md) chooses
a chart based on the class of its input. Find your object type below,
then use the `hc_*` functions to customize the resulting chart.

## Data objects

### Data frames

For a data frame, choose the chart type with `type` and map columns to
`x` and `y` with
[`hcaes()`](https://jkunst.com/highcharter/reference/hcaes.md). In the
scatter plot below, `group = species` creates a separate series for each
penguin species.

``` r

library(highcharter)
library(dplyr)

data(penguins, package = "palmerpenguins")
data(diamonds, economics_long, package = "ggplot2")

hchart(
  penguins,
  "scatter",
  hcaes(x = body_mass_g, y = flipper_length_mm, group = species)
)
```

``` r

penguins2 <- penguins |>
  count(species, island) |>
  glimpse()
```

    ## Rows: 5
    ## Columns: 3
    ## $ species <fct> Adelie, Adelie, Adelie, Chinstrap, Gentoo
    ## $ island  <fct> Biscoe, Dream, Torgersen, Dream, Biscoe
    ## $ n       <int> 44, 56, 52, 68, 124

``` r

hchart(penguins2, "column", hcaes(x = island, y = n, group = species))
```

Check automatically if the x column is date class:

``` r

economics_long2 <- economics_long |>
  filter(variable %in% c("pop", "uempmed", "unemploy"))

hchart(economics_long2, "line", hcaes(x = date, y = value01, group = variable))
```

### Numeric & histograms

``` r

set.seed(123)
x <- rgamma(1000, shape = 2)
hchart(x)
```

### Densities

``` r

hchart(density(x), type = "area", color = "#B71C1C", name = "Gamma sample")
```

### Empirical cumulative distributions

The height at each x-value is the fraction of the sample at or below it.
For example, 626 of the 1,000 observations are at or below 2.

``` r

hchart(ecdf(x), name = "Gamma sample")
```

### Precomputed histograms

Pass a histogram object when you want R to choose the breaks before
charting. The bin boundaries and counts are preserved.

``` r

hchart(hist(x, breaks = 30, plot = FALSE), name = "Gamma sample")
```

### Character & factor

``` r

x <- diamonds$cut
hchart(x, type = "column")
```

### Frequency tables

Each cell shows how many cars have that combination of cylinders and
gears. Zero counts remain visible in the heatmap. For a one-way table,
see [Category
order](https://jkunst.com/highcharter/articles/highcharts-api.html#category-order).

``` r

hchart(table(Cylinders = mtcars$cyl, Gears = mtcars$gear))
```

### Matrix

The `volcano` matrix has 87 rows and 61 columns. Both views use the same
distance for one step across a column or down a row.

``` r

data(volcano)

volcano_layout <- function(chart) {
  chart |>
    hc_chart(margin = c(0, 96, 0, 0)) |>
    hc_legend(layout = "vertical", align = "right", verticalAlign = "middle")
}
```

``` r

# fmt: skip
volcano_colors <- c("#000004", "#56106E", "#BB3754", "#F98C0A", "#FCFFA4")

hchart(volcano) |>
  volcano_layout() |>
  hc_colorAxis(stops = color_stops(colors = volcano_colors))
```

The elevations in `volcano` are whole metres. Place contour lines half a
metre above each multiple of ten so that flat areas keep their band
color. Blue, yellow and coral mark increasing elevation, as in the
[Highcharts contour
demo](https://www.highcharts.com/docs/chart-and-series-types/contour).
This view requires WebGPU in the browser.

``` r

hchart(
  volcano,
  type = "contour",
  contourInterval = 10,
  contourOffset = 0.5,
  lineColor = "#888888"
) |>
  volcano_layout() |>
  hc_colorAxis(
    min = min(volcano),
    max = max(volcano),
    startOnTick = FALSE,
    endOnTick = FALSE,
    stops = color_stops(3, c("#447CFF", "#F5FF66", "#FF5E4F")),
    labels = list(format = "{value} m")
  )
```

### Distance matrix

``` r

mtcars2 <- mtcars[1:20, ]
x <- dist(mtcars2)
hchart(x)
```

### Correlation matrix

``` r

hchart(cor(mtcars))
```

### Principal components

Each point represents one state. Axis titles give the share of variance
explained by each component. Hover over a point to see the state’s name.

Use `loadings = TRUE` to show how the variables relate to the chosen
components. Use `scale = 0` for the raw observation scores.

``` r

fit <- prcomp(USArrests, scale. = TRUE)
hchart(fit, choices = c(1, 3), loadings = TRUE)
```

### GeoJSON

Manchester Airport is a single GeoJSON FeatureCollection. Its 26
polygons outline terminals and aprons, 254 lines trace runways and
taxiways, and 136 points mark gates and other airfield features. Pass
the collection to
[`hchart()`](https://jkunst.com/highcharter/reference/hchart.md) to draw
the three layers. Hover over a gate to see its reference, such as **Gate
21**.

``` r

library(geojsonio)

path <- system.file(
  "extdata",
  "manchester-airport.geojson",
  package = "highcharter"
)
airport <- geojson_list(as.json(path))
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

The [Maps
vignette](https://jkunst.com/highcharter/articles/maps.html#laguna-seca)
shows how to style these geometry types separately on a racing circuit.

## Time series

``` r

hchart(LakeHuron, name = "Level") |>
  hc_title(text = "Level of Lake Huron 1875–1972")
```

### Multivariate time series

``` r

x <- cbind(mdeaths, fdeaths)
hchart(x)
```

### Seasonal decomposition

The four panels share a time axis and show the observed series,
seasonality, trend and remainder. Gaps at the ends of the trend are part
of the fitted decomposition.

``` r

hchart(stats::decompose(AirPassengers, type = "multiplicative"))
```

### Seasonal decomposition of time series by loess

``` r

x <- stl(log(AirPassengers), "per")
hchart(x)
```

### Seasonal adjustment with X-13

With the optional `seasonal` package installed, compare the original
monthly series with the X-13-adjusted series on the same scale. Labels
mark the outliers reported by the model at the adjusted value, as in
`plot(fit)` (e.g., AO for an additive outlier or LS for a level shift).

``` r

fit <- seasonal::seas(AirPassengers)
hchart(fit)
```

### Forecast package

The legend distinguishes the observed series from the forecast.
Prediction intervals are linked to the forecast series. Supply `name` to
label the subject; the chart adds the observed/forecast suffixes.

``` r

library(forecast)

x <- forecast(ets(USAccDeaths), h = 48, level = 95)
hchart(x)
```

### Exponential-smoothing components

An `ets` model shows its observed values and fitted level, slope or
seasonal states in aligned panels. To show future values instead, pass
the model to
[`forecast()`](https://generics.r-lib.org/reference/forecast.html) and
chart the resulting forecast object.

``` r

hchart(forecast::ets(AirPassengers))
```

### Autocovariance & autocorrelation

``` r

changes <- diff(AirPassengers)
hchart(acf(changes, plot = FALSE))
```

``` r

hchart(pacf(changes, plot = FALSE))
```

With two monthly series, the diagonal panels show each series’
autocorrelation. The other two panels show their cross-correlation at
positive and negative lags. The horizontal axes use years, the time unit
of these monthly series.

``` r

hchart(acf(cbind(mdeaths, fdeaths), lag.max = 12, plot = FALSE))
```

### Quantmod package

The highstock extension is used to chart `xts` and `xts ohlc` classes
from the quantmod package.

``` r

library(quantmod)

data(sample_matrix, package = "xts")
x <- xts::as.xts(sample_matrix)

hchart(x)
```

## Fitted models

### Random forests

Can a car’s length, height and curb weight distinguish two-door models
from four-door models? Hover at a tree count to compare the overall
out-of-bag error with the error for each class.

``` r

data("imports85", package = "randomForest")
set.seed(42)
forest <- randomForest::randomForest(
  numOfDoors ~ length + height + curbWeight,
  data = imports85,
  na.action = na.omit,
  ntree = 150
)
hchart(forest)
```

### Cross-validated regularization

Each point shows mean cross-validated prediction error. Its whiskers
extend one standard error in either direction. The two vertical lines
identify the best-scoring lambda and the more regularized
one-standard-error choice. Move the horizontal crosshair to an interval
endpoint to see which other intervals reach that value.

``` r

x <- as.matrix(mtcars[c("disp", "hp", "wt", "qsec")])
set.seed(42)
folds <- sample(rep_len(1:5, nrow(x)))
cv <- glmnet::cv.glmnet(x, mtcars$mpg, foldid = folds)
hchart(cv)
```

### Survival package

Survival models can be charted.

``` r

library(survival)

data(cancer, package = "survival")

lung <- dplyr::mutate(cancer, sex = ifelse(sex == 1, "Male", "Female"))

fit <- survfit(Surv(time, status) ~ sex, data = cancer)

hchart(fit, ranges = TRUE)
```

## Decision trees

Node area shows how many training observations reach each split or leaf.
For classification, select a donut or a bar to see the class
proportions. For regression, the node color follows the mean response.
Hover over a node for its summary, or click a split to fold the subtree.

``` r

fit <- partykit::ctree(Species ~ Petal.Length + Petal.Width, data = iris)
hchart(fit, node_shape = "bar") |>
  hc_colors(c("#087B71", "#AD591D", "#7655A0"))
```

### Boosted trees

Select a tree by its one-based index. Hover over a split for its gain
and the direction taken by missing values, or over a leaf for its margin
contribution. Marker size follows cover.

``` r

x <- as.matrix(iris[c("Sepal.Length", "Sepal.Width", "Petal.Length")])
d <- xgboost::xgb.DMatrix(x, label = iris$Petal.Width)
fit <- xgboost::xgb.train(
  list(objective = "reg:squarederror", max_depth = 2L, nthread = 1L),
  d,
  nrounds = 3L,
  verbose = 0
)
hchart(fit, tree = 2)
```

## Dendrograms and phylogenies

### Cluster dendrograms

The vertical position of each join gives the merge height. Hover over it
for the number of observations. Both `hchart(fit)` and
`hchart(as.dendrogram(fit))` use the same layout.

``` r

states <- scale(USArrests[
  c(
    "Alabama",
    "Alaska",
    "Arizona",
    "California",
    "Florida",
    "Georgia",
    "Illinois",
    "Maine",
    "Oregon",
    "Vermont"
  ),
])
fit <- hclust(dist(states), method = "average")
hchart(fit)
```

### Phylogenies

In the fan layout, radial distance measures branch length from the root.
With no lengths, each edge counts as one step. Use
`layout = "rectangular"` for a side-by-side reading of tip labels.

``` r

data("bird.families", package = "ape")
families <- c(
  "Rheidae",
  "Casuariidae",
  "Struthionidae",
  "Phasianidae",
  "Numididae",
  "Odontophoridae",
  "Anhimidae",
  "Dendrocygnidae",
  "Anatidae"
)
birds <- ape::keep.tip(bird.families, families)
hchart(birds)
```

## Networks

``` r

library(igraph)
N <- 40

net <- sample_gnp(N, p = 2 / N)
wc <- cluster_walktrap(net)

V(net)$label <- seq(N)
V(net)$name <- paste("I'm #", seq(N))
V(net)$page_rank <- round(page_rank(net)$vector, 2)
V(net)$betweenness <- round(betweenness(net), 2)
V(net)$degree <- degree(net)
V(net)$size <- V(net)$degree
V(net)$comm <- as.vector(membership(wc))
V(net)$color <- colorize(membership(wc))

hchart(net, layout = layout_with_fr)
```
