#' ---
#' title: false
#' author: false
#' date: false
#' output:
#'   html_document:
#'     code_folding: hide
#' ---

#+ include=FALSE
rm(list = ls())
knitr::opts_chunk$set(message = FALSE, warning = FALSE)
library("highcharter")
library("purrr")
library("htmltools")

#' <style>.main-container { max-width: none}</style>
#' 
#' # {.tabset .tabset-fade .tabset-pills}
#' 
#' ## Leaflet
library("leaflet")
library("rvest")
library("stringr")

maps <- read_html("http://www.geonames.org/AU/largest-cities-in-australia.html") %>% 
  html_table(fill = TRUE) %>% 
  .[[2]] %>% 
  head(9) %>% 
  by_row(function(x){
    coords <- str_split(x[[4]], "/") %>% 
      unlist() %>% 
      str_trim() %>% 
      as.numeric()
    leaflet() %>%
      addTiles() %>% 
      addMarkers(lng=coords[2], lat=coords[1], popup=x[[2]])
  }) %>% 
  .[[".out"]]
  
hw_grid(maps, rowheight = 200, ncol = 3)  


#' ## dygraphs
library("dygraphs")
tss <- list(AirPassengers, co2, USAccDeaths, LakeHuron,
            mdeaths, ldeaths, cbind(mdeaths, ldeaths))

dycharts <- map(tss, dygraph)

hw_grid(dycharts, rowheight = 150, ncol = 3)

#' ## metricsgraphics
library("metricsgraphics")

mgcharts <- lapply(1:10, function(x) {
  mjs_plot(rbeta(10000, x, x)) %>%
    mjs_histogram(bar_margin = 2) %>%
    mjs_labs(x_label = sprintf("Plot %d", x))
})

hw_grid(mgcharts, rowheight = 200)


#' ## highcharter
data(diamonds, package = "ggplot2")
diamonds <- diamonds[-6]

map(names(diamonds), function(x){
  diamonds[[x]] %>% 
    hchart(showInLegend = FALSE) %>% 
    hc_add_theme(hc_theme_smpl()) %>% 
    hc_title(text = x) %>% 
    hc_yAxis(title = list(text = ""))
  }) %>% 
  hw_grid(rowheight = 225, ncol = 3)  %>% browsable()


#' ## highcharter map
#' 

data(worldgeojson, package = "highcharter")

set.seed(1203)
ids <- sample(seq(123), size = 16)
map(ids, function(x){
  wrld <- worldgeojson
  wrld$features <- wrld$features[x]
  
  highchart(type = "map") %>% 
    hc_add_serie(data = wrld, type = "map", color = "red", showInLegend = FALSE) %>% 
    hc_title(text = wrld$features[[1]]$properties$name) %>% 
    hc_add_theme(hc_theme_smpl())
  }) %>% 
  hw_grid(rowheight = 155, ncol = 4)  %>% browsable()

#' ## Multiples htmlwidgets
#' 

pal <- colorQuantile("YlOrRd", NULL, n = 8)
data(orstationc)

c1 <- dygraph(nhtemp, main = "New Haven Temperatures") %>% 
  dyRangeSelector(dateWindow = c("1920-01-01", "1960-01-01"))

c2 <- highcharts_demo()

c5 <- mjs_plot(mtcars, x=wt, y=mpg) %>%
  mjs_point(color_accessor=carb, size_accessor=carb) %>%
  mjs_labs(x="Weight of Car", y="Miles per Gallon")

library(d3heatmap)
c6 <- d3heatmap(mtcars, scale="column", colors="Blues")

lst <- list(
  c1,
  c2,
  c5,
  c6
)

hw_grid(lst, rowheight = 300)  %>% browsable()
