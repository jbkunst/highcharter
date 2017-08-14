rm(list = ls())
library(highcharter)
library(dplyr)
library(purrr)

set.seed(1234)


n <- 50
s <- 20

sequences <- map(1:n, function(i){
  map(1:s, function(x) list(lat = runif(1)*10, lon = runif(1)*100, z = runif(1)))
})

sequences <- map(1:n, function(i){
  map(1:s, function(x) list(z = runif(1)))
})


df <- data_frame(
  lat = runif(n)*180*2 - 180,
  lon = runif(n)*180*2 - 180,
  z = runif(n),
  color = colorize(z),
  sequence = sequences
)

hcmap() %>% 
  hc_add_series(data = df, type = "mapbubble",
                minSize = 0, maxSize = 30) %>% 
  hc_motion(enabled = TRUE, series = 1, labels = 1:n,
            loop = TRUE, autoPlay = TRUE, 
            updateInterval = 1000, magnet = list(step =  1)) %>% 
  hc_plotOptions(series = list(showInLegend = FALSE))


sequences <- map(1:n, function(i){
  map(1:s, function(x) list(runif(1)*10, runif(1)*100, runif(1)))
  # runif(s)
})

df <- data_frame(
  x = runif(n),
  y = runif(n),
  z = runif(n),
  color = colorize(runif(n)),
  sequence = sequences
)


highchart() %>% 
  hc_add_series(data = df, type = "bubble",
                minSize = 0, maxSize = 30) %>% 
  hc_motion(enabled = TRUE, series = 0, labels = 1:n,
            loop = TRUE, autoPlay = TRUE, 
            updateInterval = 1000, magnet = list(step =  1)) %>% 
  hc_plotOptions(series = list(showInLegend = FALSE))

