highchart() %>%
  hc_add_series(data = sample(1:12)) %>% 
  hc_add_series(data = sample(1:12) + 10) %>% 
  hc_tooltip(
    crosshairs = TRUE,
    borderWidth = 5,
    sort = TRUE,
    table = TRUE
    ) 

