#' Convert an object to list with identical structure
#'
#' This function is similiar to \code{rlist::list.parse} but this removes names. 
#' 
#' @param df A data frame to parse to list
#' 
#' @examples 
#' 
#' x <- data.frame(a=1:3,type=c('A','C','B'), stringsAsFactors = FALSE)
#' 
#' list.parse2(x)
#' 
#' list.parse3(x)
#' 
#' @importFrom stats setNames
#' @export
list.parse2 <- function(df) {
  
  assertthat::assert_that(is.data.frame(df))
  
  setNames(apply(df, 1, function(r) as.list(as.vector(r))), NULL)
  
}

#' @importFrom rlist list.parse
#' @rdname list.parse2  
#' @export 
list.parse3 <- function(df) {
  
  assertthat::assert_that(is.data.frame(df))
  
  setNames(list.parse(df), NULL)
  
}

#' String to 'id' format
#' 
#' Turn a string to \code{id} format used in treemaps.
#' 
#' @param x A vector string.
#' 
#' @examples 
#' 
#' str_to_id(" A string _ with    Underscores   ")
#' 
#' @importFrom stringr str_to_lower str_replace_all
#' @export
str_to_id <- function(x) {
  
  assertthat::assert_that(is.character(x))
  
  x %>% 
    str_trim() %>%
    str_to_lower() %>% 
    str_replace_all("\\s+", "_") %>% 
    str_replace_all("_+", "_") %>% 
    iconv("latin1", "ASCII", sub = "")
  
}

#' Date to Timesstamps
#' 
#' Turn a date time vector to \code{timestamp} format
#' 
#' @param dt Date or datetime vector
#' 
#' @examples 
#' 
#' datetime_to_timestamp(dt = as.Date(c("2015-05-08", "2015-09-12"), format = "%Y-%m-%d"))
#' 
#' @export
datetime_to_timestamp <- function(dt) {
  
  # http://stackoverflow.com/questions/10160822/handling-unix-timestamp-with-highcharts 
  assertthat::assert_that(assertthat::is.date(dt) | assertthat::is.time(dt))
  
  tmstmp <- dt %>% 
    as.POSIXct(dt) %>% 
    as.numeric() 
  
  tmstmp <- 1000 * tmstmp
  
  tmstmp
  
}

#' Get default colors for Highcharts theme
#'
#' Get color used in highcharts charts.
#' 
#' @examples 
#' 
#' hc_get_colors()[1:5]
#' 
#' @export
hc_get_colors <- function() {
  
  c("#7cb5ec", "#434348", "#90ed7d", "#f7a35c", "#8085e9",
    "#f15c80", "#e4d354", "#2b908f", "#f45b5b", "#91e8e1")
  
}

#' Get dash styles
#'
#' Get dash style to use on highcharts objects.
#' 
#' @examples 
#' 
#' hc_get_dash_styles()[1:5]
#' 
#' @export
hc_get_dash_styles <- function() {
  
  c("Solid", "ShortDash", "ShortDot", "ShortDashDot", "ShortDashDotDot",
    "Dot", "Dash", "LongDash", "DashDot", "LongDashDot", "LongDashDotDot")
  
}

#' Chart a demo for testing themes
#'
#' Chart a demo for testing themes
#' 
#' @examples 
#' 
#' hc_demo()
#' 
#' @export
hc_demo <- function() {
  
  load(system.file("data/citytemp.rda", package = "highcharter"))
  
  highchart() %>% 
    hc_title(text = "Monthly Average Temperature") %>% 
    hc_subtitle(text = "Source: WorldClimate.com") %>% 
    hc_yAxis(title = list(text = "Temperature")) %>% 
    hc_xAxis(categories = citytemp$month) %>% 
    hc_add_series(name = "Tokyo", data = citytemp$tokyo) %>% 
    hc_add_series(name = "London", data = citytemp$london) %>% 
    hc_add_series(name = "Berlin", data = citytemp$berlin) 
  
}
