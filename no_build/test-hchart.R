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

x <- acf(AirPassengers)
class(x)


#' ## Character, Factor
x <- diamonds$cut
class(x)
plot(x)
hchart(x)
hchart(x, type = "pie")

#' ## Distance matrix 
x <- dist(mtcars)
class(x)
plot(x)
hchart(x)

require("viridisLite")
stps <- data.frame(q = (0:3)^2/(3^2), c = substring(viridis(3 + 1), 0, 7))
stps <- list.parse2(stps)

hchart(x) %>%
  hc_chart(zoomType = "xy") %>% 
  hc_colorAxis(stops = stps)

#' ## Univariate quantmod package
x <- getSymbols("USD/JPY", src = "oanda", auto.assign = FALSE)
class(x)
plot(x)
hchart(x)


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







