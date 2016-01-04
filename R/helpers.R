#' Convert an object to list with identical structure
#'
#' This function is similiar to \code{rlist::list.parse} but this removes names. 
#' 
#' @param df A data frame to 
#' 
#' @importFrom stats setNames
#' 
#' @export
list.parse2 <- function(df) {
  
  setNames(apply(df, 1, function(r) as.list(as.vector(r))), NULL)
  
}

#' Get default colors for Highcharts theme
#'
#' Get color used in highcharts charts.
#' 
#' 
#' @export
hc_get_colors <- function() {
  
  c("#7cb5ec", "#434348", "#90ed7d", "#f7a35c", "#8085e9",
    "#f15c80", "#e4d354", "#2b908f", "#f45b5b", "#91e8e1")
  
}

#' Get dash styles
#'
#' Get dash style to use on hichartrs objects.
#' 
#' 
#' @export
hc_get_dash_styles <- function() {
  
  c("Solid", "ShortDash", "ShortDot", "ShortDashDot", "ShortDashDotDot", "Dot",
    "Dash", "LongDash", "DashDot", "LongDashDot", "LongDashDotDot")
  
}

