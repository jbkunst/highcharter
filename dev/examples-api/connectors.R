day <- datetime_to_timestamp(as.Date("2025-01-01") + 0:3)
highchart(type = "gantt") |>
  hc_add_series(type = "gantt", data = list(
    list(id = "design", name = "Design", start = day[1], end = day[2]),
    list(name = "Build", start = day[2], end = day[4], dependency = "design")
  )) |>
  hc_connectors(type = "straight", lineColor = "#3066BE", lineWidth = 3)
