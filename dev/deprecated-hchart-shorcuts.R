#' Shortcut to make a bar chart
#' @param x A character or factor vector.
#' @param ... Additional arguments for the data series \url{http://api.highcharts.com/highcharts#series}.
hcbar <- function(x, ...) {
  
  .Deprecated()
  
  stopifnot(is.character(x) | is.factor(x))
  
  hchart(x, ...)
  
}

#' Shortcut to make a pie chart
#' @param x A character o factor vector.
#' @param ... Additional arguments for the data series \url{http://api.highcharts.com/highcharts#series}
hcpie <- function(x, ...) {
  
  .Deprecated()
  
  stopifnot(is.character(x) | is.factor(x))
  
  hchart(x, type = "pie", ...)
  
}

#' Shortcut to make an histogram
#' @param x A numeric vector.
#' @param ... Additional arguments for the data series \url{http://api.highcharts.com/highcharts#series}.
hchist <- function(x, ...) {
  
  .Deprecated()
  
  stopifnot(is.numeric(x))
  
  hchart(x, ...)
}

#' Shortcut to make time series or line charts
#' @param x A numeric vector or a time series object.
#' @param ... Additional arguments for the data series \url{http://api.highcharts.com/highcharts#series}.
#' @importFrom stats as.ts
hcts <- function(x, ...) {
  
  .Deprecated()
  
  hchart(as.ts(x), ...)
  
}

#' Shortcut to make density charts
#' @param x A numeric vector or a density object.
#' @param ... Additional arguments for the data series \url{http://api.highcharts.com/highcharts#series}.
#' @importFrom stats density
hcdensity <- function(x, ...) {
  
  .Deprecated()
  
  stopifnot(inherits(x, "density") || inherits(x, "numeric"))
  
  if (class(x) == "numeric")
    x <- density(x)
  
  hchart(x, ...)
  
}
