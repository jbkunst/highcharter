hc <- highchart(type = "stock") %>% 
  hc_add_series(AirPassengers)

hc

hc %>% 
  hc_rangeSelector(enabled = FALSE)

hc %>% 
  hc_rangeSelector(
    verticalAlign = "bottom",
    selected = 4
    )
