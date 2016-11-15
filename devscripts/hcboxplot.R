library(tidyverse)
options(highcharter.theme = hc_theme_smpl())

data(mpg, package = "ggplot2")
data(diamonds, package = "ggplot2")

diamonds <- sample_n(diamonds, 1000)

get_box_values <- function(x = rt(1000, df = 10)){ 
  
  boxplot.stats(x)$stats %>% 
    t() %>% 
    as.data.frame() %>% 
    setNames(c("low", "q1", "median", "q3", "high"))
  
}

get_outliers_values <- function(x = rt(1000, df = 10)) {
  boxplot.stats(x)$out
}

df <- data_frame(
  x = diamonds$price,
  g1 = 0,
  g2 = "NA"
)

df <- data_frame(
  x = mpg$hwy,
  g1 = NA,
  g2 = mpg$class
)

df <- data_frame(
  x = mpg$hwy,
  g1 = mpg$cyl,
  g2 = NA
)

df <- data_frame(
  x = diamonds$price,
  g1 = diamonds$cut,
  g2 = diamonds$color
)

series_box <- df %>%
  group_by(g1, g2) %>%  
  do(data = get_box_values(.$x)) %>% 
  unnest() %>% 
  group_by(g2) %>% 
  do(data = list_parse(rename(select(., -g2), name = g1))) %>% 
  rename(name = g2) %>% 
  mutate(type = "boxplot",
         id = str_to_id(as.character(name)))


series_out <- df %>% 
  group_by(g1, g2) %>%  
  do(data = get_outliers_values(.$x)) %>% 
  unnest() %>% 
  group_by(g2) %>% 
  do(data = list_parse(select(., name = g1, y = data))) %>% 
  rename(name = g2) %>% 
  mutate(type = "scatter",
         linkedTo = str_to_id(as.character(name)))

colors <- colorize(seq(1, nrow(series_box)))
colors <- hex_to_rgba(colors, alpha = 0.75)

highchart() %>% 
  hc_chart(type = "bar") %>% 
  hc_colors(colors) %>% 
  hc_xAxis(type = "category") %>% 
  hc_plotOptions(series = list(
    marker = list(
      symbol = "circle"
    )
  )) %>% 
  hc_add_series_list(list_parse(series_box)) %>% 
  hc_add_series_list(list_parse(series_out))




