#' Function to chart R objects
#' 
#' This is a generic function to plot various object including
#' character, factors, time series (\code{xts}, \code{ts} 
#' and \code{mts}).
#' 
#' @param x A R object.
#' @param ... Aditional arguments for the data series 
#'    (\url{http://api.highcharts.com/highcharts#series}).
#'    
#' @export
hchart <- function(x, ...){
  
  if (identical(sort(class(x)), sort(c("mts", "ts", "matrix"))))
    return(hchart.mts(x, ...))
  
  if (any(class(x) %in% c("xts", "zoo", "ts")))
    return(hchart.xts(x, ...))
  
  if (any(class(x) %in% c("character", "factor")))
    return(hchart.character(x, ...))
  
  message("x have a class not supported yet")
  invisible()
}

#' @importFrom dplyr count_
hchart.character <- function(x, ...) {
  
  cnts <- count_(data_frame(variable = x), "variable")
  
  highchart() %>% 
    hc_add_series_labels_values(cnts[["variable"]], 
                                cnts[["n"]],
                                type = "column") %>% 
    hc_xAxis(categories = cnts[["variable"]])
}

#' @importFrom xts as.xts
hchart.xts <- function(x, ...) {
  hc_add_series_xts(highchart(highstock = TRUE), as.xts(x), ...)
}

hchart.mts <- function(x, ...) {
  hc <- highchart(highstock = TRUE)
  for (i in seq(dim(x)[2])) {
    nm <- attr(x, "dimnames")[[2]][i]
    hc <- hc %>% hc_add_series_xts(as.xts(x[, i]), name = nm, ...)
  }
  hc
}
