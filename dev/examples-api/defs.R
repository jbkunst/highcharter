# Define a diamond marker and use it at the end of an annotation.
point <- function(x, y) list(xAxis = 0, yAxis = 0, x = x, y = y)
highchart() |>
  hc_add_series(data = c(2, 4, 3)) |>
  hc_defs(diamond = list(
    tagName = "marker",
    attributes = list(id = "diamond", markerWidth = 8, markerHeight = 8,
                      refX = 4, refY = 4),
    children = list(list(tagName = "path", attributes = list(d = "M 0 4 L 4 0 L 8 4 L 4 8 Z")))
  )) |>
  hc_annotations(list(shapes = list(list(type = "path", stroke = "#3066BE",
    markerEnd = "diamond", points = list(point(0, 2), point(1, 4))))))
