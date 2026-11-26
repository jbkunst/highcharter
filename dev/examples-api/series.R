# Fictional orders: distinguish a forecast with a shared color and a dashed line.
highchart() |>
  hc_title(text = "Cafe orders: observed and forecast") |>
  hc_xAxis(categories = month.abb[1:6]) |>
  hc_yAxis(title = list(text = "Orders")) |>
  hc_series(
    list(
      name = "Observed",
      color = "#0072B2",
      data = c(120, 150, 180, 160)
    ),
    list(
      name = "Forecast",
      color = "#0072B2",
      dashStyle = "Dash",
      pointStart = 3,
      data = c(160, 190, 210)
    )
  )
