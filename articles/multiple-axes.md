# Multiple axes

## Price and carat across nine panels

Compare price (US dollars) against weight (carats) for three cuts and
three colors in
[`ggplot2::diamonds`](https://ggplot2.tidyverse.org/reference/diamonds.html).
Each panel shows a reproducible sample of 100 diamonds. All panels share
the same axis limits.

`hc_gridAxis(3, 3)` creates nine pairs of axes. The top row uses indices
0, 1 and 2, and the next row starts at 3. Each call to
[`hc_add_series()`](https://jkunst.com/highcharter/reference/hc_add_series.md)
sets both `xAxis` and `yAxis` to the intended panel. Reuse the index to
put a second series in that panel.

``` r

library(dplyr)

set.seed(42)
groups <- ggplot2::diamonds |>
  filter(
    cut %in% c("Very Good", "Premium", "Ideal"),
    color %in% c("D", "E", "F")
  ) |>
  group_by(color, cut) |>
  slice_sample(n = 100)

keys <- group_keys(groups)
labels <- paste(keys$cut, "·", keys$color)
max_carat <- ceiling(max(groups$carat))
x_axes <- lapply(labels, function(label) {
  list(min = 0, max = max_carat, title = list(text = label))
})

chart <- highchart(height = 780) |>
  hc_title(text = "Diamond price by carat") |>
  hc_subtitle(
    text = "Columns show cut. Rows show color. Prices in US dollars."
  ) |>
  hc_gridAxis(
    3,
    3,
    xAxis = x_axes,
    yAxis = list(min = 0, max = 20000, tickPositions = c(0, 10000, 20000))
  ) |>
  hc_legend(enabled = FALSE)

rows <- group_split(groups)
for (i in seq_along(rows)) {
  panel <- i - 1L
  chart <- hc_add_series(
    chart,
    rows[[i]],
    "scatter",
    hcaes(x = carat, y = price),
    name = labels[i],
    xAxis = panel,
    yAxis = panel,
    marker = list(radius = 2)
  )
}
chart
```

For a [multivariate
ACF](https://jkunst.com/highcharter/articles/hchart.html#autocovariance-autocorrelation),
[`hchart()`](https://jkunst.com/highcharter/reference/hchart.md) creates
the grid and assigns one series to each panel automatically.
