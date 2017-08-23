#+include=FALSE
knitr::opts_chunk$set(message = FALSE, warning = FALSE)
#+
library(tidyverse)
library(highcharter)

data(citytemp)
citytemp$int <- seq_len(12L)

citytemp2 <- citytemp %>% 
  select(-new_york, -london) %>% 
  gather(city, temp, berlin, tokyo)

head(citytemp2)

#' # Dataframe with x as integer
hc1 <- highchart() %>% 
  hc_xAxis(categories = citytemp$int) %>%
  hc_add_series(citytemp2, "line",  hcaes(x = int, y = temp, group = city))
hc1

#' This look weird! Why? Because you are adding a categories and a using numeric
#' value in the data. 
#' 
hc1$x$hc_opts$xAxis

#' Look the data
hc1$x$hc_opts$series[[1]]$data %>% head(1)

#' `int` is copied to the `x` value so x is numeric! so due javascript is 0-based 
#' the number 1 match the second value in the categories. You'll want avoid this mix.
#' 
#' # Dataframe with x as character
#' 
hc2 <- highchart() %>% 
  hc_xAxis(categories = citytemp$int) %>%
  hc_add_series(citytemp2, "line",  hcaes(x = as.character(int), y = temp, group = city)) 
hc2

#' This look as expected. This is the same result as:
hchart(citytemp2, "line",  hcaes(x = as.character(int), y = temp, group = city)) %>% 
  hc_xAxis(title = list(text = NULL))
#' Internally `hchart` with categorical `x` add  `hc_xAxis(categories = )`

hc2$x$hc_opts$xAxis

#' Look the data, now `x` doesn't exists because `hc_add_series.data.frame` 
#' change the `as.character(int)` value to `name` to match the categories
hc2$x$hc_opts$series[[1]]$data %>% head(1)

#' # Vector with x as integer
#' 
hc3 <- highchart() %>% 
  hc_xAxis(categories = citytemp$int) %>%
  hc_add_series(name = "berlin", data = citytemp$berlin) %>% 
  hc_add_series(name = "tokyo", data = citytemp$tokyo) 
hc3

#' The result is expected due the data don't have structure so the value
#' are showed in order.
hc3$x$hc_opts$xAxis
hc3$x$hc_opts$series[[1]]

#' The next chart start at 0 due javascript is 0-based.
highchart() %>% 
  hc_add_series(name = "berlin", data = citytemp$berlin)

#' But you can do:
highchart() %>% 
  hc_add_series(name = "berlin", data = citytemp$berlin, pointStart = 1)

#' Which is same as `hc5` (see below).
#' 
#' # hchart with x as character
#' 
hc4 <- hchart(citytemp2, "line",  hcaes(x = as.character(int), y = temp, group = city))
hc4
hc4$x$hc_opts$xAxis
hc4$x$hc_opts$series[[1]]$data %>% head(1)

#' As we said, same as `hc2`
#' 
#' # hchart with x as integer
#' 
hc5 <- hchart(citytemp2, "line",  hcaes(x = int, y = temp, group = city))
hc5

#' This is the expected result due `x` is integer so you don't need to use
#' `hc_xAxis(categories = )`
hc5$x$hc_opts$xAxis
hc5$x$hc_opts$series[[1]]$data %>% head(1)

#' As we said, same as:
highchart() %>% 
  hc_add_series(name = "berlin", data = citytemp$berlin, pointStart = 1)

highchart() %>% 
  hc_add_series(citytemp2, "line", hcaes(x = int, y = temp, group = city)) 

