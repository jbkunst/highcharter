#' Removing series to highchart objects
#'
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param names The series's names to delete.
#' 
#' @export
hc_rm_series <- function(hc, names = NULL) {
  
  stopifnot(!is.null(name))
  
  positions <- hc$x$hc_opts$series %>%
    map("name") %>%
    unlist()
  
  position <- which(positions %in% name)
  
  hc$x$hc_opts$series[position] <- NULL
  
  hc
  
}

#' Adding and removing series from highchart objects
#'
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param ... Arguments defined in \url{http://api.highcharts.com/highcharts#chart}. 
#'
#' @examples
#' 
#' data("citytemp")
#' 
#' hc <- highchart() %>% 
#'   hc_xAxis(categories = citytemp$month) %>% 
#'   hc_add_series(name = "Tokyo", data = citytemp$tokyo) %>% 
#'   hc_add_series(name = "New York", data = citytemp$new_york) 
#' 
#' hc 
#' 
#' hc %>% 
#'   hc_add_series(name = "London", data = citytemp$london, type = "area") %>% 
#'   hc_rm_series(name = "New York")
#'
#' @export
hc_add_series <- function(hc, ...) {
  
  validate_args("add_series", eval(substitute(alist(...))))
  
  dots <- list(...)
  
  if (is.numeric(dots$data) & length(dots$data) == 1) {
    dots$data <- list(dots$data)
  }
  
  lst <- do.call(list, dots)
  
  hc$x$hc_opts$series <- append(hc$x$hc_opts$series, list(lst))
  
  hc
  
}



# hc_add_series2 <- function(hc, data, ...){
#   UseMethod("hc_add_series2", data)
# }
# 
# hc_add_series2.default <- function(hc, data, ...) {
#   
#   # validate_args("add_series", eval(substitute(alist(...))))
#   
#   dots <- list(...)
#   
#   if (is.numeric(data) & length(data) == 1) {
#     data <- list(data)
#   }
#   
#   dots <- append(list(data = data), dots)
#   
#   lst <- do.call(list, dots)
#   
#   hc$x$hc_opts$series <- append(hc$x$hc_opts$series, list(lst))
#   
#   hc
#   
# }
# 
# hc_add_series2.numeric <- function(hc, data, ...) {
#   print("numeric function")
#   hc_add_series2.default(hc, data, ...)
# }
# 
# hc_add_series2.ts <- function(hc, data, ...) {
#   print("ts function")
#   hc_add_series_ts(hc, ts = data, ...)
# }
# 
# 
# highchart() %>% 
#   hc_add_series2(data = c(4)) %>% 
#   hc_add_series2(data = rnorm(5), type = "column", color = "red", name = "asd") 
#   
#   
# highchart() %>% 
#   hc_add_series2(data = AirPassengers) %>% 
#   hc_add_series2(data = AirPassengers + 3000, color = "red", name = "asd")
