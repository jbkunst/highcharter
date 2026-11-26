# Keep the city names visible on small screens; use endpoint legends on wide ones.
highcharts_demo() |>
  hc_responsive(
    rules = list(
      list(
        condition = list(maxWidth = 500),
        chartOptions = list(
          legend = list(itemDistance = 12, symbolWidth = 12),
          yAxis = list(
            title = list(text = NULL),
            labels = list(format = "{value}\u00b0C")
          )
        )
      ),
      list(
        condition = list(minWidth = 900),
        chartOptions = list(
          legend = list(
            layout = "proximate",
            align = "right",
            verticalAlign = "top"
          )
        )
      )
    )
  )
