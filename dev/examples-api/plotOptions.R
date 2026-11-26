# Keep monthly observations visible and make overlapping lines easier to follow.
highcharts_demo() |>
  hc_plotOptions(
    line = list(
      lineWidth = 3,
      marker = list(
        enabled = TRUE,
        radius = 4,
        fillColor = "white",
        lineWidth = 2
      )
    )
  )
