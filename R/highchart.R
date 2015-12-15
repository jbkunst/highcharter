#' Adding chart options to highchart object
#'
#' Arguments are defined in \url{http://api.highcharts.com/highcharts#chart}
#' 
#' @export
hc_chart <- function(hc, ...) {
  hc$x$hc_opts$chart <- list(...)
  hc
}

#' Adding titles options to highchart object
#'
#' Arguments are defined in \url{http://api.highcharts.com/highcharts#title}
#' 
#' @export
hc_title <- function(hc, ...) {
  hc$x$hc_opts$title <- list(...)
  hc
}

#' Adding subtitles options to highchart object
#'
#' Arguments are defined in \url{http://api.highcharts.com/highcharts#subtitle}
#' 
#' @export
hc_subtitle <- function(hc, ...) {
  hc$x$hc_opts$subtitle <- list(...)
  hc
}

#' Adding xAxis options to highchart object
#'
#' Arguments are defined in \url{http://api.highcharts.com/highcharts#xAxis}
#' 
#' @export
hc_xAxis  <- function(hc, ...) {
  hc$x$hc_opts$xAxis <- list(...)
  hc
}

#' Adding yAxis options to highchart object
#'
#' Arguments are defined in \url{http://api.highcharts.com/highcharts#yAxis}
#' 
#' @export
hc_yAxis  <- function(hc, ...) {
  hc$x$hc_opts$yAxis <- list(...)
  hc
}

#' Adding plot options to highchart object
#'
#' Arguments are defined in \url{http://api.highcharts.com/highcharts#plotOptions}
#' 
#' @export
hc_plotOptions  <- function(hc, ...) {
  hc$x$hc_opts$plotOptions <- list(...)
  hc
}


#' Adding series to highchart object
#'
#' Arguments are defined in \url{http://api.highcharts.com/highcharts#chart}
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
#' @import purrr
#' 
#' @export
hc_rm_serie <- function(hc, name = NULL) {
  
  stopifnot(!is.null(name))
  
  position <- hc$x$hc_opts$series %>%
    map("name") %>%
    unlist() %>% 
    {which(. == name)}
  
  hc$x$hc_opts$series[position] <- NULL
  
  hc
}

#' <Add Title>
#'
#' <Add Description>
#'
#' @import htmlwidgets
#'
#' @export
highchart <- function(hc_opts = list(), width = NULL, height = NULL, debug = FALSE) {

  # forward options using x
  x = list(
    hc_opts = hc_opts,
    debug = debug
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'highchart',
    x,
    width = width,
    height = height,
    package = 'highcharter'
  )
}

#' Widget output function for use in Shiny
#'
#' @export
highchartOutput <- function(outputId, width = '100%', height = '400px'){
  shinyWidgetOutput(outputId, 'highchart', width, height, package = 'highcharter')
}

#' Widget render function for use in Shiny
#'
#' @export
renderHighchart <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  shinyRenderWidget(expr, highchartOutput, env, quoted = TRUE)
}
