# At 450 px the legend is hidden. At 950 px it appears on the right.
highcharts_demo() |>
  hc_responsive(rules = list(
    list(condition = list(maxWidth = 500),
         chartOptions = list(legend = list(enabled = FALSE))),
    list(condition = list(minWidth = 900),
         chartOptions = list(legend = list(align = "right", verticalAlign = "middle",
                                           layout = "vertical")))
  ))
