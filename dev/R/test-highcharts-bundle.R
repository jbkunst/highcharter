# Build a local gallery for the Highcharts bundle in a clean R session.
args <- commandArgs(trailingOnly = FALSE)
script_arg <- grep("^--file=", args, value = TRUE)
if (!length(script_arg)) stop("Run this file with Rscript.")
script <- normalizePath(sub("^--file=", "", script_arg[[1]]))
root <- normalizePath(file.path(dirname(script), "..", ".."))

pkgload::load_all(root, quiet = TRUE)
library(highcharter)
library(htmltools)

dates <- as.numeric(as.Date("2025-01-01") + 0:7) * 86400000
common <- data.frame(
  x = 0:7,
  y = c(5, 3, 7, 4, 8, 6, 9, 7),
  z = c(2, 4, 3, 5, 2, 6, 4, 3),
  low = c(3, 1, 5, 2, 6, 4, 7, 5),
  high = c(7, 5, 9, 6, 10, 8, 11, 9),
  xlow = 0:7 - 0.25,
  xhigh = 0:7 + 0.25,
  value = c(5, 3, 7, 4, 8, 6, 9, 7),
  target = c(6, 4, 8, 5, 9, 7, 10, 8),
  direction = seq(0, 315, by = 45),
  name = LETTERS[1:8],
  label = paste("Point", LETTERS[1:8]),
  color = rep(c("#2f7ed8", "#f28f43"), 4),
  stringsAsFactors = FALSE
)

points <- list_parse(common)
ranges <- lapply(seq_len(nrow(common)), function(i) {
  list(x = common$x[i], low = common$low[i], high = common$high[i], name = common$name[i])
})
bubbles <- lapply(seq_len(nrow(common)), function(i) {
  list(x = common$x[i], y = common$y[i], z = common$z[i], name = common$name[i])
})

chart <- function(type, data = points, title = type, ...) {
  highchart() |>
    hc_chart(type = type, ...) |>
    hc_title(text = title) |>
    hc_xAxis(title = list(text = "x")) |>
    hc_yAxis(title = list(text = "y")) |>
    hc_add_series(type = type, data = data, name = title, showInLegend = FALSE)
}

charts <- list()
add_chart <- function(name, value) charts[[name]] <<- hc_size(value, height = 300)

for (type in c(
  "line", "spline", "area", "areaspline", "column", "bar", "scatter",
  "waterfall", "polygon", "dotplot", "streamgraph", "timeline", "lollipop"
)) {
  add_chart(type, chart(type))
}
for (type in c("arearange", "areasplinerange", "columnrange", "errorbar", "dumbbell")) {
  add_chart(type, chart(type, ranges))
}
add_chart("bubble", chart("bubble", bubbles))
add_chart("boxplot", chart("boxplot", lapply(seq_len(nrow(common)), function(i) {
  list(common$x[i], common$low[i] - 1, common$low[i], common$y[i], common$high[i], common$high[i] + 1)
})))
add_chart("columnpyramid", chart("columnpyramid"))
add_chart("packedbubble", chart("packedbubble", lapply(common$y, function(value) list(value = value))))
add_chart("pie", chart("pie", lapply(seq_len(nrow(common)), function(i) list(name = common$name[i], y = common$y[i]))))
add_chart("variablepie", chart("variablepie", lapply(seq_len(nrow(common)), function(i) {
  list(name = common$name[i], y = common$y[i], z = common$z[i])
})))
add_chart("funnel", chart("funnel"))
add_chart("pyramid", chart("pyramid"))
add_chart("funnel3d", chart("funnel3d", title = "funnel3d", options3d = list(enabled = TRUE, alpha = 10)))
add_chart("pyramid3d", chart("pyramid3d", title = "pyramid3d", options3d = list(enabled = TRUE, alpha = 10)))
add_chart("cylinder", chart("cylinder", title = "cylinder", options3d = list(enabled = TRUE, alpha = 15, beta = 15)))
add_chart("variwide", chart("variwide", lapply(seq_len(nrow(common)), function(i) {
  list(x = common$x[i], y = common$y[i], z = common$z[i], name = common$name[i])
})))
add_chart("bullet", chart("bullet", lapply(seq_len(nrow(common)), function(i) {
  list(y = common$y[i], target = common$target[i])
})))
add_chart("windbarb", chart("windbarb", lapply(seq_len(nrow(common)), function(i) {
  list(x = common$x[i], value = common$value[i], direction = common$direction[i])
})))
add_chart("wordcloud", chart("wordcloud", lapply(seq_len(nrow(common)), function(i) {
  list(name = common$name[i], weight = common$value[i])
})))
add_chart("item", chart("item", lapply(seq_len(nrow(common)), function(i) {
  list(name = common$name[i], y = common$value[i])
})))
add_chart("gauge", highchart() |>
  hc_chart(type = "gauge") |>
  hc_title(text = "gauge") |>
  hc_yAxis(min = 0, max = 10) |>
  hc_add_series(type = "gauge", data = list(7), name = "Value"))
