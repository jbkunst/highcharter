library(tidyverse)
library(highcharter)

highchartProxy("hola") %>% 
  hcpxy_add_series(data = 1:10, name = "name", type = "area")

highchartProxy("hola") %>% 
  hcpxy_add_series(data = ts(1:3))

highchartProxy("hola") %>% 
  hcpxy_add_series(data = iris, "scatter", hcaes(x =  Sepal.Length, y = Sepal.Width))

highchartProxy("hola") %>% 
  hcpxy_add_series(data = iris, "scatter", hcaes(x =  Sepal.Length, y = Sepal.Width, group = Species))
