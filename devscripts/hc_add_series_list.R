#' ---
#' ---
#' # Packages & Warnings :/
library("igraph") # convex_hull
library("viridisLite") # colors
library("highcharter")
library("purrr")
library("purrr")
library("dplyr")

#' # Ex 1 
ds <- map(seq(5), function(x){
  list(data = cummean(rnorm(100, 2, 5)), name = x)
})

highchart() %>% 
  hc_plotOptions(series = list(marker = list(enabled = FALSE))) %>% 
  hc_add_series_list(ds)

#' # Ex 2 
n <- 3
set.seed(100)
ds2 <- map(seq(n), function(x){
  xc <- round(rnorm(1, sd = 2), 2)
  yc <- round(rnorm(1, sd = 2), 2)
  dt <- cbind(rnorm(200, xc), rnorm(200, yc))
  dt <- convex_hull(dt)
  dt <- list_parse2(as.data.frame(dt$rescoords))
  list(data = dt, name = sprintf("%s, %s", xc, yc), type = "polygon", id = n)
})

set.seed(100)
ds3 <- map(seq(n), function(x){
  xc <- round(rnorm(1, sd = 2), 2)
  yc <- round(rnorm(1, sd = 2), 2)
  dt <- cbind(rnorm(200, xc), rnorm(200, yc))
  dt <- list_parse2(as.data.frame(dt))
  list(data = dt, name = sprintf("%s, %s", xc, yc), type = "scatter", linkedTo = n)
})

cols <- hex_to_rgba(substr(viridis(n), 0, 7), alpha = 0.5)

highchart() %>% 
  hc_colors(colors = cols) %>% 
  hc_add_series_list(ds2) %>% 
  hc_add_series_list(ds3)


#' # Ex 3 
data("economics_long", package = "ggplot2")
head(economics_long)

ds <- economics_long %>% 
  group_by(variable) %>% 
  do(ds = list(
    data = list_parse2(data.frame(datetime_to_timestamp(.$date), .$value01))
  )) %>% 
  {map2(.$variable, .$ds, function(x, y){
    append(list(name = x), y)
  })}
  
highchart() %>% 
  hc_xAxis(type = "datetime") %>% 
  hc_add_series_list(ds)


