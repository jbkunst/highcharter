#' ---
#' layout: post
#' toc: true
#' ---
#+echo=FALSE
rm(list = ls())
library("highcharter")

#'
#' ## Generic `hchart` function
#' 

#' ### Numeric & Histograms
x <- c(rnorm(500), rnorm(500, 6, 2))

hchart(x)

x <- hist(rbeta(300, 0.2, 4), plot = FALSE)

hchart(x, color = "darkred")

#' ### Character & Factor
data(diamonds, package = "ggplot2")
x <- diamonds$cut

hchart(x)
hchart(as.character(x), type = "pie")

#' ### Time Series
x <- LakeHuron
hchart(x)

#' ### Forecast package
library("forecast")

d.arima <- auto.arima(AirPassengers)

x <- forecast(d.arima, level = c(95, 80))


hchart(x)

x <- forecast(ets(USAccDeaths), h = 48, level = 90)

hchart(x) %>%
  hc_tooltip(valueDecimals = 2) %>%
  hc_add_theme(hc_theme_economist()) 

x <- forecast(Arima(WWWusage, c(3,1,0)))

hchart(x)

#' ### `xts` from quantmod package
library("quantmod")

x <- getSymbols("USD/JPY", src = "oanda", auto.assign = FALSE)

hchart(x) %>%
  hc_add_theme(hc_theme_538())

#' ### `xts ohlc` objects
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
x <- dist(mtcars[ order(mtcars$hp),])


hchart(x)
