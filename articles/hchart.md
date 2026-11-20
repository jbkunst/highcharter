# hchart Function

This a generic function, this means you can chart various R like
numeric, histograms, character, factor, ts on the fly. The resulting
chart is a highchart object so you can keep modifying with the
implemented API.

## Data Frames

This function works like `qplot`: You pass the data, choose the type of
chart and then define the aesthetics for each variable.

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

## Numeric & Histograms

``` r

x <- diamonds$price
hchart(x)
```

## Densities

``` r

hchart(density(x), type = "area", color = "#B71C1C", name = "Price")
```

## Precomputed histograms

Pass a histogram object when you want R to choose the breaks before
charting. The bin boundaries and counts are preserved.

``` r

hchart(hist(diamonds$price, breaks = 30, plot = FALSE), name = "Diamond prices")
```

## Character & Factor

``` r

x <- diamonds$cut
hchart(x, type = "column")
```

## Time Series

``` r

hchart(LakeHuron, name = "Level") |>
  hc_title(text = "Level of Lake Huron 1875–1972")
```

### Seasonal Decomposition of Time Series by Loess

``` r

x <- stl(log(AirPassengers), "per")
hchart(x)
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

### Multivariate Time series

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

### Seasonal adjustment with X-13

With the optional `seasonal` package installed, compare the original
monthly series with the X-13-adjusted series on the same scale. Labels
mark the outliers reported by the model at the adjusted value, as in
`plot(fit)` (e.g., AO for an additive outlier or LS for a level shift).

``` r

fit <- seasonal::seas(AirPassengers)
hchart(fit)
```

### Autocovariance & Autocorrelation

``` r

changes <- diff(AirPassengers)
hchart(acf(changes, plot = FALSE))
```

``` r

hchart(pacf(changes, plot = FALSE))
```

## Igraph package

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

## Survival Package

Survival models can be charted.

``` r

library(survival)

data(cancer, package = "survival")

lung <- dplyr::mutate(cancer, sex = ifelse(sex == 1, "Male", "Female"))

fit <- survfit(Surv(time, status) ~ sex, data = cancer)

hchart(fit, ranges = TRUE)
```

## Quantmod package

The highstock extension is used to chart `xts` and `xts ohlc` classes
from the quantmod package.

``` r

library(quantmod)

data(sample_matrix, package = "xts")
x <- xts::as.xts(sample_matrix)

hchart(x)
```

## Principal Components

Each point represents one state. Axis titles give the share of variance
explained by each component. Hover over a point to see the state’s name.

Use `loadings = TRUE` to show how the variables relate to the chosen
components. Use `scale = 0` for the raw observation scores.

``` r

fit <- prcomp(USArrests, scale. = TRUE)
hchart(fit, choices = c(1, 3), loadings = TRUE)
```

## Matrix

``` r

data(volcano)

hchart(volcano) |> # changing default color
  hc_colorAxis(
    stops = color_stops(
      colors = c(
        "#000004FF",
        "#56106EFF",
        "#BB3754FF",
        "#F98C0AFF",
        "#FCFFA4FF"
      )
    )
  )
```

## Distance matrix

``` r

mtcars2 <- mtcars[1:20, ]
x <- dist(mtcars2)
hchart(x)
```

## Correlation matrix

``` r

hchart(cor(mtcars))
```

## GeoJSON

[`hchart()`](https://jkunst.com/highcharter/reference/hchart.md) reads
the geometry from a `geo_list` or `geo_json` FeatureCollection from
**geojsonio**. Here the local file contains two district polygons.

``` r

library(geojsonio)

path <- system.file("extdata", "districts.geojson", package = "highcharter")
districts <- geojson_list(as.json(path))
hchart(districts)
```

With a mixed collection, the same call draws polygons, then lines, then
points. The [Maps
vignette](https://jkunst.com/highcharter/articles/maps.html#overlay-geojson-points)
shows a clinic network with all three.
