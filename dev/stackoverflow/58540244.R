library(highcharter)

highchart() %>%
  hc_chart(type = 'organization') %>%
  hc_add_series(
    data = list(
      list(from = 'Brazil', to = 'Portugal', weight = 5),
      list(from = 'Brazil', to = 'Spain', weight = 2),
      list(from = 'Poland', to = 'England', weight = 2))
  )
