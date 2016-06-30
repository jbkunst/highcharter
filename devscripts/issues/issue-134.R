library(highcharter)



hc <- highchart() %>% 
  hc_plotOptions(
    series = list(
      boderWidth = 0,
      dataLabels = list(enabled = TRUE)
    )
  ) %>% 
  hc_chart(type = "column") %>% 
  hc_xAxis(type = "category") %>% 
  hc_add_series(
    name = "Things",
    data = list(
      list(name = "Animals", y = 5, drilldown = "animals")
    )
  )

hc 

hc <- hc %>% 
  hc_drilldown(
    series = list(
      list(
        id  = "animals",
        name = "Animals",
        data = list(
          list(name = "Cats", y = 4, drilldown = "cats"),
          list(name = "Dogs", y = 1)
        )
      ),
      list(
        id = "cats",
        data = list(
          list(name = "purr", y = 1),
          list(name = "miau", y = 2)
        )
      )
    )
  )

hc

jsonlite::toJSON(hc$x$hc_opts$series, pretty = TRUE, auto_unbox = TRUE)
jsonlite::toJSON(hc$x$hc_opts$drilldown, pretty = TRUE, auto_unbox = TRUE)

