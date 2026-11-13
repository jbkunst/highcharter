# Run with the feature branch of highcharter installed.
library(highcharter)
library(htmltools)

values <- c(6, 4, 3, 2)
dates <- as.numeric(as.Date("2025-01-01") + 0:9) * 86400000
prices <- list_parse2(data.frame(dates, price = c(8, 9, 7, 6, 7, 9, 10, 9, 11, 12)))
scores <- c(52, 58, 61, 63, 64, 65, 65, 67, 68, 70, 74, 79)

line <- highchart() |>
  hc_add_series(name = "Observations", data = values)
stock <- highchart(type = "stock") |>
  hc_add_series(name = "Price", data = prices)
regions <- list(
  list(name = "West", path = "M 0 0 L 0 10 L 10 10 L 10 0 Z", value = 2),
  list(name = "East", path = "M 10 0 L 10 10 L 20 10 L 20 0 Z", value = 4)
)
map <- highchart(type = "map") |>
  hc_add_series(type = "map", name = "Regions", data = regions)
columns <- highchart() |>
  hc_chart(options3d = list(enabled = TRUE, alpha = 15, beta = 20)) |>
  hc_add_series(type = "column", data = values)
variwide <- highchart() |>
  hc_xAxis(type = "category") |>
  hc_add_series(type = "variwide", data = list(list("A", 2, 5), list("B", 3, 2)))
pareto <- highchart() |>
  hc_yAxis_multiples(list(title = list(text = "Count")), list(max = 100, opposite = TRUE)) |>
  hc_add_series(type = "column", id = "counts", data = values) |>
  hc_add_series(type = "pareto", baseSeries = "counts", yAxis = 1)
bellcurve <- highchart() |>
  hc_add_series(type = "scatter", id = "scores", data = scores, visible = FALSE) |>
  hc_add_series(type = "bellcurve", baseSeries = "scores", name = "Distribution")
pattern <- list(pattern = list(path = "M 0 0 L 8 8", width = 8, height = 8, color = "#347a81"))
extension <- highchart() |>
  hc_add_series(type = "column", data = values, color = pattern)

charts <- list(
  "Line · keyboard navigation" = line, "Stock" = stock, "Map" = map, "3D" = columns,
  "Variwide" = variwide, "Pareto" = pareto, "Bell curve" = bellcurve,
  "Optional module · pattern fill" = extension
)
cards <- Map(function(chart, title) {
  div(style = "min-width: 0", hc_title(chart, text = title) |> hc_size(height = 300))
}, charts, names(charts))
grid <- div(style = "display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,320px),1fr))",
            unname(cards))
dir.create("preview", showWarnings = FALSE)
save_html(grid, "preview/index.html", libdir = "libs")
if (interactive()) utils::browseURL(normalizePath("preview/index.html"))
