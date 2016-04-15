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
#' <div id ="toc"></div>
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

#' ### Character & Factor
hchart(diamonds$cut)


#' ### Time Series
hchart(LakeHuron)

#' ### Seasonal Decomposition of Time Series by Loess

x <- stl(log(AirPassengers), "per")

hchart(x)

#' ### Forecast package
library("forecast")

x <- forecast(ets(USAccDeaths), h = 48, level = 95)

hchart(x)


#' ### igraph 

library("igraph")
library("RColorBrewer")

net <- barabasi.game(50)

wc <- cluster_walktrap(net)

V(net)$label <- 1:50
V(net)$page_rank <- round(page.rank(net)$vector, 2)
V(net)$betweenness <- round(betweenness(net), 2)
V(net)$degree <- degree(net)
V(net)$size <- V(net)$degree
V(net)$comm <- membership(wc)
V(net)$color <- brewer.pal(length(unique(membership(wc))), "Accent")[membership(wc)]

hchart(net, layout = layout_with_fr)


#' ### `xts` from quantmod package
library("quantmod")

x <- getSymbols("USD/JPY", src = "oanda", auto.assign = FALSE)

hchart(x)

#' ### `xts ohlc` objects

#+eval=FALSE 
# x <- getSymbols("YHOO", auto.assign = FALSE)

# hchart(x)

#' ### Autocovariance & Autocorrelation
x <- acf(diff(AirPassengers), plot = FALSE)

hchart(x)

#' ### Multivariate Time series
x <- cbind(mdeaths, fdeaths)

hchart(x)

#' ### Distance matrix 
#' 
mtcars2 <- mtcars[1:20, ]
x <- dist(mtcars2)

hchart(x)

#' ### Dendrogram
x <- mtcars2 %>% dist() %>% hclust() %>% as.dendrogram()

hchart(x) %>%
  hc_chart(type = "bar") %>% 
  hc_xAxis(tickLength = 0)

#' ### Phylo
library("ape")

x <- mtcars %>% dist() %>% hclust() %>% as.phylo()

set.seed(10)
hchart(x)

