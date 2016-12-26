highchart() %>% 
  hc_title(text = "Monthly Airline Passenger Numbers 1949-1960") %>% 
  hc_subtitle(text = "The classic Box and Jenkins airline data") %>% 
  hc_xAxis(type = "datetime") %>% 
  hc_add_series(AirPassengers, name = "passengers") %>%
  hc_tooltip(pointFormat =  '{point.y} passengers')

hchart(cbind(fdeaths, mdeaths), separate = FALSE)
