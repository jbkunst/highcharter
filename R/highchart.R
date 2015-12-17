#' @import rlist
.hc_opt <- function(hc, name, ...) {
  
  if (is.null(hc$x$hc_opts[[name]])) {
    
    hc$x$hc_opts[[name]] <- list(...)
    
  } else {
    
    hc$x$hc_opts[[name]] <- list.merge(hc$x$hc_opts[[name]], list(...))
    
  }
  
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

#' Adding exporting options to highchart object
#'
#' Arguments are defined in \url{http://api.highcharts.com/highcharts#exporting}
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param ... Arguments defined in \url{http://api.highcharts.com/highcharts}. 
#'
#' @export
hc_exporting <- function(hc, ...) {
  
  .hc_opt(hc, "exporting", ...)
  
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

#' Create a Highcharts chart widget
#'
#' This function creates a Highchart chart using \pkg{htmlwidgets}. The
#' widget can be rendered on HTML pages generated from R Markdown, Shiny, or
#' other applications.
#'
#' @param hc_opts A \code{list} object containing options defined as 
#'    \url{http://api.highcharts.com/highcharts}.
#' @param width A numeric input in pixels.
#' @param height  A numeric input in pixels.
#' @param debug A boolean value if you want to print in the browser console the 
#'    parameters given to \code{highchart}.
#'      
#' @import htmlwidgets
#'
#' @export
highchart <- function(hc_opts = list(), width = NULL,
                      height = NULL, debug = FALSE) {

  # forward options using x
  x <- list(
    hc_opts = hc_opts,
    debug = debug
  )

  # create widget
  htmlwidgets::createWidget(
    name = "highchart",
    x,
    width = width,
    height = height,
    package = "highcharter"
  )
}

#' Widget output function for use in Shiny
#'
#' @param outputId The name of the input.
#' @param width A numeric input in pixels.
#' @param height  A numeric input in pixels. 
#'
#' @export
highchartOutput <- function(outputId, width = "100%", height = "400px"){
  shinyWidgetOutput(outputId, "highchart", width, height,
                    package = "highcharter")
}

#' Widget render function for use in Shiny
#'
#' @param expr A highchart expression. 
#' @param env A enviorment.
#' @param quoted  A boolean value.
#'
#' @export
renderHighchart <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) {
    expr <- substitute(expr)
    } # force quoted
  shinyRenderWidget(expr, highchartOutput, env, quoted = TRUE)
}
