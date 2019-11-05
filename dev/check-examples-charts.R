library(tidyverse)
library(rvest)
library(highcharter)


# data --------------------------------------------------------------------
chart_types <- read_html("https://api.highcharts.com/highcharts/plotOptions") %>% 
  html_nodes(".title") %>% 
  html_text("href") %>% 
  str_trim() %>% 
  str_remove(":") %>% 
  setdiff("plotOptions")


# check examples ----------------------------------------------------------
chart_types_with_examples <- dir("dev/examples-charts/", full.names = TRUE)

chart_types_with_examples

map(chart_types_with_examples, function(x){
  message(x)
  source(x, echo = FALSE, encoding = "utf-8")
  })


# charts with no examples
chart_types_with_examples %>% 
  basename() %>% 
  str_remove(".R$") %>% 
  setdiff(chart_types, .) %>% 
  str_c("\t - ", ., "\n") %>% 
  message("Chart with no examples (", length(.), "):\n", .)

