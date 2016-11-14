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
#' @examples
#' 
#' 
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

  hc$x$hc_opts$series <- append(hc$x$hc_opts$series, list(list(...)))
  
  hc
  
}

#' `hc_add_series` for numeric objects
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param data A numeric object
#' @param ... Arguments defined in \url{http://api.highcharts.com/highcharts#chart}. 
#' @export
hc_add_series.numeric <- function(hc, data, ...) {
  
  if(getOption("highcharter.verbose"))
    message("hc_add_series.numeric")
  
  data <- fix_1_length_data(data)
  
  hc_add_series.default(hc, data = data, ...)
  
}


#' hc_add_series for time series objects
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param data A time series object. Class \code{ts} object.
#' @param ... Arguments defined in \url{http://api.highcharts.com/highcharts#chart}. 
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

#' hc_add_series for xts objects
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param data A \code{xts} object.
#' @param ... Arguments defined in \url{http://api.highcharts.com/highcharts#chart}. 
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

#' @rdname hc_add_series.xts
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

#' hc_add_series for forecast objects
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param data A \code{forecast} object.
#' @param ... Arguments defined in \url{http://api.highcharts.com/highcharts#chart}. 
#' @export
hc_add_series.forecast <- function(hc, data, addOriginal = FALSE, addLevels = TRUE,
                                   fillOpacity = 0.1, ...) {
  
  if(getOption("highcharter.verbose"))
    message("hc_add_series.forecast")
  
  rid <- random_id()
  method <- data$method
  
  # hc <- highchart() %>% hc_title(text = "LALALA")
  # ... <- NULL
  
  if(addOriginal)
    hc <- hc_add_series(hc, data$x, name = "Series", zIndex = 3, ...)
  
  
  hc <- hc_add_series(hc, data$mean, name = method,  zIndex = 2, id = rid, ...)
  
  
  if(addLevels){
    
    tmf <- datetime_to_timestamp(zoo::as.Date(time(data$mean)))
    nmf <- paste(method, "level", data$level)
    
    for (m in seq(ncol(data$upper))) { # m <- 1
      
      dfbands <- data_frame(
        t = tmf,
        u = as.vector(data$upper[, m]),
        l = as.vector(data$lower[, m])
      )
      
      hc <- hc %>%
        hc_add_series(
          data = list_parse2(dfbands),
          name = nmf[m],
          type = "arearange",
          fillOpacity = fillOpacity,
          zIndex = 1,
          lineWidth = 0,
          linkedTo = rid,
          ...)
    }
  }
  
  
  hc
  

}


#' hc_add_series for density objects
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param data A \code{density} object.
#' @param ... Arguments defined in \url{http://api.highcharts.com/highcharts#chart}. 
#' @export
hc_add_series.density <- function(hc, data, ...) {
  
  if(getOption("highcharter.verbose"))
    message("hc_add_series.density")
  
  data <- list_parse(data.frame(cbind(x = data$x, y = data$y)))
  
  hc_add_series(hc, data = data, ...)
}


#' hc_add_series for character and factor objects
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param data A \code{character} or \code{factor} object.
#' @param ... Arguments defined in \url{http://api.highcharts.com/highcharts#chart}. 
#' @export
hc_add_series.character <- function(hc, data, ...) {
  
  if(getOption("highcharter.verbose"))
    message("hc_add_series.character")
  
  series <- data %>% 
    table() %>% 
    as.data.frame(stringsAsFactors = FALSE) %>% 
    setNames(c("name", "y")) %>% 
    list_parse()
  
  hc_add_series(hc, data = series, ...)
  
}

#' @export
hc_add_series.factor <- hc_add_series.character
