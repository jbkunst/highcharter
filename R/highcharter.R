#' Create a Highcharts chart widget
#'
#' This function creates a Highchart chart using \pkg{htmlwidgets}. The
#' widget can be rendered on HTML pages generated from R Markdown, Shiny, or
#' other applications.
#'
#' @param hc_opts A \code{list} object containing options defined as 
#'    \url{http://api.highcharts.com/highcharts}.
#' @param theme A \code{hc_theme} class object
#' @param type A character value to set if use Highchart, Highstock or
#'   Highmap. Options are \code{"chart"}, \code{"stock"} and \code{"map"}.
#' @param width A numeric input in pixels.
#' @param height  A numeric input in pixels.
#' @param debug A boolean value if you want to print in the browser console the 
#'    parameters given to \code{highchart}.
#'      
#' @importFrom htmlwidgets createWidget sizingPolicy
#'
#' @export
highchart <- function(hc_opts = list(), theme = NULL,
                      type = "chart",
                      width = NULL, height = NULL,
                      debug = FALSE) {
  
  assertthat::assert_that(type %in% c("chart", "stock", "map"))
  
  opts <- getOption("highcharter.options", list())

  if (identical(hc_opts, list()))
    hc_opts <- opts$chart
  
  unfonts <- unique(c(.hc_get_fonts(hc_opts), .hc_get_fonts(theme))) 
  
  opts$chart <- NULL
  
  # forward options using x
  x <- list(
    hc_opts = hc_opts,
    theme = theme,
    conf_opts = opts,
    type = type,
    fonts = unfonts,
    debug = debug
    
  )
  
  # create widget
  htmlwidgets::createWidget(
    name = "highchart",
    x,
    width = width,
    height = height,
    package = "highcharter",
    sizingPolicy = htmlwidgets::sizingPolicy(defaultWidth = "100%",
                                             knitr.figure = FALSE,
                                             knitr.defaultWidth = "100%",
                                             browser.fill = TRUE)
  )
}

#' Widget output function for use in Shiny
#'
#' @param outputId The name of the input.
#' @param width A numeric input in pixels.
#' @param height  A numeric input in pixels. 
#'
#' @importFrom htmlwidgets shinyWidgetOutput 
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
#' @importFrom htmlwidgets shinyRenderWidget
#' @export
renderHighchart <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) {
    expr <- substitute(expr)
    } # force quoted
  shinyRenderWidget(expr, highchartOutput, env, quoted = TRUE)
}


#' Create a Highcharts chart widget
#'
#' This function creates a Highchart chart using \pkg{htmlwidgets}. The
#' widget can be rendered on HTML pages generated from R Markdown, Shiny, or
#' other applications.
#'
#' @param hc_opts A \code{list} object containing options defined as 
#'    \url{http://api.highcharts.com/highcharts}.
#' @param theme A \code{hc_theme} class object
#' @param width A numeric input in pixels.
#' @param height  A numeric input in pixels.
#' @param debug A boolean value if you want to print in the browser console the 
#'    parameters given to \code{highchart}.
#'
#' @export
highchart2 <- function(hc_opts = list(), theme = NULL,
                      width = NULL, height = NULL,
                      debug = FALSE) {
  
  unfonts <- unique(c(.hc_get_fonts(hc_opts), .hc_get_fonts(theme))) 
  
  # forward options using x
  x <- list(
    hc_opts = hc_opts,
    theme = theme,
    fonts = unfonts,
    debug = debug
    
  )
  
  # create widget
  htmlwidgets::createWidget(
    name = "highchart2",
    x,
    width = width,
    height = height,
    package = "highcharter",
    sizingPolicy = htmlwidgets::sizingPolicy(defaultWidth = "100%",
                                             knitr.figure = FALSE,
                                             knitr.defaultWidth = "100%",
                                             browser.fill = TRUE)
  )
}
