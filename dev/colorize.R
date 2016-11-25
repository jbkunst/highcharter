rm(list = ls())

x <- mtcars$gear
x <- mtcars$disp

colorize <- function(x, colors = viridis::viridis(10)) {
  
  nuniques <- length(unique(x))
  palcols <- grDevices::colorRampPalette(colors)(nuniques)
  
  if (!is.numeric(x) | nuniques < 10) {
    
    y <- as.numeric(as.factor(x))
    xcols <- palcols[y]
    
  } else {
  
    ecum <- ecdf(x)
    xcols <- palcols[ceiling(nuniques*ecum(x))]
    
  }
  
  xcols
  
}



colors <- c("#084594", "#2171B5", "#4292C6", "#6BAED6", "#9ECAE1", "#C6DBEF", "#DEEBF7", "#F7FBFF")

options(highcharter.theme = hc_theme_flatdark())

mtcarts2 <- mtcars %>% mutate(x = wt, y = mpg, z = x) 
  
mtcarts2 %>% 
  mutate(color = colorize(gear, colors)) %>% 
  hc_add_series_df(highchart(), ., type = "bubble")

mtcarts2 %>% 
  mutate(color = colorize(gear)) %>% 
  hc_add_series_df(highchart(), ., type = "bubble")

mtcarts2 %>% 
  mutate(color = colorize(mpg, colors)) %>% 
  hc_add_series_df(highchart(), ., type = "bubble")

mtcarts2 %>% 
  mutate(color = colorize(mpg)) %>% 
  hc_add_series_df(highchart(), ., type = "bubble")


htmltools::browsable(
  highcharter::hw_grid(
    mtcarts2 %>% 
      mutate(color = colorize(gear, colors)) %>% 
      hc_add_series_df(highchart(), ., type = "bubble"),
    
    mtcarts2 %>% 
      mutate(color = colorize(gear)) %>% 
      hc_add_series_df(highchart(), ., type = "bubble"),
    
    mtcarts2 %>% 
      mutate(color = colorize(mpg, colors)) %>% 
      hc_add_series_df(highchart(), ., type = "bubble"),
    
    mtcarts2 %>% 
      mutate(color = colorize(mpg)) %>% 
      hc_add_series_df(highchart(), ., type = "bubble"),
    rowheight = 300
  )
)


