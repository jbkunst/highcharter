passengers <- as.numeric(window(
  AirPassengers,
  start = c(1949, 1),
  end = c(1949, 12)
))
low <- which.min(passengers)
point <- function(month, value) {
  list(xAxis = 0, yAxis = 0, x = month - 1L, y = value)
}

highchart() |>
  hc_title(text = "International air passengers, 1949") |>
  hc_subtitle(text = "The orange diamond marks the lowest monthly total.") |>
  hc_xAxis(categories = month.abb) |>
  hc_yAxis(title = list(text = "Passengers (thousands)")) |>
  hc_add_series(
    data = passengers,
    type = "line",
    name = "Passengers",
    color = "#47475C",
    marker = list(enabled = FALSE),
    showInLegend = FALSE
  ) |>
  hc_defs(
    diamond = list(
      tagName = "marker",
      attributes = list(
        id = "diamond",
        markerWidth = 10,
        markerHeight = 10,
        refX = 5,
        refY = 5,
        orient = "0"
      ),
      children = list(list(
        tagName = "path",
        attributes = list(d = "M 5 1 L 9 5 L 5 9 L 1 5 Z")
      ))
    )
  ) |>
  hc_annotations(list(
    shapes = list(list(
      type = "path",
      points = list(
        point(low - 3L, passengers[low] + 5),
        point(low, passengers[low])
      ),
      stroke = "#B44816",
      strokeWidth = 2,
      fill = "none",
      markerEnd = "diamond"
    ))
  ))
