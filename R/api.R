#' @import rlist assertthat
.hc_opt <- function(hc, name, ...) {
  
  assert_that(.is_highchart(hc))
  
  if (is.null(hc$x$hc_opts[[name]])) {
    
    hc$x$hc_opts[[name]] <- list(...)
    
  } else {
    
    hc$x$hc_opts[[name]] <- list.merge(hc$x$hc_opts[[name]], list(...))
    
  }
  
  # adding fonts
  hc$x$fonts <- unique(c(hc$x$fonts, .hc_get_fonts(hc$x$hc_opts)))
  
  hc
}

#' Adding chart options to highchart object
#'
#' Arguments are defined in \url{http://api.highcharts.com/highcharts#chart}
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param ... Arguments defined in \url{http://api.highcharts.com/highcharts}. 
#'
#' @export
hc_chart <- function(hc, ...) {
  
  .hc_opt(hc, "chart", ...)
  
}

#' Adding credits options to highchart object
#'
#' Arguments are defined in \url{http://api.highcharts.com/highcharts#credits}
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param ... Arguments defined in \url{http://api.highcharts.com/highcharts}. 
#'
#' @export
hc_credits <- function(hc, ...) {
  
  .hc_opt(hc, "credits", ...)
  
}

#' Adding legend options to highchart object
#'
#' Arguments are defined in \url{http://api.highcharts.com/highcharts#legend}
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param ... Arguments defined in \url{http://api.highcharts.com/highcharts}. 
#'
#' @export
hc_legend <- function(hc, ...) {
  
  .hc_opt(hc, "legend", ...)
  
}

#' Adding titles options to highchart object
#'
#' Arguments are defined in \url{http://api.highcharts.com/highcharts#title}
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param ... Arguments defined in \url{http://api.highcharts.com/highcharts}. 
#'
#' @export
hc_title <- function(hc, ...) {
  
  .hc_opt(hc, "title", ...)
  
}

#' Adding subtitles options to highchart object
#'
#' Arguments are defined in \url{http://api.highcharts.com/highcharts#subtitle}
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param ... Arguments defined in \url{http://api.highcharts.com/highcharts}. 
#'
#' @export
hc_subtitle <- function(hc, ...) {
  
  .hc_opt(hc, "subtitle", ...)
  
}

#' Adding tooltip options to highchart object
#'
#' Arguments are defined in \url{http://api.highcharts.com/highcharts#tooltip}
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param ... Arguments defined in \url{http://api.highcharts.com/highcharts}. 
#'
#' @export
hc_tooltip <- function(hc, ...) {
  
  .hc_opt(hc, "tooltip", ...)
  
}

#' Adding xAxis options to highchart object
#'
#' Arguments are defined in \url{http://api.highcharts.com/highcharts#xAxis}
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param ... Arguments defined in \url{http://api.highcharts.com/highcharts}. 
#'
#' @export
hc_xAxis  <- function(hc, ...) {
  
  .hc_opt(hc, "xAxis", ...)
  
}

#' Adding yAxis options to highchart object
#'
#' Arguments are defined in \url{http://api.highcharts.com/highcharts#yAxis}
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param ... Arguments defined in \url{http://api.highcharts.com/highcharts}. 
#'
#' @export
hc_yAxis  <- function(hc, ...) {
  
  .hc_opt(hc, "yAxis", ...)
  
}

#' Adding plot options to highchart object
#'
#' Arguments are defined in \url{http://api.highcharts.com/highcharts#plotOptions}
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param ... Arguments defined in \url{http://api.highcharts.com/highcharts}. 
#'
#' @export
hc_plotOptions  <- function(hc, ...) {
  
  .hc_opt(hc, "plotOptions", ...)
  
}

#' Adding series to highchart object
#'
#' Arguments are defined in \url{http://api.highcharts.com/highcharts#chart}
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param ... Arguments defined in \url{http://api.highcharts.com/highcharts}. 
#'
#' @export
hc_add_serie <- function(hc, ...) {
  
  hc$x$hc_opts$series <- append(hc$x$hc_opts$series, list(list(...)))
  
  hc
  
}

#' Removing series to highchart object
#'
#' Arguments are defined in \url{http://api.highcharts.com/highcharts#chart}
#'
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param name The serie's name to delete.
#'
#' @import purrr
#' 
#' @export
hc_rm_serie <- function(hc, name = NULL) {
  
  stopifnot(!is.null(name))
  
  positions <- hc$x$hc_opts$series %>%
    map("name") %>%
    unlist()
  
  position <- which(positions == name)
  
  hc$x$hc_opts$series[position] <- NULL
  
  hc
  
}
