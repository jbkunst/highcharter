# Mark the boundary between the two halves of the year without obscuring the data.
highcharts_demo() |>
  hc_xAxis(
    plotLines = list(list(
      value = 5.5,
      color = "#526472",
      width = 2,
      dashStyle = "Dash",
      label = list(text = "Second half of the year")
    ))
  )

# Give each series its own horizontal scale.
highchart() |>
  hc_title(text = "Monthly and weekly cafe orders") |>
  hc_yAxis(title = list(text = "Orders")) |>
  hc_xAxis(
    list(id = "month", title = list(text = "Month")),
    list(id = "week", title = list(text = "Week"), opposite = TRUE)
  ) |>
  hc_add_series(
    data = c(7, 5, 8),
    pointStart = 1,
    name = "Monthly",
    xAxis = "month"
  ) |>
  hc_add_series(
    data = c(3, 6, 4, 5),
    pointStart = 1,
    name = "Weekly",
    xAxis = "week"
  )
