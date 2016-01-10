#' Convert an object to list with identical structure
#'
#' This function is similiar to \code{rlist::list.parse} but this removes names. 
#' 
#' @param df A data frame to 
#' 
#' @importFrom stats setNames
#' 
#' @rdname helpers
#' @export
list.parse2 <- function(df) {
  
  setNames(apply(df, 1, function(r) as.list(as.vector(r))), NULL)
  
}

#' String to 'id' format
#' 
#' Turn a string to \code{id} format used in treemaps.
#' 
#' @param x A vector string.
#' 
#' @importFrom stringr str_to_lower str_replace_all
#' @rdname helpers
#' @export
str_to_id <- function(x) {
  
  assert_that(is.character(x))
  
  x %>% 
    str_trim() %>%
    str_to_lower() %>% 
    str_replace_all("\\s+", "_") %>% 
    iconv("latin1", "ASCII", sub="")
  
}

#' Get default colors for Highcharts theme
#'
#' Get color used in highcharts charts.
#' 
#' @rdname helpers
#' @export
hc_get_colors <- function() {
  
  c("#7cb5ec", "#434348", "#90ed7d", "#f7a35c", "#8085e9",
    "#f15c80", "#e4d354", "#2b908f", "#f45b5b", "#91e8e1")
  
}

#' Get dash styles
#'
#' Get dash style to use on hichartrs objects.
#' 
#' @rdname helpers
#' @export
hc_get_dash_styles <- function() {
  
  c("Solid", "ShortDash", "ShortDot", "ShortDashDot", "ShortDashDotDot", "Dot",
    "Dash", "LongDash", "DashDot", "LongDashDot", "LongDashDotDot")
  
}