add_chart("solidgauge", highchart() |>
  hc_chart(type = "solidgauge") |>
  hc_title(text = "solidgauge") |>
  hc_yAxis(min = 0, max = 10) |>
  hc_add_series(type = "solidgauge", data = list(7), name = "Value"))
add_chart("pictorial", highchart() |>
  hc_chart(type = "pictorial") |>
  hc_title(text = "pictorial") |>
  hc_yAxis(max = 10) |>
  hc_add_series(
    type = "pictorial",
    data = list(7, 5),
    paths = list(list(definition = "M 0 0 L 10 0 L 10 10 L 0 10 Z"))
  ))

matrix_data <- unlist(lapply(0:4, function(x) {
  lapply(0:4, function(y) list(x, y, round(sin(x) + cos(y), 2)))
}), recursive = FALSE)
add_chart("heatmap", chart("heatmap", matrix_data))
add_chart("tilemap", chart("tilemap", matrix_data))
add_chart("contour", chart("contour", matrix_data))

hierarchy <- list(
  list(id = "root", name = "Root"),
  list(id = "a", parent = "root", name = "A", value = 6),
  list(id = "b", parent = "root", name = "B", value = 4),
  list(id = "a1", parent = "a", name = "A1", value = 3),
  list(id = "a2", parent = "a", name = "A2", value = 3)
)
for (type in c("treemap", "sunburst", "treegraph")) {
  add_chart(type, chart(type, hierarchy))
}

links <- list(
  list("A", "B", 5), list("A", "C", 3), list("B", "D", 4),
  list("C", "D", 2), list("D", "A", 1)
)
for (type in c("sankey", "dependencywheel", "organization", "arcdiagram", "networkgraph")) {
  add_chart(type, chart(type, links))
}
add_chart("venn", chart("venn", list(
  list(sets = list("A"), value = 4),
  list(sets = list("B"), value = 3),
  list(sets = list("A", "B"), value = 1)
)))
add_chart("vector", chart("vector", lapply(seq_len(nrow(common)), function(i) {
  list(common$x[i], common$y[i], common$value[i], common$direction[i])
})))
add_chart("xrange", chart("xrange", lapply(0:5, function(i) {
  list(x = dates[i + 1], x2 = dates[i + 2], y = i %% 3, name = LETTERS[i + 1])
})))

scores <- c(52, 58, 61, 63, 64, 65, 67, 68, 70, 74, 79)
add_chart("histogram", highchart() |>
  hc_title(text = "histogram") |>
  hc_add_series(type = "scatter", id = "samples", data = scores, visible = FALSE) |>
  hc_add_series(type = "histogram", baseSeries = "samples"))
add_chart("bellcurve", highchart() |>
  hc_title(text = "bellcurve") |>
  hc_add_series(type = "scatter", id = "samples", data = scores, visible = FALSE) |>
  hc_add_series(type = "bellcurve", baseSeries = "samples"))
add_chart("pareto", highchart() |>
  hc_title(text = "pareto") |>
  hc_yAxis_multiples(list(title = list(text = "Count")), list(max = 100, opposite = TRUE)) |>
  hc_add_series(type = "column", id = "counts", data = common$y) |>
  hc_add_series(type = "pareto", baseSeries = "counts", yAxis = 1))

map_regions <- list(
  list(name = "West", path = "M 0 0 L 0 10 L 10 10 L 10 0 Z", value = 2),
  list(name = "East", path = "M 10 0 L 10 10 L 20 10 L 20 0 Z", value = 4)
)
add_chart("map", highchart(type = "map") |>
  hc_title(text = "map") |>
  hc_add_series(type = "map", data = map_regions))
add_chart("mapline", highchart(type = "map") |>
  hc_title(text = "mapline") |>
  hc_add_series(type = "mapline", data = map_regions))
add_chart("mappoint", highchart(type = "map") |>
  hc_title(text = "mappoint + clustering") |>
  hc_add_series(
    type = "mappoint",
    data = list(
      list(name = "Santiago", lon = -70.67, lat = -33.45),
      list(name = "Valparaiso", lon = -71.62, lat = -33.05)
    ),
    cluster = list(enabled = TRUE)
  ))
add_chart("mapbubble", highchart(type = "map") |>
  hc_title(text = "mapbubble") |>
  hc_add_series(type = "mapbubble", data = list(
    list(name = "Santiago", lon = -70.67, lat = -33.45, z = 7),
    list(name = "Valparaiso", lon = -71.62, lat = -33.05, z = 4)
  )))
add_chart("geoheatmap", highchart(type = "map") |>
  hc_title(text = "geoheatmap") |>
  hc_add_series(type = "geoheatmap", data = list(
    list(lon = -70, lat = -33, value = 7),
    list(lon = -71, lat = -32, value = 4)
  )))
