#' Create a Highcharts chart widget
#'
#' This function creates a Highchart chart using \pkg{htmlwidgets}. The
#' widget can be rendered on HTML pages generated from R Markdown, Shiny, or
#' other applications.
#'
#' @param hc_opts A `list` object containing options defined as
#'    \url{http://api.highcharts.com/highcharts}.
#' @param theme A \code{hc_theme} class object-
#' @param type A character value to set if use Highchart, Highstock or
#'   Highmap. Options are \code{"chart"}, \code{"stock"} and \code{"map"}.
#' @param width A numeric input in pixels.
#' @param height  A numeric input in pixels.
#' @param elementId	Use an explicit element ID for the widget.
#' @param google_fonts A boolean value. If TRUE (default), adds a reference to the
#'   Google Fonts API to the HTML head, downloading CSS for the font families
#'   defined in the Highcharts theme from https://fonts.googleapis.com. Set to
#'   FALSE if you load your own fonts using CSS. This option as default is
#'   controled by \code{"highcharter.google_fonts"} option
#' @importFrom htmlwidgets createWidget sizingPolicy
#' @export
highchart <- function(hc_opts = list(),
                      theme = getOption("highcharter.theme"),
                      type = "chart",
                      width = NULL,
                      height = NULL,
                      elementId = NULL,
                      google_fonts = getOption("highcharter.google_fonts")) {
  assertthat::assert_that(type %in% c("chart", "stock", "map"))

  opts <- .join_hc_opts()

  if (identical(hc_opts, list())) {
    hc_opts <- opts$chart
  }

  unfonts <- NULL
  if (google_fonts) {
    unfonts <- unique(c(.hc_get_fonts(hc_opts), .hc_get_fonts(theme)))
  }

  opts$chart <- NULL

  # forward options using x
  x <- list(
    hc_opts = hc_opts,
    theme = theme,
    conf_opts = opts,
    type = type,
    fonts = unfonts,
    debug = getOption("highcharter.debug")
  )

  if (getOption("highcharter.debug")) {
    attr(x, "TOJSON_ARGS") <- list(pretty = getOption("highcharter.debug"))
  } else if (getOption("highcharter.rjson")) {
    attr(x, 'TOJSON_FUNC') = rjson::toJSON
  }

  # create widget
  htmlwidgets::createWidget(
    name = "highchart",
    x,
    width = width,
    height = height,
    package = "highcharter",
    elementId = elementId,
    sizingPolicy = htmlwidgets::sizingPolicy(
      defaultWidth = "100%",
      knitr.figure = FALSE,
      browser.fill = TRUE,
      padding = 0
    )
  )
}

#' Reports whether x is a highchart object
#'
#' @param x An object to test
#' @export
is.highchart <- function(x) {
  inherits(x, "highchart") || inherits(x, "highchart2") || inherits(x, "highchartzero")
}

#' Widget output function for use in Shiny
#'
#' @param outputId The name of the input.
#' @param width A numeric input in pixels.
#' @param height  A numeric input in pixels.
#'
#' @importFrom htmlwidgets shinyWidgetOutput
#' @export
highchartOutput <- function(outputId, width = "100%", height = "400px") {
  shinyWidgetOutput(outputId, "highchart", width, height,
    package = "highcharter"
  )
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
#' This widgets don't support options yet.
#'
#' This function creates a Highchart chart using \pkg{htmlwidgets}. The
#' widget can be rendered on HTML pages generated from R Markdown, Shiny, or
#' other applications.
#'
#' @param hc_opts A `list` object containing options defined as
#'    \url{http://api.highcharts.com/highcharts}.
#' @param theme A \code{hc_theme} class object
#' @param width A numeric input in pixels.
#' @param height  A numeric input in pixels.
#' @param elementId	Use an explicit element ID for the widget.
#' @param debug A boolean value if you want to print in the browser console the
#'    parameters given to `highchart`.
#' @param google_fonts A boolean value. If TRUE (default), adds a reference to the
#'   Google Fonts API to the HTML head, downloading CSS for the font families
#'   defined in the Highcharts theme from https://fonts.googleapis.com. Set to
#'   FALSE if you load your own fonts using CSS.
#'
#' @export
highchart2 <- function(hc_opts = list(),
                       theme = NULL,
                       width = NULL,
                       height = NULL,
                       elementId = NULL,
                       debug = FALSE,
                       google_fonts = getOption("highcharter.google_fonts")) {
  unfonts <- NULL
  if (google_fonts) {
    unfonts <- unique(c(.hc_get_fonts(hc_opts), .hc_get_fonts(theme)))
  }

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
    elementId = elementId,
    sizingPolicy = htmlwidgets::sizingPolicy(
      defaultWidth = "100%",
      knitr.figure = FALSE,
      knitr.defaultWidth = "100%",
      browser.fill = TRUE
    )
  )
}

#' @rdname highchartOutput
#' @export
highchartOutput2 <- function(outputId, width = "100%", height = "400px") {
  shinyWidgetOutput(outputId, "highchart2", width, height,
    package = "highcharter"
  )
}

#' @rdname renderHighchart
#' @export
renderHighchart2 <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) {
    expr <- substitute(expr)
  } # force quoted
  shinyRenderWidget(expr, highchartOutput2, env, quoted = TRUE)
}

#' @rdname highchart2
#' @export
highchartzero <- function(hc_opts = list(),
                          theme = NULL,
                          width = NULL,
                          height = NULL,
                          elementId = NULL) {

  # unfonts <- unique(c(.hc_get_fonts(hc_opts), .hc_get_fonts(theme)))
  # forward options using x
  x <- list(
    hc_opts = hc_opts
  )

  # create widget
  htmlwidgets::createWidget(
    name = "highchartzero",
    x,
    width = width,
    height = height,
    package = "highcharter",
    elementId = elementId,
    sizingPolicy = htmlwidgets::sizingPolicy(
      defaultWidth = "100%",
      knitr.figure = FALSE,
      knitr.defaultWidth = "100%",
      browser.fill = TRUE
    )
  )
}
