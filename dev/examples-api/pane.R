# The start and end angles give the speedometer a 300-degree sweep.
highchart() |>
  hc_chart(type = "gauge") |>
  hc_title(text = "Speedometer") |>
  hc_pane(startAngle = -150, endAngle = 150) |>
  hc_yAxis(min = 0, max = 200, tickInterval = 40, title = list(text = "km/h")) |>
  hc_add_series(name = "Speed", data = 80, tooltip = list(valueSuffix = " km/h"))
