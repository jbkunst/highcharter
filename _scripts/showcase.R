#' ---
#' layout: post
#' ---
#+echo=FALSE
rm(list = ls())
library("highcharter")
knitr::opts_chunk$set(echo = FALSE, warning = FALSE)

printhc <- function(x) {
  try(hc <- readRDS(sprintf("_showcase/%s.rds", x)))
  try(hc <- readRDS(sprintf("../_showcase/%s.rds", x)))
  hc
}

#'
#' ## Showcase
#' 
#' <div id ="toc"></div>
#'

#'
#' ### The Impact of Vaccines
#' 
#' From [WSJ graphic: Battling Infectious Diseases in the 20th Century: 
#' The Impact of Vaccines](http://graphics.wsj.com/infectious-diseases-and-vaccines/),
#' [Randy Olson's python notebook](https://github.com/rhiever/Data-Analysis-and-Machine-Learning-Projects/blob/master/revisiting-vaccine-visualizations/Revisiting%20the%20vaccine%20visualizations.ipynb) and 
#' [Benjamin L. Moore's post](https://github.com/blmoore/blogR/blob/master/R/measles_incidence_heatmap.R).
#' 
#' Code [here](https://github.com/jbkunst/r-posts/tree/master/042-infectious-diseases-and-vaccines)
#'  
hc <- printhc("impact-vaccines")
hc$height <- 700
hc %>% hc_subtitle(text = "")

#' 
#' ### Pokemon types treemap
#' 
#' source: http://jkunst.com/r/pokemon-visualize-em-all/
#' 
hctm <- printhc("hctmpkmn")
hctm$x$hc_opts$series[[1]]$levels <- list(
  list(
    level = 1, dataLabels = list(enabled = TRUE)
  ),
  list(
    level = 2, dataLabels = list(enabled = FALSE)
  )
)
hctm

#'
#' ### Weathers Radials
#' 
#' From [here](http://bl.ocks.org/bricedev/458a01917183d98dff3c) and 
#' replicated in http://jkunst.com/r/how-to-weather-radials/
#'       
hc <- printhc("weatherradial")
hc %>% hc_title(text = "")


# #'
# #' ### Phone size evolution
# #' 
# #' source: http://jkunst.com/r/bythmusters-mobile-phone-evolution/
# #' 
# printhc("hcphones")



