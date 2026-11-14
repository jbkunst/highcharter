highchart() |>
  hc_add_series(
    data = c(7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6),
    type = "spline"
    ) |> 
  hc_xAxis(
    title = list(text = "x Axis at top"),
    alternateGridColor = "#FDFFD5",
    opposite = TRUE,
    plotLines = list(
      list(
        label = list(text = "This is a plotLine"),
        color = "#FF0000",
        width = 2,
        value = 5.5
        )
      )
    )

# Give each series its own horizontal scale.
highchart() |>
  hc_xAxis(list(id = "month", title = list(text = "Month")),
           list(id = "week", title = list(text = "Week"), opposite = TRUE)) |>
  hc_add_series(data = c(7, 5, 8), pointStart = 1, name = "Monthly", xAxis = "month") |>
  hc_add_series(data = c(3, 6, 4, 5), pointStart = 1, name = "Weekly", xAxis = "week")
