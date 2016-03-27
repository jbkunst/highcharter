#' Shorcut for create/add time series from times and values
#'
#' This function add a time series to a \code{highchart} object. 
#' 
#' This function \bold{modify} the type of \code{chart} to \code{datetime}
#'  
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param dates  A date vector (same length as \code{values})
#' @param values A numeric vector
#' @param ... Aditional arguments for the data series (\url{http://api.highcharts.com/highcharts#series}).
#' 
#' @examples 
#' 
#' \dontrun{
#' 
#' require("ggplot2")
#' data(economics, package = "ggplot2")
#' 
#' hc_add_series_times_values(hc = highchart(),
#'                            dates = economics$date,
#'                            values = economics$psavert, 
#'                            name = "Personal Savings Rate")
#' }
#' 
#' @importFrom zoo as.Date
#' 
#' @export 
hc_add_series_times_values <- function(hc, dates, values, ...) {
  
  assertthat::assert_that(.is_highchart(hc), is.numeric(values), is.date(dates))
  
  timestamps <- datetime_to_timestamp(dates)
  
  ds <- list.parse2(data.frame(timestamps, values))
  
  hc %>% 
    hc_xAxis(type = "datetime") %>% 
    hc_add_series(marker = list(enabled = FALSE), data = ds, ...)
  
}

#' @rdname hc_add_series_times_values
#' @export
hc_add_serie_times_values <- hc_add_series_times_values

#' Shorcut for create/add time series charts from a ts object
#'
#' This function add a time series to a \code{highchart} object
#' from a \code{ts} object. 
#' 
#' This function \bold{modify} the type of \code{chart} to \code{datetime}
#'  
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param ts A time series object.
#' @param ... Aditional arguments for the data series (\url{http://api.highcharts.com/highcharts#series}).
#' 
#' @examples 
#' 
#' highchart() %>% 
#'   hc_title(text = "Monthly Airline Passenger Numbers 1949-1960") %>% 
#'   hc_subtitle(text = "The classic Box and Jenkins airline data") %>% 
#'   hc_add_series_ts(AirPassengers, name = "passengers") %>%
#'   hc_tooltip(pointFormat =  '{point.y} passengers')
#' 
#' highchart() %>% 
#'   hc_title(text = "Monthly Deaths from Lung Diseases in the UK") %>% 
#'   hc_add_series_ts(fdeaths, name = "Female") %>%
#'   hc_add_series_ts(mdeaths, name = "Male")
#'   
#' @importFrom stats is.ts time
#' @importFrom xts is.xts
#' 
#' @export 
hc_add_series_ts <- function(hc, ts, ...) {
  
  assertthat::assert_that(is.ts(ts), .is_highchart(hc))
  
  # http://stackoverflow.com/questions/29202021/r-how-to-extract-dates-from-a-time-series
  dates <- time(ts) %>% 
    zoo::as.Date()
  
  values <- as.vector(ts)
  
  hc %>% hc_add_serie_times_values(dates, values, ...)
  
}

#' @rdname hc_add_series_ts
#' @export
hc_add_serie_ts <- hc_add_series_ts

#' Shorcut for create highstock chart from \code{xts} object
#'
#' This function helps to create highstock charts from \code{xts} objects
#' obtaining by \code{getSymbols} function from the  \pkg{quantmod}.
#' 
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param x A \code{xts} object from the \pkg{quantmod} package.
#' @param ... Aditional shared arguments for the data series
#'   (\url{http://api.highcharts.com/highcharts#series}).
#'   
#' @examples 
#' 
#' \dontrun{
#' 
#' library("quantmod")
#' 
#' usdjpy <- getSymbols("USD/JPY", src="oanda", auto.assign = FALSE)
#' eurkpw <- getSymbols("EUR/KPW", src="oanda", auto.assign = FALSE)
#' 
#' highchart(type = "stock") %>% 
#'   hc_add_series_xts(usdjpy, id = "usdjpy") %>% 
#'   hc_add_series_xts(eurkpw, id = "eurkpw")
#' }
#' 
#' @importFrom xts is.xts
#' @export
hc_add_series_xts <- function(hc, x, ...) {
  
  assertthat::assert_that(.is_highchart(hc), is.xts(x))
  
  hc$x$type = "stock"
  
  timestamps <- datetime_to_timestamp(time(x))
  
  ds <- list.parse2(data.frame(timestamps, as.vector(x)))
  
  hc %>%  hc_add_series(data = ds, ...)
  
}

