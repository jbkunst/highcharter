#' Shorcut for data series from a list of data series
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object.
#' @param x A \code{list} or a \code{data.frame} of series.
#' 
#' @examples 
#' 
#' ds <- lapply(seq(5), function(x){
#'   list(data = cumsum(rnorm(100, 2, 5)), name = x)
#' })
#' 
#' highchart() %>% 
#'   hc_plotOptions(series = list(marker = list(enabled = FALSE))) %>% 
#'   hc_add_series_list(ds)
#'   
#' @export
hc_add_series_list <- function(hc, x) {
  
  assertthat::assert_that(is.highchart(hc), (is.list(x) | is.data.frame(x)))
  
  if(is.data.frame(x))
    x <- list_parse(x)
                          
  hc$x$hc_opts$series <- append(hc$x$hc_opts$series, x)
  
  hc
  
}

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
  
  assertthat::assert_that(is.highchart(hc), is.date(dates))
  
  dfflags <- data_frame(x = datetime_to_timestamp(dates),
                        title = title, text = text)
  
  dsflags <- list_parse(dfflags)
  
  hc %>% hc_add_series(data = dsflags, onSeries = id, type = "flags", ...)
  
}

#' Shorcut for add series for pie, bar and column charts
#'
#' This function add data to plot pie, bar and column charts.
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param labels A vector of labels. 
#' @param values A numeric vector. Same length of \code{labels}.
#' @param colors A not required color vector (hexadecimal format). Same length of \code{labels}.
#' @param ... Aditional shared arguments for the data series 
#'   (\url{http://api.highcharts.com/highcharts#series}).
#' 
#' @examples 
#' 
#' data("favorite_bars")
#' data("favorite_pies")
#' 
#' highchart() %>% 
#'   hc_title(text = "This is a bar graph describing my favorite pies
#'                    including a pie chart describing my favorite bars") %>%
#'   hc_subtitle(text = "In percentage of tastiness and awesomeness") %>% 
#'   hc_add_series_labels_values(favorite_pies$pie, favorite_pies$percent, name = "Pie",
#'                              colorByPoint = TRUE, type = "column") %>% 
#'   hc_add_series_labels_values(favorite_bars$bar, favorite_bars$percent,
#'                              colors = substr(terrain.colors(5), 0 , 7), type = "pie",
#'                              name = "Bar", colorByPoint = TRUE, center = c('35%', '10%'),
#'                              size = 100, dataLabels = list(enabled = FALSE)) %>% 
#'   hc_yAxis(title = list(text = "percentage of tastiness"),
#'            labels = list(format = "{value}%"), max = 100) %>% 
#'   hc_xAxis(categories = favorite_pies$pie) %>% 
#'   hc_legend(enabled = FALSE) %>% 
#'   hc_tooltip(pointFormat = "{point.y}%")
#' 
#' 
#' @export
hc_add_series_labels_values <- function(hc, labels, values,
                                        colors = NULL, ...) {
  
  assertthat::assert_that(is.highchart(hc),
                          is.numeric(values),
                          length(labels) == length(values))
  
  df <- data_frame(name = labels, y = values)
  
  if (!is.null(colors)) {
    assert_that(length(labels) == length(colors))
    
    df <- mutate(df, color = colors)
    
  }
  
  ds <- list_parse(df)
  
  hc <- hc %>% hc_add_series(data = ds, ...)
  
  hc
  
}

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
#' @importFrom assertthat assert_that is.date
#' @importFrom lubridate is.timepoint
#' @export
hc_add_series_times_values <- function(hc, dates, values, ...) {
  
  assertthat::assert_that(is.highchart(hc), is.numeric(values), is.timepoint(dates))
  
  timestamps <- datetime_to_timestamp(dates)
  
  ds <- list_parse2(data.frame(timestamps, values))
  
  hc %>% 
    hc_xAxis(type = "datetime") %>% 
    hc_add_series(marker = list(enabled = FALSE), data = ds, ...)
  
}
