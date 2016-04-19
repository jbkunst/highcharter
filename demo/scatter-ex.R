highchart() %>% 
  hc_add_series_scatter(cars$speed, cars$dist)

highchart() %>% 
  hc_add_series_scatter(mtcars$wt, mtcars$mpg, mtcars$cyl) %>% 
  hc_chart(zoomType = "xy") %>% 
  hc_title(text = "Motor Trend Car Road Tests") %>% 
  hc_xAxis(title = list(text = "Weight"), minorTickInterval = "auto") %>% 
  hc_yAxis(title = list(text = "Miles/gallon")) %>% 
  hc_tooltip(headerFormat = "<b>{series.name} cylinders</b><br>",
             pointFormat = "{point.x} (lb/1000), {point.y} (miles/gallon)")

highchart() %>% 
  hc_add_series_scatter(mtcars$wt, mtcars$mpg, car = rownames(mtcars), 
                        hp = mtcars$hp, gear = mtcars$gear) %>% 
  hc_chart(zoomType = "xy") %>% 
  hc_title(text = "Motor Trend Car Road Tests") %>% 
  hc_xAxis(title = list(text = "Weight"), minorTickInterval = "auto") %>% 
  hc_yAxis(title = list(text = "Miles/gallon")) %>% 
  hc_tooltip(pointFormat = "<b>{point.car}</b><br/>
                            Weight: {point.x} lb/1000<br/>
                            MPG: {point.y}<br/>
                            Horsepower: {point.hp}<br/>
                            Forward gears: {point.gear}")
