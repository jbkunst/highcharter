#' ---
#' layout: post
#' ---
#+echo=FALSE
rm(list = ls())
library("highcharter")
knitr::opts_chunk$set(echo=FALSE, warning = FALSE)

printhc <- function(x) {
  try(hc <- readRDS(sprintf("_showcase/%s.rds", x)))
  try(hc <- readRDS(sprintf("../_showcase/%s.rds", x)))
  hc
}

#'
#' ## Showcases
#' 
#' <div id ="toc"></div>
#'

#' 
#' ### Pokemon types treemap
#' 
#' source: http://jkunst.com/r/pokemon-visualize-em-all/
#' 

printhc("hctmpkmn")


#'
#' ### Phone size evolution
#' 
#' source: http://jkunst.com/r/bythmusters-mobile-phone-evolution/
#' 

printhc("hcphones")


