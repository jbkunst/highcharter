#' ---
#' date: false
#' output:
#'   html_document:
#'     theme: journal
#'     toc: yes
#' ---

#+ message=FALSE, warning=FALSE
library("highcharter")
library("quantmod")
data(diamonds, package = "ggplot2")

#+ echo=FALSE, results=FALSE, message=FALSE, warning=FALSE
x <- AirPassengers
x <- cbind(mdeaths, fdeaths)
x <- getSymbols("USD/JPY", src = "oanda", auto.assign = FALSE)
x <- diamonds$cut


class(x)
plot(x)
hchart(x)

#### list all suppported ####
x <- diamonds$cut
class(x)
plot(x)
hchart(x)

x <- cbind(mdeaths, fdeaths)
class(x)
plot(x)
hchart(x)

x <- AirPassengers
class(x)
plot(x)
hchart(x)

x <- getSymbols("USD/JPY", src = "oanda", auto.assign = FALSE)
class(x)
plot(x)
hchart(x)



