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
  
  if (any(class(x) %in% c("character", "factor")))
    return(hchart.character(x, ...))
  
  if (identical(class(x), "dist"))
    return(hchart.dist(x, ...))
  
  if (is.OHLC(x))
    return(hchart.ohlc(x, ...))
  
  if (any(class(x) %in% c("xts")))
    return(hchart.xts(x, ...))
  
  if (identical(sort(class(x)), sort(c("mts", "ts", "matrix"))))
    return(hchart.mts(x, ...))
  
  message("x have a class not supported yet")
  invisible()
}

hchart.character <- function(x, type = "column", ...) {
  
  cnts <- count_(data_frame(variable = x), "variable")
  
  highchart() %>% 
    hc_add_series_labels_values(cnts[["variable"]], 
                                cnts[["n"]],
                                type = type, ...) %>% 
    hc_xAxis(categories = cnts[["variable"]])
}

#' @importFrom tidyr gather
#' @importFrom dplyr count_ left_join select_
hchart.dist <- function(x, ...) {
  
  df <- as.data.frame(as.matrix(x), stringsAsFactors = FALSE)
  
  y <- names(df)
  
  df <- tbl_df(cbind(x = y, df)) %>% 
    gather(y, dist, -x) %>% 
    mutate(x = as.character(x),
           y = as.character(y)) %>% 
    left_join(data_frame(x = y,
                         xid = seq(length(y)) - 1), by = "x") %>% 
    left_join(data_frame(y = y,
                         yid = seq(length(y)) - 1), by = "y")
  
  ds <- df %>% 
    select_("xid", "yid", "dist") %>% 
    list.parse2()
  
  fntltp <- JS("function(){
                  return this.series.xAxis.categories[this.point.x] + '<br>' +
                         this.series.yAxis.categories[this.point.y] + '<br>' +
                         Highcharts.numberFormat(this.point.value, 2);
               ; }")
  
  highchart() %>% 
    hc_chart(type = "heatmap") %>% 
    hc_xAxis(categories = y, title = NULL) %>% 
    hc_yAxis(categories = y, title = NULL) %>% 
    hc_add_series(data = ds) %>% 
    hc_tooltip(formatter = fntltp) %>% 
    hc_legend(align = "right", layout = "vertical",
              margin = 0, verticalAlign = "top",
              y = 25, symbolHeight = 280) %>% 
    hc_colorAxis(arg  = "")
}

hchart.xts <- function(x, ...) {
  hc_add_series_xts(highchart(type = "stock"), x, ...)
}

hchart.ohlc <- function(x, ...) {
  hc_add_series_ohlc(highchart(type = "stock"), x, ...)
}

#' @importFrom xts as.xts
hchart.mts <- function(x, ...) {
  hc <- highchart(type = "stock")
  for (i in seq(dim(x)[2])) {
    nm <- attr(x, "dimnames")[[2]][i]
    hc <- hc %>% hc_add_series_xts(as.xts(x[, i]), name = nm, ...)
  }
  hc
}
