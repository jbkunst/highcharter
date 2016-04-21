#' ---
#' date: false
#' output:
#'   html_document:
#'     theme: journal
#'     toc: yes
#' ---

#+ message=FALSE, warning=FALSE, echo=FALSE, results=FALSE
library("highcharter")
library("xts")


#' ### Numeric
x <- c(rnorm(500), rnorm(500, 6, 2))
class(x)
hist(x, breaks = "FD") # by default hchart use *Freedman-Diaconis* rule 
hchart(x)

#' ### Histogram
x <- hist(rbeta(300, 0.2, 4), plot = FALSE)
class(x)
plot(x) # by default hchart use *Freedman-Diaconis* rule 
hchart(x, color = "darkred")

#' ### Character, Factor
data(diamonds, package = "ggplot2")
x <- diamonds$cut
class(x)
plot(x)
hchart(x)

#' ### ts
x <- LakeHuron
class(x)
plot(x)
hchart(x)

#' ### lst
object <- stl(co2, "per")
plot(object)
hchart(object)

#' ### xts quantmod package
library("quantmod")
x <- getSymbols("USD/JPY", src = "oanda", auto.assign = FALSE)
class(x)
plot(x)
hchart(x)

#' ### xts ohlc
# x <- getSymbols("YHOO", auto.assign = FALSE)
class(x)
plot(x)
hchart(x)


#' ### acf(s)
x <- acf(diff(AirPassengers), plot = FALSE)
class(x)
plot(x)
hchart(x) %>% hc_title(text = "This is an ACF chart")

#' ### Multivariate Time series
x <- cbind(mdeaths, fdeaths)
class(x)
plot(x)
hchart(x)

#' ### Forecasts
library("forecast")
d.arima <- auto.arima(AirPassengers)
x <- forecast(d.arima, level = c(95, 80))
class(x)
plot(x)
hchart(x)

x <- forecast(ets(USAccDeaths), h = 48, level = 90)
class(x)
plot(x)
hchart(x)

x <- forecast(Arima(WWWusage, c(3,1,0)))
class(x)
plot(x)
hchart(x)

#' ### Seasonal Package (X-13ARIMA-SEATS) 
# library("seasonal")
# x <- seas(AirPassengers,
#           regression.aictest = c("td", "easter"),
#           outlier.critical = 3)
# class(x)
# plot(x)
# hchart(x)

#' ### igraph
library("igraph")
net <- barabasi.game(200) 
hchart(net)

V(net)$degree <- degree(net, mode = "all")*3
V(net)$betweenness <- betweenness(net)
V(net)$color <- colorize_vector(V(net)$betweenness)
V(net)$size <- sqrt(V(net)$degree)
hchart(net, minSize = 5, maxSize = 20)

#' ### Distance matrix 
x <- dist(mtcars[ order(mtcars$hp),])
class(x)
plot(x)
hchart(x)

