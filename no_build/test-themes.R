rm(list = ls())
library("magrittr")

hc <- highchart(debug = TRUE) %>% 
  hc_add_serie_scatter(mtcars$wt, mtcars$mpg, mtcars$cyl) %>% 
  hc_chart(zoomType = "xy") %>% 
  hc_title(text = "Motor Trend Car Road Tests") %>% 
  hc_subtitle(text = "Motor Trend Car Road Tests") %>% 
  hc_xAxis(title = list(text = "Weight")) %>% 
  hc_yAxis(title = list(text = "Miles/gallon")) %>% 
  hc_tooltip(headerFormat = "<b>{series.name} cylinders</b><br>",
             pointFormat = "{point.x} (lb/1000), {point.y} (miles/gallon)")

hc

hc %>% hc_add_theme(hc_theme_darkunica())

hc %>% hc_add_theme(hc_theme_gridlight())

hc %>% hc_add_theme(hc_theme_sandsignika())

hc %>% hc_add_theme(hc_theme_chalk())

thm <- hc_theme(
  colors = c('red', 'green', 'blue'),
  chart = list(
    backgroundColor = "#15C0DE"
  ),
  title = list(
    style = list(
      color = '#333333',
      fontFamily = "Erica One"
    )
  ),
  subtitle = list(
    style = list(
      color = '#666666',
      fontFamily = "Shadows Into Light"
    )
  ),
  legend = list(
    itemStyle = list(
      fontFamily = 'Tangerine',
      color = 'black'
    ),
    itemHoverStyle = list(
      color = 'gray'
    )   
  )
)

hc %>% hc_add_theme(thm)


(hc %>% hc_add_theme(hc_theme_sandsignika()))$x$fonts
(hc %>% hc_add_theme(thm))$x$fonts
