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
#' \dontrun{
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
#' }
#' 
#' @importFrom stats is.ts time
#' @importFrom xts is.xts
#' 
#' @export 
hc_add_series_ts <- function(hc, ts, ...) {
  
  assertthat::assert_that(is.ts(ts), is.highchart(hc))
  
  .Deprecated("hc_add_series")
  
  # http://stackoverflow.com/questions/29202021/
  dates <- time(ts) %>% 
    zoo::as.Date()
  
  values <- as.vector(ts)
  
  hc %>% hc_add_series_times_values(dates, values, ...)
  
}

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
  
  .Deprecated("hc_add_series")
  
  assertthat::assert_that(is.highchart(hc), is.xts(x))
  
  hc$x$type <- "stock"
  
  timestamps <- datetime_to_timestamp(time(x))
  
  ds <- list_parse2(data.frame(timestamps, as.vector(x)))
  
  hc %>%  hc_add_series(data = ds, ...)
  
}

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
#' \dontrun{
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
  
  .Deprecated("hc_add_series")
  
  assertthat::assert_that(is.highchart(hc), is.xts(x), is.OHLC(x))
  
  hc$x$type <- "stock"
  
  time <- datetime_to_timestamp(time(x))
  
  xdf <- cbind(time, as.data.frame(x))
  
  xds <- list_parse2(xdf)
  
  nm <- ifelse(!is.null(list(...)[["name"]]),
               list(...)[["name"]],
               str_extract(names(x)[1], "^[A-Za-z]+"))

  hc <- hc %>% hc_add_series(data = xds,
                             name = nm,
                             type = type)
  
  hc
  
}

#' Shorcut for create scatter plots
#'
#' This function helps to create scatter plot from two numerics vectors. Options
#' argumets like size, color and label for points are added. 
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param x A numeric vector. 
#' @param y A numeric vector. Same length of \code{x}.
#' @param z A numeric vector for size. Same length of \code{x}.
#' @param color A vector to color the points.
#' @param label A vector to put names in the dots if you enable the datalabels.
#' @param showInLegend Logical value to show or not the data in the legend box.
#' @param ... Aditional shared arguments for the data series 
#'   (\url{http://api.highcharts.com/highcharts#series}).
#' 
#' @examples 
#' 
#' \dontrun{
#' hc <- highchart()
#' 
#' hc_add_series_scatter(hc, mtcars$wt, mtcars$mpg)
#' hc_add_series_scatter(hc, mtcars$wt, mtcars$mpg, mtcars$drat)
#' hc_add_series_scatter(hc, mtcars$wt, mtcars$mpg, mtcars$drat, mtcars$am)
#' hc_add_series_scatter(hc, mtcars$wt, mtcars$mpg, mtcars$drat, mtcars$qsec)
#' hc_add_series_scatter(hc, mtcars$wt, mtcars$mpg, mtcars$drat, mtcars$qsec, rownames(mtcars))
#' 
#' # Add named attributes to data (attributes length needs to match number of rows)
#' hc_add_series_scatter(hc, mtcars$wt, mtcars$mpg, mtcars$drat, mtcars$qsec,
#'                       name = rownames(mtcars), gear = mtcars$gear) %>%
#'   hc_tooltip(pointFormat = "<b>{point.name}</b><br/>Gear: {point.gear}")
#'   
#' }
#' 
#' @importFrom dplyr mutate do data_frame
#' 
#' @export 
hc_add_series_scatter <- function(hc, x, y, z = NULL, color = NULL,
                                  label = NULL, showInLegend = FALSE,
                                  ...) {
  
  .Deprecated("hc_add_series")
  
  assertthat::assert_that(is.highchart(hc), length(x) == length(y),
                          is.numeric(x), is.numeric(y))
  
  df <- data_frame(x, y)
  
  if (!is.null(z)) {
    assert_that(length(x) == length(z))
    df <- df %>% mutate(z = z)
  }
  
  if (!is.null(color)) {
    
    assert_that(length(x) == length(color))
    
    cols <- colorize(color)
    
    df <- df %>% mutate(valuecolor = color,
                        color = cols)
  }
  
  if (!is.null(label)) {
    assert_that(length(x) == length(label))
    df <- df %>% mutate(label = label)
  }
  
  # Add arguments to data points if they match the length of the data
  args <- list(...)
  for (i in seq_along(args)) {
    if (length(x) == length(args[[i]]) && names(args[i]) != "name") {
      attr <- list(args[i])
      names(attr) <- names(args)[i]
      df <- cbind(df, attr)
      # Used argument is set to zero length
      args[[i]] <- character(0)
    }
  }
  # Remove already used arguments
  args <- Filter(length, args)
  
  ds <- list_parse(df)
  
  type <- ifelse(!is.null(z), "bubble", "scatter")
  
  if (!is.null(label)) {
    dlopts <- list(enabled = TRUE, format = "{point.label}")
  } else {
    dlopts <- list(enabled = FALSE)
  }
  
  do.call("hc_add_series", c(list(hc,
                                  data = ds, 
                                  type = type, 
                                  showInLegend = showInLegend, 
                                  dataLabels = dlopts),
                             args))
}

hc_add_series_df_old <- function(hc, data, ...) {
  
  .Deprecated("hc_add_series")
  
  assertthat::assert_that(is.highchart(hc), is.data.frame(data))
  
  hc <- hc %>%
    hc_add_series(data = list_parse(data), ...)
  
  hc
}

