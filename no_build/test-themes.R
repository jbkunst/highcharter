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
  colors = c('#3498db', '#2ecc71', '#f1c40f', '#f39c12','#9b59b6', '#c0392b',
             '#1abc9c', '#d35400', '#bdc3c7', '#34495e', '#7f8c8d', '#16a085',
             '#27ae60', '#e74c3c', '#8e44ad','#2980b9', '#95a5a6', '#2c3e50'),
  chart = list(
    backgroundColor = list(
      linearGradient = c(0, 0, 500, 500),
      stops = list(
        list(0, '#fff'),
        list(1, '#fff')
      )
    )
  ),
  title = list(
    style = list(
      color = '#333333',
      fontFamily = 'Press Start 2P'
    )
  ),
  subtitle = list(
    style = list(
      color = '#666666',
      fontFamily = 'Yanone Kaffeesatz'
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