#' @rdname hc_add_series_xts
#' @export
hc_add_serie_xts <- hc_add_series_xts

#' Shorcut for create candlestick charts
#'
#' This function helps to create candlestick from \code{xts} objects
#' obtaining by \code{getSymbols} function from the  \pkg{quantmod}.
#' 
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param x A \code{OHLC} object from the \pkg{quantmod} package.
#' @param type The type of chart. Can be \code{candlestick} or \code{ohlc}.
#' @param ... Aditional shared arguments for the data series
#'   (\url{http://api.highcharts.com/highcharts#series}).
#'   
#' @examples   
#' 
#' library("xts")
#'
#' data(sample_matrix)
#'
#' matrix_xts <- as.xts(sample_matrix, dateFormat = "Date")
#' 
#' head(matrix_xts)
#' 
#' class(matrix_xts)
#' 
#' highchart() %>% 
#'   hc_add_series_ohlc(matrix_xts)
#'
#' \dontrun{
#'    
#' library("quantmod")
#'
#' x <- getSymbols("AAPL", auto.assign = FALSE)
#' y <- getSymbols("SPY", auto.assign = FALSE)
#' 
#' highchart() %>% 
#'   hc_add_series_ohlc(x) %>% 
#'   hc_add_series_ohlc(y)
#'   
#' }
#'   
#' @importFrom quantmod is.OHLC
#' @importFrom stringr str_extract
#' @export
hc_add_series_ohlc <- function(hc, x, type = "candlestick", ...){
  
  assertthat::assert_that(.is_highchart(hc), is.xts(x), is.OHLC(x))
  
  hc$x$type = "stock"
  
  time <- datetime_to_timestamp(time(x))
  
  xdf <- cbind(time, as.data.frame(x))
  
  xds <- list.parse2(xdf)
  
  nm <- ifelse(!is.null(list(...)[["name"]]),
               list(...)[["name"]],
               str_extract(names(x)[1], "^[A-Za-z]+"))

  hc <- hc %>% hc_add_series(data = xds,
                             name = nm,
                             type = type)
  
  hc
  
}

#' @rdname hc_add_series_ohlc
#' @export
hc_add_serie_ohlc <- hc_add_series_ohlc

#' Shorcut for add flags to highstock chart
#'
#' This function helps to add flags highstock charts created from \code{xts} objects.
#' 
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param dates Date vector.
#' @param title A character vector with titles.
#' @param text A character vector with the description.
#' @param id The name of the series to add the flags. A previous series
#'   must be added whith this \code{id}. 
#' @param ... Aditional shared arguments for the *flags* data series
#'   (\url{http://api.highcharts.com/highstock#plotOptions.flags})
#'   
#' @examples
#' 
#' 
#' \dontrun{
#' 
#' library("quantmod")
#' 
#' usdjpy <- getSymbols("USD/JPY", src="oanda", auto.assign = FALSE)
#' 
#' dates <- as.Date(c("2015-05-08", "2015-09-12"), format = "%Y-%m-%d")
# 
#' highchart(type = "stock") %>% 
#'   hc_add_series_xts(usdjpy, id = "usdjpy") %>% 
#'   hc_add_series_flags(dates,
#'                       title = c("E1", "E2"), 
#'                       text = c("This is event 1", "This is the event 2"),
#'                       id = "usdjpy") 
#' }
#'                       
#' @export
hc_add_series_flags <- function(hc, dates,
                                title = LETTERS[seq(length(dates))],
                                text = title,
                                id = NULL, ...) {
  
  assertthat::assert_that(.is_highchart(hc), is.date(dates))
  
  dfflags <- data_frame(x = datetime_to_timestamp(dates),
                        title = title, text = text)
  
  dsflags <- list.parse3(dfflags)
  
  hc %>% hc_add_series(data = dsflags, onSeries = id, type = "flags", ...)
  
}

#' @rdname hc_add_series_flags
#' @export
hc_add_serie_flags <- hc_add_series_flags
