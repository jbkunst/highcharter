#' ---
#' layout: post
#' toc: true
#' ---
#+echo=FALSE
rm(list = ls())
library("highcharter")
knitr::opts_chunk$set(message = FALSE, warning = FALSE)

#'
#' ## `hchart` function
#' 
#' This generic function can chart various R objects on the fly.
#' The resulting chart is a highchart object
#' so you can keep modifying with the implmented API
#' 
#' Some implemented classes are: numeric, histogram, character,
#' factor, ts, mts, xts (and OHLC), forecast, acf, dist.
#' 

#' ### Numeric & Histograms
data(diamonds, package = "ggplot2")

hchart(diamonds$price, color = "#B71C1C", name = "Price") %>% 
  hc_title(text = "Histogram") %>% 
  hc_subtitle(text = "You can zoom me")


x <- hist(c(rnorm(500), rnorm(500, 6, 2)), plot = FALSE)

hchart(x, color = "gray")

#' ### Character & Factor
hchart(diamonds$cut)

hchart(as.character(diamonds$cut), type = "pie")

#' ### Time Series
x <- LakeHuron
hchart(x)

#' ### Seasonal Decomposition of Time Series by Loess

x <- stl(log(AirPassengers), "per")

hchart(x)

#' ### Forecast package
library("forecast")

x <- forecast(ets(USAccDeaths), h = 48, level = 95)

hchart(x)

#' ### `xts` from quantmod package
library("quantmod")

x <- getSymbols("USD/JPY", src = "oanda", auto.assign = FALSE)

hchart(x)

#' ### `xts ohlc` objects

#+eval=FALSE 
x <- getSymbols("YHOO", auto.assign = FALSE)

hchart(x)

hchart(x, type = "ohlc")

#' ### Autocovariance & Autocorrelation
x <- acf(diff(AirPassengers), plot = FALSE)

hchart(x) %>%
  hc_title(text = "This is an ACF chart")

#' ### Multivariate Time series
x <- cbind(mdeaths, fdeaths)

hchart(x)

#' ### Distance matrix 
x <- dist(mtcars[order(mtcars$hp),][1:20, ])

hchart(x)
