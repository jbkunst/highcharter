. <- NULL
#' Shorcut for create/add time series charts
#'
#' This function add a time series to a \code{highchart} object. 
#' 
#' This function \bold{modify} the type of \code{chart} to \code{datetime}
#'  
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param ts A time series object.
#' @param ... Aditional arguments for the data series (\url{http://api.highcharts.com/highcharts#series}).
#' 
#' @examples 
#' 
#' \dontrun{
#' 
#' library("magrittr")
#' 
#' highchart() %>% 
#'   hc_title(text = "Monthly Airline Passenger Numbers 1949-1960") %>% 
#'   hc_subtitle(text = "The classic Box and Jenkins airline data") %>% 
#'   hc_add_serie_ts(AirPassengers, name = "passengers") %>%
#'   hc_tooltip(pointFormat =  '{point.y} passengers')
#' 
#' highchart() %>% 
#'   hc_title(text = "Monthly Deaths from Lung Diseases in the UK") %>% 
#'   hc_add_serie_ts(fdeaths, name = "Female") %>%
#'   hc_add_serie_ts(mdeaths, name = "Male")
#' 
#' }
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
  
  # http://stackoverflow.com/questions/10160822/handling-unix-timestamp-with-highcharts  
  timestamps <- 1000 * timestamps
  
  values <- as.vector(ts)
  
  data_series <- list.parse2(data.frame(timestamps, values))

  hc %>% 
    hc_xAxis(type = "datetime") %>% 
    hc_add_serie(..., data = data_series)
    
}

#' Shorcut for create scatter plots
#'
#' This function delete the actual series in the object and change the \code{chart}
#' type to \code{scatter}.
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param x A numeric vector. 
#' @param y A numeric vector. Same length of \code{x}.
#' @param group A vector to split the (x,y) pairs (similiar to fill/color in ggplot).
#' @param ... Aditional shared arguments for the data series (\url{http://api.highcharts.com/highcharts#series}).
#' 
#' @examples 
#' 
#' \dontrun{
#' 
#' highchart() %>% 
#'   hc_add_serie_scatter(cars$speed, cars$dist)
#'    
#' highchart() %>% 
#'   hc_add_serie_scatter(mtcars$wt, mtcars$mpg, mtcars$cyl) %>% 
#'   hc_chart(zoomType = "xy") %>% 
#'   hc_title(text = "Motor Trend Car Road Tests") %>% 
#'   hc_xAxis(title = list(text = "Weight"), minorTickInterval = "auto") %>% 
#'   hc_yAxis(title = list(text = "Miles/gallon")) %>% 
#'   hc_tooltip(headerFormat = "<b>{series.name} cylinders</b><br>",
#'              pointFormat = "{point.x} (lb/1000), {point.y} (miles/gallon)")
#' 
#' }
#' 
#' @importFrom dplyr mutate group_by do select data_frame
#' 
#' @export 
hc_add_serie_scatter <- function(hc, x, y, group = NULL, ...) {
  
  assert_that(is.numeric(x),
              is.numeric(y),
              length(x) == length(y))
  
  df <- data_frame(x, y)
  
  if (!is.null(group)) {
    
    assert_that(length(x) == length(group))
    
    dss <- df %>%
      mutate(group = group) %>% 
      group_by(group) %>% 
      do(
        data = list.parse2(data_frame(.$x, .$y)),
        name = unique(as.character(.$group))
      ) %>% select(-group)
    
    hc$x$hc_opts$series <- list.parse2(dss)
    
  } else {
    
    dss <- list.parse2(df)
    
    hc$x$hc_opts$series <- list(list(data = dss, ...))
    
  }
  
  hc %>% hc_chart(type = "scatter") 
  
}
