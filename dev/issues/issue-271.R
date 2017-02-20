rm(list = ls())
library(highcharter)
library(tidyverse)
library(broom)
options(highcharter.verbose = TRUE, highcharter.theme = hc_theme_smpl())


hchart(cars, "point", hcaes(speed, dist), regression = TRUE) %>% 
  hc_add_dependency("plugins/highcharts-regression.js")


hchart(cars, "point", hcaes(speed, dist), regression = TRUE,
       regressionSettings = list(type = "loess", loessSmooth = 0.5)) %>% 
  hc_add_dependency("plugins/highcharts-regression.js")

data <- lm(dist ~ speed, data = cars)
class(data)
hc <- highchart() %>% 
  hc_add_series(cars, "point", hcaes(speed, dist))

hc

highcharter:::hc_add_series.forecast

hc_add_series.lm <- function(hc, data, type = "line", color = "#5F83EE", fillOpacity = 0.1, ...) {
  
  if (getOption("highcharter.verbose"))
    message(sprintf("hc_add_series.%s", class(data)))
  
  data2 <- augment(data)
  data2 <- arrange_(data2, .dots = names(data2)[2])
  data2 <- mutate_(data2, .dots = c("x" = names(data2)[2]))
  
  rid <- random_id()
  
  hc %>% 
    hc_add_series(data2, type = type, hcaes_(names(data2)[2], ".fitted"), 
                  id = rid, color = color, ...) %>% 
    hc_add_series(data2, type = "arearange",
                  hcaes_(names(data2)[2], low = ".fitted - .se.fit",
                         high = ".fitted + .se.fit"), color = hex_to_rgba(color, fillOpacity),
                  linkedTo = rid, zIndex = -2, ...)
  
}

hc_add_series.loess <- hc_add_series.lm


highchart() %>% 
  hc_add_series(cars, "point", hcaes(speed, dist)) %>% 
  hc_add_series(lm(dist ~ speed, data = cars), name = "Polinomial Regression")


loessmodel <- loess(dist ~ speed, data = cars, span = 0.5)

highchart() %>%
  hc_add_series(cars, "point", hcaes(speed, dist), name = "Some points") %>% 
  hc_add_series(loessmodel, name = "Loess")


hc %>% 
  hc_add_series(lm(dist ~ speed, data = cars), name = "Regression") %>% 
  hc_add_series(loess(dist ~ speed, data = cars), name = "Loess", color = "green")

hchart(mtcars, "point", hcaes(disp, hp, group = paste("am", am)), regression = TRUE) %>%
  hc_add_dependency("plugins/highcharts-regression.js")
  