add_chart("tiledwebmap", highchart(
  type = "map",
  hc_opts = list(mapView = list(center = list(lon = -70.67, lat = -33.45), zoom = 4))
  ) |>
  hc_title(text = "tiledwebmap") |>
  hc_add_series(
    type = "tiledwebmap",
    provider = list(type = "OpenStreetMap"),
    name = "OpenStreetMap"
  ))
add_chart("flowmap", highchart(type = "map") |>
  hc_title(text = "flowmap") |>
  hc_add_series(type = "flowmap", data = list(
    list(from = list(lon = -70, lat = -30), to = list(lon = -60, lat = -20), weight = 3),
    list(from = list(lon = -70, lat = -30), to = list(lon = -75, lat = -15), weight = 2)
  )))

ohlc <- lapply(seq_along(dates), function(i) {
  open <- 10 + i
  list(dates[i], open, open + 3, open - 2, open + 1)
})
for (type in c("ohlc", "candlestick", "heikinashi", "hollowcandlestick", "renko", "pointandfigure")) {
  add_chart(type, highchart(type = "stock") |>
    hc_title(text = type) |>
    hc_add_series(type = type, data = ohlc, name = type))
}
hlc <- lapply(seq_along(dates), function(i) {
  open <- 10 + i
  list(dates[i], open + 3, open - 2, open + 1)
})
add_chart("hlc", highchart(type = "stock") |>
  hc_title(text = "hlc") |>
  hc_add_series(type = "hlc", data = hlc, name = "HLC"))
add_chart("flags", highchart(type = "stock") |>
  hc_title(text = "flags") |>
  hc_add_series(type = "line", id = "price", data = Map(list, dates, common$y)) |>
  hc_add_series(type = "flags", onSeries = "price", data = list(
    list(x = dates[3], title = "A", text = "Event A"),
    list(x = dates[6], title = "B", text = "Event B")
  )))
add_chart("gantt", highchart(type = "gantt") |>
  hc_title(text = "gantt") |>
  hc_add_series(type = "gantt", data = list(
    list(name = "Task A", start = dates[1], end = dates[4], y = 0),
    list(name = "Task B", start = dates[3], end = dates[7], y = 1)
  )))
add_chart("Stock Tools", highchartstock() |>
  hc_title(text = "Stock Tools") |>
  hc_add_series(type = "candlestick", id = "price", data = ohlc, name = "Price"))

expected_types <- c(
  "line", "spline", "area", "areaspline", "column", "bar", "scatter", "pie",
  "arearange", "areasplinerange", "boxplot", "bubble", "columnrange",
  "columnpyramid", "errorbar", "gauge", "packedbubble", "polygon", "waterfall",
  "hlc", "ohlc", "candlestick", "flags", "map", "mapline", "mappoint", "mapbubble",
  "item", "funnel", "pyramid", "heatmap", "treemap", "sankey", "dependencywheel",
  "organization", "solidgauge", "streamgraph", "sunburst", "vector", "wordcloud",
  "xrange", "tilemap", "venn", "gantt", "timeline", "bullet", "dumbbell",
  "lollipop", "arcdiagram", "treegraph", "variwide", "pareto", "histogram",
  "bellcurve", "contour", "cylinder", "dotplot", "flowmap", "funnel3d",
  "geoheatmap", "heikinashi", "hollowcandlestick", "networkgraph", "pictorial",
  "pointandfigure", "pyramid3d", "renko", "tiledwebmap", "variablepie", "windbarb"
)

cards <- Map(function(value, name) {
  div(class = "chart-card", tags$h3(name), value)
}, charts, names(charts))

registry_check <- sprintf(
  "window.addEventListener('load', function () {
    var expected = %s;
    var missing = expected.filter(function (type) { return !Highcharts.seriesTypes[type]; });
    var node = document.getElementById('registry-status');
    node.textContent = missing.length ? 'Missing series: ' + missing.join(', ') :
      'All ' + expected.length + ' expected series types are registered.';
    node.className = missing.length ? 'failed' : 'passed';
  });",
  jsonlite::toJSON(expected_types, auto_unbox = TRUE)
)

page <- tagList(
  tags$head(
    tags$meta(charset = "utf-8"),
    tags$title("Highcharter bundle gallery"),
    tags$style(HTML("body{font-family:sans-serif;margin:24px}.gallery{display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,320px),1fr));gap:16px}.chart-card{min-width:0;border:1px solid #ddd;border-radius:8px;padding:8px}.chart-card h3{font-size:14px;margin:4px 8px}.passed{color:#087f23}.failed{color:#b00020}"))
  ),
  tags$h1("Highcharter bundle gallery"),
  tags$p("Common x, y, z, low, high, value, color and label shapes plus specialized series."),
  tags$p(id = "registry-status", "Checking registered series types..."),
  div(class = "gallery", unname(cards)),
  tags$script(HTML(registry_check))
)

output_dir <- file.path(root, "dev", "highcharts-bundle", "preview")
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
save_html(page, file.path(output_dir, "index.html"), libdir = "libs")
message("Wrote ", file.path(output_dir, "index.html"))
