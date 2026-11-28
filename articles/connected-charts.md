# Connected charts

[`hc_connect()`](https://jkunst.com/highcharter/reference/hc_connect.md)
is a highcharter helper for linking separate widgets in an HTML
document. Give the widgets the same `group` name, then choose the
interactions each one shares with `sync`. Each widget keeps its own
data, axes and legend. This also works for widgets rendered in separate
Quarto HTML chunks on the same page; Shiny is not required.

## Start with two time series

The built-in
[`datasets::mdeaths`](https://rdrr.io/r/datasets/UKLungDeaths.html) and
[`datasets::fdeaths`](https://rdrr.io/r/datasets/UKLungDeaths.html)
series contain 72 months of deaths from bronchitis, emphysema and asthma
in the United Kingdom, from 1974 to 1979. We will compare the monthly
counts with their first differences.

The two line charts share tooltips, crosshairs and X zoom. Set
`hc_chart(zooming = list(type = "x"))` to enable drag-to-zoom: including
`"zoom"` in `sync` connects the ranges but does not enable the gesture
itself.

``` r

men <- datasets::mdeaths
women <- datasets::fdeaths

first_difference <- function(x) {
  stats::ts(
    c(NA_real_, diff(as.numeric(x))),
    start = stats::start(x),
    frequency = stats::frequency(x)
  )
}

# Reuse explicit IDs and colors across the different views.
add_groups <- function(hc, men, women) {
  hc |>
    hc_add_series(
      data = men,
      id = "men",
      name = "Men",
      color = "#0072B2"
    ) |>
    hc_add_series(
      data = women,
      id = "women",
      name = "Women",
      color = "#D55E00"
    )
}

base <- highchart() |>
  hc_chart(type = "line", zooming = list(type = "x")) |>
  hc_xAxis(type = "datetime", crosshair = TRUE) |>
  hc_tooltip(shared = TRUE, table = TRUE, valueDecimals = 0) |>
  hc_plotOptions(
    series = list(
      animation = FALSE,
      marker = list(enabled = FALSE)
    )
  ) |>
  hc_legend(enabled = TRUE) |>
  hc_connect("lung-deaths", sync = c("hover", "zoom", "legend")) |>
  hc_size(height = 320)

levels <- base |>
  hc_title(text = "Monthly deaths from lung diseases") |>
  hc_subtitle(text = "United Kingdom, 1974-1979. Drag to zoom") |>
  hc_yAxis(title = list(text = "Deaths")) |>
  add_groups(men, women)

changes <- base |>
  hc_title(text = "Change from the previous month") |>
  hc_yAxis(
    title = list(text = "Difference in deaths"),
    plotLines = list(list(value = 0, color = "#999999", width = 1))
  ) |>
  add_groups(first_difference(men), first_difference(women))
```

Hover matches points by their exact numeric X value, including
timestamps. The leading `NA` preserves the first month in the difference
series. That month has no difference to display, so hovering over it
clears the other chart’s tooltip and crosshair. With category axes, use
the same category order.

## Add a pie and columns

Each chart has its own legend. Clicking a legend item toggles matching
items in the other charts: series in the line and column charts, and
individual points in the pie. The explicit `id` values establish these
matches; names and colors alone do not connect them.

The two summary charts share only `"legend"`. Their totals have no
monthly X axis, so they do not participate in hover or zoom
synchronization.

``` r

total_men <- sum(as.numeric(men))
total_women <- sum(as.numeric(women))

pie <- highchart() |>
  hc_chart(type = "pie") |>
  hc_title(text = "Share of all deaths") |>
  hc_subtitle(text = "Click a slice to select it") |>
  hc_add_series(
    name = "Deaths",
    data = list(
      list(id = "men", name = "Men", y = total_men, color = "#0072B2"),
      list(id = "women", name = "Women", y = total_women, color = "#D55E00")
    )
  ) |>
  hc_plotOptions(
    pie = list(
      showInLegend = TRUE,
      allowPointSelect = TRUE,
      cursor = "pointer",
      dataLabels = list(
        enabled = TRUE,
        format = "{point.name}: {point.percentage:.1f}%"
      )
    )
  ) |>
  hc_tooltip(valueDecimals = 0) |>
  hc_legend(enabled = TRUE) |>
  hc_connect("lung-deaths", sync = "legend") |>
  hc_size(height = 340)

columns <- highchart() |>
  hc_chart(type = "column") |>
  hc_title(text = "Total deaths") |>
  hc_subtitle(text = "Accumulated from 1974 to 1979") |>
  hc_xAxis(categories = "Entire period") |>
  hc_yAxis(title = list(text = "Deaths"), min = 0) |>
  add_groups(total_men, total_women) |>
  hc_tooltip(shared = TRUE, table = TRUE, valueDecimals = 0) |>
  hc_legend(enabled = TRUE) |>
  hc_connect("lung-deaths", sync = "legend") |>
  hc_size(height = 340)
```

Selecting a pie slice with `allowPointSelect = TRUE` is a local
interaction.
[`hc_connect()`](https://jkunst.com/highcharter/reference/hc_connect.md)
synchronizes legend visibility, not point selection.

## Arrange four connected charts

Place each line chart on its own row, followed by the pie and columns
side by side: a **1 / 1 / 2** layout. The bottom row wraps on narrow
screens. The layout uses `htmltools`; the connections come from the
shared group, independently of where the widgets are placed on the page.

``` r

htmltools::tagList(
  levels,
  changes,
  htmltools::div(
    style = "display: flex; flex-wrap: wrap; gap: 16px;",
    htmltools::div(
      style = "flex: 1 1 300px; min-width: 0;",
      pie
    ),
    htmltools::div(
      style = "flex: 1 1 300px; min-width: 0;",
      columns
    )
  )
)
```

Try these interactions in the charts above:

- Hover over a month in either line chart to compare counts and changes.
- Drag horizontally in either line chart to zoom both, then use either
  reset button to restore the full period.
- Click **Men** or **Women** in any legend to hide or show that group in
  all four charts. The remaining pie slice fills the pie when the other
  group is hidden.
- Click a pie slice to select it locally, without changing the other
  charts.
- Narrow the browser window to stack the two summary charts.

For another independent set of charts on the same page, choose a
different `group` name. See
[`hc_connect()`](https://jkunst.com/highcharter/reference/hc_connect.md)
for the complete argument reference.
