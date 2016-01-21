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
  
  if (identical(class(x), "dist"))
    return(hchart.dist(x, ...))
  
  if (any(class(x) %in% c("character", "factor")))
    return(hchart.character(x, ...))
  
  if (identical(sort(class(x)), sort(c("mts", "ts", "matrix"))))
    return(hchart.mts(x, ...))
  
  if (any(class(x) %in% c("xts", "zoo", "ts")))
    return(hchart.xts(x, ...))
  
  
  
  message("x have a class not supported yet")
  invisible()
}

#' @importFrom tidyr gather
hchart.character <- function(x, type = "column", ...) {
  
  cnts <- count_(data_frame(variable = x), "variable")
  
  highchart() %>% 
    hc_add_series_labels_values(cnts[["variable"]], 
                                cnts[["n"]],
                                type = type, ...) %>% 
    hc_xAxis(categories = cnts[["variable"]])
}

#' @importFrom dplyr count_
hchart.dist <- function(x, ...) {
  
  df <- as.data.frame(as.matrix(x), stringsAsFactors = FALSE)
  
  ordr <- names(df)
  
  df <- tbl_df(cbind(x = names(df), df)) %>% 
    gather(y, dist, -x) %>% 
    mutate(x = as.character(x),
           y = as.character(y)) %>% 
    left_join(data_frame(x = ordr,
                         xid = seq(length(ordr)) - 1), by = "x") %>% 
    left_join(data_frame(y = ordr,
                         yid = seq(length(ordr)) - 1), by = "y")
  
  ds <- df %>% 
    select(xid, yid, dist) %>% 
    list.parse2()
  
  highchart() %>% 
    hc_chart(type = "heatmap") %>% 
    hc_xAxis(categories = ordr) %>% 
    hc_yAxis(categories = ordr) %>% 
    hc_add_series(data = ds) %>% 
    hc_colorAxis(arg  = "")
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
