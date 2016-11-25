rm(list = ls())
suppressPackageStartupMessages(library(highcharter))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(purrr))

options(highcharter.theme = hc_theme_smpl())

hc <- highchart()
... <- NULL

hc_add_series_boxplot <- function(hc, x, by = NULL, outliers = TRUE, ...) {
  
  if (is.null(by)) {
    by <- "value"
  } else {
    stopifnot(length(x) == length(by))
  }
  
  df <- data_frame(value = x, by = by) %>% 
    group_by(by) %>% 
    do(data = boxplot.stats(.$value))
  
  bxps <- map(df$data, "stats")
  
  hc <- hc %>%
    hc_xAxis(categories = df$by) %>% 
    hc_add_series(data = bxps, type = "boxplot", ...)
  
  if (outliers) {
    outs <- map2_df(seq(nrow(df)), df$data, function(x, y){
      if (length(y$out) > 0)
        d <- data_frame(x = x - 1, y = y$out)
      else
        d <- data_frame()
      d
    })
    
    if (nrow(outs) > 0) {
      hc <- hc %>%
        hc_add_series_df(
          data = outs, name = "outliers", type = "scatter",linkedTo = ":previous",
          marker = list(...),
          tooltip = list(
            headerFormat = "<span>{point.key}</span><br/>",
            # pointFormat = "Observation: {point.y}"
            pointFormat = "<span style='color:{point.color}'></span> Outlier: <b>{point.y}</b><br/>"
            ),
          ...
          )
    }
      
    
  }
  
  hc
  
}

# I think its better use a more autoexplained name
hc_add_series_whisker <- hc_add_series_boxplot

highchart() %>% 
  hc_add_series_boxplot(x = iris$Sepal.Length, by = iris$Species,
                        name = "length", color = "red",
                        fillColor = "transparent", lineColor = "red",  lineWidth = 1)

# support omitted `by` option
hc_add_series_boxplot(hc = highchart(), x = iris$Sepal.Length) 


library(diamonds, package = "ggplot2")
head(diamonds)


highchart() %>% 
  hc_add_series_boxplot(diamonds$x, diamonds$color, name = "X", color = "#2980b9") 

highchart() %>% 
  hc_add_series_boxplot(diamonds$x, diamonds$color, name = "X", color = "red") %>% 
  hc_plotOptions(scatter = list(marker = list(fillColor = "transparent", lineWidth = 1, lineColor = "red")))
  
  
# here y remove outliers because the use the SAME x coordinates
highchart() %>% 
  hc_add_series_boxplot(diamonds$x, diamonds$color, outliers = FALSE, name = "x") %>%
  hc_add_series_boxplot(diamonds$y, diamonds$color, outliers = FALSE, name = "y")

highchart() %>% 
  hc_add_series_boxplot(x = diamonds$x, by = diamonds$color, name = "x") %>%
  hc_add_series_boxplot(diamonds$y, diamonds$color, name = "y") %>% 
  hc_add_series_boxplot(diamonds$z, diamonds$color, name = "z") 
