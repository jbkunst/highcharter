## ---- bus-capacity
seats <- data.frame(
  status = c("Occupied", "Available"),
  count = c(7L, 3L),
  color = c("#146b75", "#abb9c3")
)

## ---- count-seats
seat_chart <- highchart() |>
  hc_title(text = "Ten bus seats") |>
  hc_add_series(
    seats, "item", hcaes(name = status, y = count, color = color),
    name = "Seats", showInLegend = TRUE, rows = 2,
    marker = list(symbol = "square")
  ) |>
  hc_legend(labelFormat = "{name}: {y}")
seat_chart

## ---- fill-bus
bus_path <- paste(
  "M 8 0 H 40 Q 48 0 48 8 V 43 Q 48 47 44 47 V 54 H 37 V 48",
  "H 11 V 54 H 4 V 47 Q 0 47 0 43 V 8 Q 0 0 8 0 Z",
  "M 6 9 V 27 H 42 V 9 Z",
  "M 6 36 V 40 H 12 V 36 Z M 36 36 V 40 H 42 V 36 Z"
)
bus_chart <- highchart() |>
  hc_chart(type = "pictorial") |>
  hc_title(text = "Bus occupancy") |>
  hc_xAxis(categories = list("Bus"), visible = FALSE) |>
  hc_yAxis(min = 0, max = sum(seats$count), reversedStacks = FALSE, visible = FALSE) |>
  hc_plotOptions(pictorial = list(stacking = "normal",
                                  paths = list(list(definition = bus_path)))) |>
  hc_add_series(name = seats$status[1], data = seats$count[1], color = seats$color[1]) |>
  hc_add_series(name = seats$status[2], data = seats$count[2], color = seats$color[2]) |>
  hc_tooltip(pointFormat = "{series.name}: <b>{point.y} seats</b>")
bus_chart
