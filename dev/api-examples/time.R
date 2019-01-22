hc <- highchart() %>% 
  hc_add_series(
    data = c(29.9, 71.5, 106.4, 129.2, 144.0, 176.0, 135.6, 148.5, 216.4, 194.1, 95.6, 54.4),
    pointStart = JS("Date.UTC(2017, 0, 1)"),
    pointInterval = 36e5
  ) %>% 
  hc_xAxis(
    type = "datetime"
  )

hc %>% 
  hc_title(text = "Berlin Time") %>% 
  hc_time(timezone = "Europe/Berlin")

hc %>% 
  hc_title(text = "New York Time") %>% 
  hc_time(timezone = "America/New_York")
