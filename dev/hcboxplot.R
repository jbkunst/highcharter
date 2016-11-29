library(tidyverse)
options(highcharter.theme = hc_theme_smpl())

data(mpg, package = "ggplot2")

diamonds <- sample_n(diamonds, 1000)

hcboxplot <- function(x = NULL, var = NULL, var2 = NULL, outliers = TRUE, ...) {
  
  stopifnot(!is.null(x))
  
  if(is.null(var))
    var <- NA
  if(is.null(var2))
    var2 <- NA
  
  df <- data_frame(x, g1 = var, g2 = var2)
  
  get_box_values <- function(x = rt(1000, df = 10)){ 
    
    boxplot.stats(x)$stats %>% 
      t() %>% 
      as.data.frame() %>% 
      setNames(c("low", "q1", "median", "q3", "high"))
    
  }
  
  get_outliers_values <- function(x = rt(1000, df = 10)) {
    boxplot.stats(x)$out
  }
  
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
  
  hc <- highchart() %>% 
    hc_chart(type = "bar") %>% 
    hc_colors(colors) %>% 
    hc_xAxis(type = "category") %>% 
    hc_plotOptions(series = list(
      marker = list(
        symbol = "circle"
      )
    )) 
  
  hc <- hc_add_series_list(hc, list_parse(series_box))
  
  if(is.na(var2) || is.na(var)) {
    hc <- hc %>% 
      hc_xAxis(categories = "") %>% 
      hc_plotOptions(series = list(showInLegend = FALSE))
  }
    
  
  if(outliers)
    hc <- hc_add_series_list(hc, list_parse(series_out))
  
  hc
}
diamonds

hcboxplot(diamonds$price)
hcboxplot(diamonds$price, var = diamonds$cut)
hcboxplot(diamonds$price, var = diamonds$cut, var2 = diamonds$color)

hcboxplot(diamonds$price, outliers = FALSE)
hcboxplot(diamonds$price, var = diamonds$cut, outliers = FALSE)
hcboxplot(diamonds$price, var = diamonds$cut, var2 = diamonds$color, outliers = FALSE)
