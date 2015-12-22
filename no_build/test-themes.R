library("magrittr")



highchart(debug = TRUE) %>% 
  hc_add_serie_scatter(cars$speed, cars$dist) %>% 
  hc_add_theme(hc_theme_simple())


highchart(debug = TRUE) %>% 
  hc_add_serie_scatter(cars$speed, cars$dist) 
