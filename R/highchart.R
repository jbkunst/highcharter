

#' <Add Title>
#'
#' <Add Description>
#'
#' @import htmlwidgets
#'
#' @export
highchart <- function(hc, width = NULL, height = NULL) {

  # forward options using x
  x = list(
    hc = hc
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
