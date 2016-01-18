library("highcharter")
sessionInfo()

data(diamonds, package = "ggplot2")
head(diamonds)

highchart() %>% 
  hc_chart(zoomType = "xy") %>% 
  hc_yAxis(min = min(diamonds$price),
           max = max(diamonds$price)) %>% 
  hc_add_series_scatter(diamonds$carat, diamonds$price) %>% 
  hc_exporting(enabled = TRUE)


head(diamonds)

diamonds <- dplyr::sample_n(diamonds, 800)

highchart() %>% 
  hc_chart(zoomType = "xy") %>% 
  hc_yAxis(min = min(diamonds$price),
           max = max(diamonds$price)) %>% 
  hc_add_series_scatter(diamonds$carat, diamonds$price, color = diamonds$color) %>% 
  hc_exporting(enabled = TRUE)
