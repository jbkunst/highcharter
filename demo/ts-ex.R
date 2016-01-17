highchart() %>% 
  hc_title(text = "Monthly Airline Passenger Numbers 1949-1960") %>% 
  hc_subtitle(text = "The classic Box and Jenkins airline data") %>% 
  hc_add_series_ts(AirPassengers, name = "passengers") %>%
  hc_tooltip(pointFormat =  '{point.y} passengers')

highchart() %>% 
  hc_title(text = "Monthly Deaths from Lung Diseases in the UK") %>% 
  hc_add_series_ts(fdeaths, name = "Female") %>%
  hc_add_series_ts(mdeaths, name = "Male")
