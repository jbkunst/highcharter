#' Removing series to highchart objects
#'
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param names The series's names to delete.
#' 
#' @export
hc_rm_series <- function(hc, names = NULL) {
  
  stopifnot(!is.null(names))
  
  positions <- hc$x$hc_opts$series %>%
    map("name") %>%
    unlist()
  
  position <- which(positions %in% names)
  
  hc$x$hc_opts$series[position] <- NULL
  
  hc
  
}

#' Adding and removing series from highchart objects
#'
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param data An R object like numeric, list, ts, xts, etc.
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
#'   hc_rm_series(names = c("New York", "Tokyo"))
#'
#' @export
hc_add_series <- function(hc, data, ...){
  
  UseMethod("hc_add_series", data)
  
}

#' @export
hc_add_series.default <- function(hc, ...) {
  
  assertthat::assert_that(is.highchart(hc))
  
  if(getOption("highcharter.verbose"))
    message("hc_add_series.default")
  
  validate_args("add_series", eval(substitute(alist(...))))
  
  # dots <- list(...)
  # 
  # if (is.numeric(dots$data) & length(dots$data) == 1) {
  #   dots$data <- list(dots$data)
  # }
  # 
  # lst <- do.call(list, dots)
  # 
  hc$x$hc_opts$series <- append(hc$x$hc_opts$series, list(list(...)))
  
  hc
  
}

#' @export
hc_add_series.numeric <- function(hc, data, ...) {
  
  if(getOption("highcharter.verbose"))
    message("hc_add_series.numeric")
  
  if(length(data) == 1)
    data <- list(data)
  
  hc_add_series.default(hc, data = data, ...)
  
}

#' @importFrom zoo as.Date
#' @importFrom stats time
#' @export
hc_add_series.ts <- function(hc, data, ...) {
  
  if(getOption("highcharter.verbose"))
    message("hc_add_series.ts")
  
  # http://stackoverflow.com/questions/29202021/
  timestamps <- data %>% 
    stats::time() %>% 
    zoo::as.Date() %>% 
    datetime_to_timestamp()
  
  series <- list_parse2(data.frame(timestamps, as.vector(data)))
  
  hc_add_series(hc, data = series, ...)
  
}

#' @importFrom xts is.xts
#' @importFrom quantmod is.OHLC
#' @export
hc_add_series.xts <- function(hc, data, ...) {
  
  if(getOption("highcharter.verbose"))
    message("hc_add_series.xts")
  
  if(is.OHLC(data))
    return(hc_add_series.ohlc(hc, data, ...))
  
  timestamps <- datetime_to_timestamp(time(data))
  
  series <- list_parse2(data.frame(timestamps, as.vector(data)))
  
  hc_add_series(hc, data = series, ...)
  
}

#' @importFrom stringr str_extract
#' @export
hc_add_series.ohlc <- function(hc, data, type = "candlestick", ...){
  
  if(getOption("highcharter.verbose"))
    message("hc_add_series.xts.ohlc")
  
  time <- datetime_to_timestamp(time(data))
  xdf <- cbind(time, as.data.frame(data))
  xds <- list_parse2(xdf)
  
  nm <- ifelse(!is.null(list(...)[["name"]]),
               list(...)[["name"]],
               str_extract(names(data)[1], "^[A-Za-z]+"))
  
  hc_add_series(hc, data = xds, name = nm, type = type, ...)
  
}



