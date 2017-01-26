library(highcharter)
library(dplyr)
options(highcharter.theme = hc_theme_smpl())
data("iris")
iris <- tbl_df(iris)
glimpse(iris)

#' # version 1 
# version 1 ---------------------------------------------------------------
highchart() %>% 
  hc_add_series(iris, "scatter", hcaes(x = Petal.Length, y = Sepal.Length),
                name = "Sepal.Length", yAxis = 0) %>% 
  hc_add_series(iris, "scatter", hcaes(x = Petal.Length, y = Sepal.Width),
                name = "Sepal.Width", yAxis = 1) %>% 
  hc_yAxis_multiples(
   list(title = list(text = "Sepal.Length")),
   list(title = list(text = "Sepal.Width"), opposite = TRUE)
  )

#' # version 2  
# version2 ----------------------------------------------------------------
library(tidyr)

iris2 <- iris %>% 
  select(Petal.Length, Sepal.Length, Sepal.Width) %>% 
  gather(Sepal, value, -Petal.Length) 
  

iris2

hchart(iris2, "scatter", hcaes(x = Petal.Length, y = value, group = Sepal),
       yAxis = c(0, 1))  %>% 
  hc_yAxis_multiples(
    list(title = list(text = "Sepal.Length")),
    list(title = list(text = "Sepal.Width"), opposite = TRUE)
  )
  
#' # version  3
# version 3 ---------------------------------------------------------------

seriesiris <- iris2 %>% 
  group_by(name = Sepal) %>% 
  do(data = list_parse2(data.frame(.$Petal.Length, .$value))) %>% 
  ungroup() %>% 
  mutate(yAxis = c(0, 1))

seriesiris

highchart() %>% 
  hc_chart(type = "scatter") %>% 
  hc_add_series_list(seriesiris)  %>% 
  hc_yAxis_multiples(
    list(title = list(text = "Sepal.Length")),
    list(title = list(text = "Sepal.Width"), opposite = TRUE)
  )




