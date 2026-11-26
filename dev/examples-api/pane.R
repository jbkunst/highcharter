# A half-circle leaves room below the dial for the value and units.
highchart() |>
  hc_chart(type = "gauge") |>
  hc_title(text = "Storage used") |>
  hc_pane(
    startAngle = -90,
    endAngle = 90,
    center = c("50%", "75%"),
    size = "110%"
  ) |>
  hc_yAxis(
    min = 0,
    max = 100,
    tickInterval = 25,
    title = list(text = "% used"),
    plotBands = list(
      list(from = 0, to = 70, color = "#009E73"),
      list(from = 70, to = 90, color = "#E69F00"),
      list(from = 90, to = 100, color = "#D55E00")
    )
  ) |>
  hc_add_series(name = "Storage", data = 72, tooltip = list(valueSuffix = "%"))
