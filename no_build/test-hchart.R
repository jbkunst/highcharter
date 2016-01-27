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
library("xts")
data(diamonds, package = "ggplot2")


#' ### Numeric
x <- rgamma(400, 10, 5)
class(x)
hist(x)
hchart(x)

#' ### Character, Factor
x <- diamonds$cut
class(x)
plot(x)
hchart(x)
hchart(x, type = "pie")

#' ### Distance matrix 
x <- dist(mtcars[ order(mtcars$hp),])
class(x)
plot(x)
hchart(x)

#' ### Univariate quantmod package
x <- getSymbols("USD/JPY", src = "oanda", auto.assign = FALSE)
class(x)
plot(x)
hchart(x)

#' ### OHLC series
x <- getSymbols("AAPL", src = "yahoo", auto.assign = FALSE)
class(x)
plot(x)
hchart(x)






