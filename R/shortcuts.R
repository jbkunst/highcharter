#' Shorcut for create/add time series charts
#'
#' This function add a time series to a \code{highchart} object. 
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param ts A time series object
#' @param ... Aditional argumentes for the data (\url{http://api.highcharts.com/highcharts#series})
#' 
#' @examples 
#' 
#' library("magrittr")
#' 
#' highchart() %>% 
#'   hc_title(text = "Monthly Airline Passenger Numbers 1949-1960") %>% 
#'   hc_subtitle(text = "The classic Box and Jenkins airline data") %>% 
#'   hc_add_serie_ts(AirPassengers, name = "passengers")
#'   
#' highchart() %>% 
#'   hc_title(text = "Monthly Deaths from Lung Diseases in the UK") %>% 
#'   hc_add_serie_ts(fdeaths, name = "Female") %>%
#'   hc_add_serie_ts(mdeaths, name = "Male") %>% 
#'   hc_tooltip(pointFormat =  '{point.x:%e. %b %Y}: {point.y:.2f} m')
#' 
#' @import zoo
#' 
#' @export 
hc_add_serie_ts <- function(hc, ts, ...) {
  
  assert_that(is.ts(ts))
  
  # http://stackoverflow.com/questions/29202021/r-how-to-extract-dates-from-a-time-series
  timestamps <- time(ts) %>% 
    zoo::as.Date() %>% 
    as.POSIXct() %>% 
    as.numeric()
  
  values <- as.vector(ts)
  
  data_series <- list.parse2(data.frame(timestamps, values))

  hc %>% 
    hc_xAxis(type = "datetime") %>% 
    hc_add_serie(..., data = data_series)
    
}
