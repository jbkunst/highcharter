library(tidyverse)
library(highcharter)

d <- read_lines("~/g.txt")
d <- str_replace(d, "var mydata = ", "")
d <- str_replace(d, ";$", "")

d <- jsonlite::fromJSON(d, simplifyDataFrame = FALSE)

str(d, max.level = 2)
str(d, max.level = 3)

length(d)
d2 <- map(d, function(x) {
  
  # x <<- x
  # x
  x$sequence <- map(x$sequence, function(y){
    # y <<- y
    # y
    y <- y[c("x", "y")]
    y$z <- runif(1)
    y
    
  })
  
  x
  
})

str(d2)

highchart() %>% 
  hc_add_series(data = d2,  type =  'bar') %>% 
  hc_motion(enabled = TRUE, series = 0,
            updateInterval = 1,
            labels = paste("i", seq_len(length(d2))),
            magnet = list(round =  'floor', step = 0.08)
            
            )
