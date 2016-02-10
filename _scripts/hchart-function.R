#' ---
#' layout: post
#' ---
#+echo=FALSE
rm(list = ls())
library("highcharter")

#'
#' ## Generic `hchart` function
#' 

#' ### Numeric
x <- c(rnorm(500), rnorm(500, 6, 2))

hchart(x)

#' ### Histogram
x <- hist(rbeta(300, 0.2, 4), plot = FALSE)

hchart(x, color = "darkred")

#' ### Character, Factor
data(diamonds, package = "ggplot2")
x <- diamonds$cut

hchart(x)
hchart(as.character(x), type = "pie")

#' ### ts
x <- LakeHuron


hchart(x)

#' ### xts quantmod package
library("quantmod")
x <- getSymbols("USD/JPY", src = "oanda", auto.assign = FALSE)


hchart(x) %>% hc_add_theme(hc_theme_chalk())

#' ### xts ohlc
# x <- getSymbols("YHOO", auto.assign = FALSE)
# 
# 
# hchart(x)
# hchart(x, type = "ohlc")

#' ### acf(s)
x <- acf(diff(AirPassengers), plot = FALSE)


hchart(x) %>% hc_title(text = "This is an ACF chart")

#' ### Multivariate Time series
x <- cbind(mdeaths, fdeaths)


hchart(x)

#' ### Forecasts
library("forecast")
d.arima <- auto.arima(AirPassengers)
x <- forecast(d.arima, level = c(95, 80))


hchart(x)

x <- forecast(ets(USAccDeaths), h = 48, level = 90)


hchart(x) %>%
  hc_tooltip(valueDecimals = 2) %>% # share toolip
  hc_add_theme(hc_theme_538()) 

x <- forecast(Arima(WWWusage, c(3,1,0)))


hchart(x)

#' ### Distance matrix 
x <- dist(mtcars[ order(mtcars$hp),])


hchart(x)
