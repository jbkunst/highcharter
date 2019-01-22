#' ---
#' date: false
#' output:
#'   html_document:
#'     toc: yes
#' ---

#+ message=FALSE, warning=FALSE, echo=FALSE, results=FALSE
library(highcharter)
library(dplyr)
options(highcharter.theme = hc_theme_smpl())

#' ### data.frame
data(mpg, package = "ggplot2")
data(diamonds, package = "ggplot2")

hchart(mpg, "point", hcaes(x = displ, y = hwy))
hchart(mpg, "point", hcaes(x = displ, y = hwy, group = class))

mpgman <- count(mpg, manufacturer)
hchart(mpgman, "bar", hcaes(x = manufacturer, y = n))
hchart(mpgman, "treemap", hcaes(x = manufacturer, value = n))

mpgman2 <- count(mpg, manufacturer, year)
hchart(mpgman2, "bar", hcaes(x = manufacturer, y = n, group = year))

#' ### numeric
hchart(c(rnorm(500), rnorm(500, 6, 2)))

#' ### histogram
hchart(hist(rbeta(300, 0.2, 4), plot = FALSE))

#' ### character
hchart(mpg$manufacturer)

#' ### factor
hchart(diamonds$cut)

#' ### ts
hchart(LakeHuron)

#' ### xts
library(quantmod)
options(download.file.method = "libcurl")

hchart(getSymbols("USD/JPY", src = "oanda", auto.assign = FALSE))

# hchart(getSymbols("YHOO", auto.assign = FALSE))

#' ### forecast
library("forecast")

hchart(forecast(auto.arima(AirPassengers), level = c(95, 80)))

hchart(forecast(ets(USAccDeaths), h = 48, level = 90))

hchart(forecast(Arima(WWWusage, c(3,1,0))))

#' ### mforecast
# hchart(forecast(ets(cbind(M = mdeaths, F = fdeaths))))

#' ### acf
hchart(acf(diff(AirPassengers), plot = FALSE))

#' ### mts
hchart(cbind(mdeaths, fdeaths))

#' ### lst
hchart(stl(co2, "per"))

#' ### ets
hchart(ets(mdeaths))

#' ### matrix
data("volcano")

hchart(volcano)

hchart(cor(mtcars))

#' ### dist
hchart(dist(mtcars[1:20, ]))

#' ### igraph
library("igraph")

net <- barabasi.game(40)

wc <- cluster_walktrap(net)

V(net)$label <- 1:40
V(net)$name <- 1:40
V(net)$page_rank <- round(page.rank(net)$vector, 2)
V(net)$betweenness <- round(betweenness(net), 2)
V(net)$degree <- degree(net)
V(net)$size <- V(net)$degree
V(net)$comm <- membership(wc)
V(net)$color <- colorize(membership(wc))

hchart(net, layout = layout_with_fr)

#' ### survfit
library("survival")
data(lung)

hchart(survfit(Surv(time, status) ~ sex, data = lung) , ranges = TRUE)

#' ### density
hchart(density(rnorm(100)), area = TRUE)

#' ### pca
hchart(princomp(USArrests))

#' ###
hchart(glm(hwy ~ year + class + fl , data = mpg))
