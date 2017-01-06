library(tidyverse)
options(highcharter.theme = hc_theme_smpl())

data("diamonds", package = "ggplot2")
diamonds2 <- diamonds %>% 
  sample_n(1000) %>% 
  filter(color %in% c("H", "J", "E"))


hcboxplot <- function(x = NULL, var = NULL, var2 = NULL, outliers = TRUE, ...) {
  
  stopifnot(!is.null(x))
  
  if (is.null(var))
    var <- NA
  if (is.null(var2))
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
    # rename(name = g2) %>% 
    mutate(type = "boxplot",
           id = str_to_id(as.character(g2)))
  
  if (length(list(...)) > 0)
    series_box <- add_arg_to_df(series_box, ...)
  
  series_out <- df %>% 
    group_by(g1, g2) %>%  
    do(data = get_outliers_values(.$x)) %>% 
    unnest() %>% 
    group_by(g2) %>% 
    do(data = list_parse(select(., name = g1, y = data))) %>% 
    # rename(name = g2) %>% 
    mutate(type = "scatter",
           linkedTo = str_to_id(as.character(g2)))
  
  if (length(list(...)) > 0)
    series_out <- add_arg_to_df(series_out, ...)
  
  if (!has_name(list(...), "color")) {
    colors <- colorize(seq(1, nrow(series_box)))
    colors <- hex_to_rgba(colors, alpha = 0.75)  
  }
  
  if (!has_name(list(...), "name")) {
    series_box <- rename_(series_box, "name" = "g2")
    series_out <- rename_(series_out, "name" = "g2")
  }
  
  
  hc <- highchart() %>% 
    hc_chart(type = "bar") %>% 
    # hc_colors(colors) %>% 
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


hcboxplot(diamonds2$price)
hcboxplot(diamonds2$price, var = diamonds2$cut)
hcboxplot(diamonds2$price, var = diamonds2$cut, var2 = diamonds2$color)

hcboxplot(diamonds2$price, outliers = FALSE)
hcboxplot(diamonds2$price, var = diamonds2$cut, outliers = FALSE)
hcboxplot(diamonds2$price, var = diamonds2$cut, var2 = diamonds2$color, outliers = FALSE)

hcboxplot(x = iris$Sepal.Length, var = iris$Species, color = "red")


hcboxplot(diamonds2$price, var = diamonds2$cut, var2 = diamonds2$color, outliers = FALSE,
          color = c("red", "pink", "darkred"))
