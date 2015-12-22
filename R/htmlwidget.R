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
highchart <- function(hc_opts = list(), theme = NULL,
                      width = NULL, height = NULL,
                      debug = FALSE) {

  # forward options using x
  x <- list(
    hc_opts = hc_opts,
    theme = theme,
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
