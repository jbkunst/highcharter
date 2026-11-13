peak <- which.max(citytemp$tokyo)

# Highcharts numbers categories from zero, so August is at x = 7.
highcharts_demo() |>
  hc_annotations(list(labels = list(list(
    point = list(xAxis = 0, yAxis = 0, x = peak - 1L, y = citytemp$tokyo[peak]),
    format = "Tokyo in August: {y:.1f} \u00b0C",
    y = 24
  ))))
