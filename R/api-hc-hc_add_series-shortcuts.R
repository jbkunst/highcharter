#' Shortcut for data series from a list of data series
#' 
#' @param hc A `highchart` `htmlwidget` object.
#' @param x A `list` or a `data.frame` of series.
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
  
  if (is.data.frame(x))
    x <- list_parse(x)
                          
  hc$x$hc_opts$series <- append(hc$x$hc_opts$series, x)
  
  hc
  
}

#' Shortcut for add series for pie, bar and columnn charts
#'
#' This function add data to plot pie, bar and columnn charts.
#' 
#' @param hc A `highchart` `htmlwidget` object. 
#' @param labels A vector of labels. 
#' @param values A numeric vector. Same length of `labels`.
#' @param colors A not required color vector (hexadecimal format). Same length of `labels`.
#' @param ... Additional shared arguments for the data series 
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
#'                              colorByPoint = TRUE, type = "columnn") %>% 
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

#' Shortcut for create/add time series from times and values
#'
#' This function add a time series to a `highchart` object. 
#' 
#' This function \bold{modify} the type of `chart` to `datetime`
#'  
#' @param hc A `highchart` `htmlwidget` object. 
#' @param dates  A date vector (same length as \code{values})
#' @param values A numeric vector
#' @param ... Additional arguments for the data series (\url{http://api.highcharts.com/highcharts#series}).
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
