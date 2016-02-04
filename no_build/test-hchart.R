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
hchart(x)

#' ### Character, Factor
data(diamonds, package = "ggplot2")
x <- diamonds$cut
class(x)
plot(x)
hchart(x)
hchart(as.character(x), type = "pie")

#' ### ts
x <- LakeHuron
class(x)
plot(x)
hchart(x)

#' ### xts quantmod package
library("quantmod")
x <- getSymbols("USD/JPY", src = "oanda", auto.assign = FALSE)
class(x)
plot(x)
hchart(x)

#' ### xts ohlc
x <- getSymbols("YHOO", auto.assign = FALSE)
class(x)
plot(x)
hchart(x)
hchart(x, type = "ohlc")

#' ### acf(s)
x <- acf(diff(AirPassengers), plot = FALSE)
class(x)
plot(x)
hchart(x)

#' ### Multivariate Time series
x <- cbind(mdeaths, fdeaths)
class(x)
plot(x)
hchart(x)

#' ### Forecasts
library("forecast")
d.arima <- forecast::auto.arima(AirPassengers)
object <- forecast::forecast(d.arima, level = c(95, 80))
class(object)
plot(object)
hchart(object)

object <- forecast(ets(USAccDeaths), h = 48)
class(object)
plot(object)
hchart(object)

object <- forecast(Arima(WWWusage, c(3,1,0)))
class(object)
plot(object)
hchart(object)

#' ### Distance matrix 
x <- dist(mtcars[ order(mtcars$hp),])
class(x)
plot(x)
hchart(x)
