#' ---
#' date: false
#' output:
#'   html_document:
#'     theme: journal
#'     toc: yes
#' ---

#+ message=FALSE, warning=FALSE, echo=FALSE, results=FALSE
library("highcharter")
library("quantmod")
data(diamonds, package = "ggplot2")

#+ echo=FALSE, results=FALSE, message=FALSE, warning=FALSE
x <- AirPassengers
x <- cbind(mdeaths, fdeaths)
x <- getSymbols("USD/JPY", src = "oanda", auto.assign = FALSE)
x <- diamonds$cut



#' ## Multivariate Time Series
x <- cbind(mdeaths, fdeaths)
class(x)
plot(x)
hchart(x)

#' ## Univariate Time Series
x <- AirPassengers
class(x)
plot(x)
hchart(x)


#' ## Univariate quantmod package
x <- getSymbols("USD/JPY", src = "oanda", auto.assign = FALSE)
class(x)
plot(x)
hchart(x)

#' ## Character, Factor
x <- diamonds$cut
class(x)
plot(x)
hchart(x)
hchart(x, type = "pie")

hchart(x, type = "pie", innerSize = "50%") %>% 
  hc_plotOptions(pie = list(startAngle = -90, endAngle = 90))



