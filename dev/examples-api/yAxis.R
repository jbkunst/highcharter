# Highlight a temperature interval so readers can compare when cities enter it.
highcharts_demo() |>
  hc_yAxis(
    plotBands = list(list(
      from = 18,
      to = 24,
      color = "rgba(53, 183, 121, 0.12)",
      label = list(text = "18\u201324 \u00b0C", align = "left")
    ))
  )

# Independent scales for two series in the same plotting area.
highchart() |>
  hc_title(text = "Cafe sales and profit margin") |>
  hc_xAxis(categories = month.abb[1:3]) |>
  hc_yAxis(
    list(id = "sales", title = list(text = "Sales ($)")),
    list(id = "margin", title = list(text = "Margin (%)"), opposite = TRUE)
  ) |>
  hc_add_series(
    data = c(100, 125, 120),
    type = "column",
    name = "Sales",
    yAxis = "sales",
    tooltip = list(valuePrefix = "$")
  ) |>
  hc_add_series(
    data = c(15, 18, 16),
    name = "Margin",
    yAxis = "margin",
    tooltip = list(valueSuffix = "%")
  ) |>
  hc_tooltip(shared = TRUE, table = TRUE)
