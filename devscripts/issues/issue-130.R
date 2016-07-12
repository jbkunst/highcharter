rm(list = ls())
library("highcharter")
suppressPackageStartupMessages(library("dplyr"))

options(highcharter.theme = hc_theme_smpl())

#' # hc_add_series_list

data(diamonds, package = "ggplot2")

series <- diamonds %>% 
  sample_n(500) %>% 
  group_by(name = cut) %>% 
  do(data = list_parse2(data.frame(x = .$price, y = .$carat))) %>% 
  list_parse()

str(series, max.level = 2)

head(series[[1]]$data, 3)

highchart() %>% 
  hc_chart(type = "scatter") %>% 
  hc_add_series_list(series)

#' # hc_add_series_df_tidy

dat <- data.frame(id = c(1,2,3,4,5,6),
                  grp = c("A","A","B","B","C","C"),
                  value = c(10,13,9,15,11,16))

dat

highchart() %>% 
  hc_chart(type = "line") %>% 
  hc_add_series_df_tidy(data = dat, group = grp, values = value)
