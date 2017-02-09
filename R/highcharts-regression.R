library(ggplot2)
library(highcharter)
library(dplyr)

data(mpg, diamonds, package = "ggplot2")

hchart(mpg, "point", hcaes(displ, hwy, group = drv), regression = TRUE) %>% 
  hc_colors(c("#d35400", "#2980b9", "#2ecc71"))


library(quantmod)
x <- getSymbols("GOOG", auto.assign=FALSE)

hchart(x, regression = TRUE, 
       regressionSettings = list(type = "loess", loessSmooth = 30)) 

highchart() %>%
  hc_add_series(data = list_parse2(cars), type = "scatter", regression = TRUE,
                regressionSettings = list(type = "loess", loessSmooth = 2))

hchart(cars, "point", hcaes(speed), regression = TRUE,
       regressionSettings = list(type = "loess", loessSmooth = 0.5)) 


ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  geom_smooth()


lm(hwy ~ displ, data = mpg)

hchart(mpg, "point", hcaes(displ, hwy), regression = TRUE,
       regressionSettings = list(type = "polynomial", order = 5, hideInLegend = TRUE))
         

d <- sample_n(diamonds, 500)
d
hchart(d, "point", hcaes(carat, price, group = cut),
       color = "transparent",
       regression = TRUE,
       regressionSettings = list(type = "polynomial", order = 5, hideInLegend = TRUE))

         
       
ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  geom_smooth(method = "lm")
