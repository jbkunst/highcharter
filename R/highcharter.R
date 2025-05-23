#' Create a Highcharts chart widget
#'
#' This function creates a Highchart chart using \pkg{htmlwidgets}. The
#' widget can be rendered on HTML pages generated from R Markdown, Shiny, or
#' other applications.
#'
#' @param hc_opts A `list` object containing options defined as
#'    \url{https://api.highcharts.com/highcharts/}.
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
#'   controlled by \code{"highcharter.google_fonts"} option.
#' @importFrom htmlwidgets createWidget sizingPolicy
#' @export
highchart <- function(hc_opts = list(),
                      theme = getOption("highcharter.theme"),
                      type = "chart",
                      width = NULL,
                      height = NULL,
                      elementId = NULL,
                      google_fonts = getOption("highcharter.google_fonts")) {
  
  assertthat::assert_that(type %in% c("chart", "stock", "map", "gantt"))

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
  }

  if (getOption("highcharter.rjson")) {
    attr(x, "TOJSON_FUNC") <- rjson::toJSON
  }

  # create widget
  hc <- htmlwidgets::createWidget(
    name = "highchart",
    x,
    width = width,
    height = height,
    package = "highcharter",
    elementId = elementId,
    sizingPolicy = htmlwidgets::sizingPolicy(
      defaultWidth = "100%",
      # knitr.figure = FALSE,
      browser.fill = TRUE,
      padding = 0
    )
  )

  # set sizing for `shinyRenderer`
  hc <- hc_size(hc, width = width, height = height)

  hc
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
  shinyWidgetOutput(outputId, "highchart", width, height, package = "highcharter")
}

#' Widget render function for use in Shiny
#'
#' @param expr A highchart expression.
#' @param env A environment.
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
#'    \url{https://api.highcharts.com/highcharts/}.
#' @param theme A \code{hc_theme} class object.
#' @param width A numeric input in pixels.
#' @param height  A numeric input in pixels.
#' @param elementId	Use an explicit element ID for the widget.
#'
#' @export
highchartzero <- function(hc_opts = list(),
                          theme = NULL,
                          width = NULL,
                          height = NULL,
                          elementId = NULL) {

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

#' @rdname highchartOutput
#' @export
highchartOutputZ <- function(outputId, width = "100%", height = "400px") {
  shinyWidgetOutput(outputId, "highchartzero", width, height, package = "highcharter")
}

#' @rdname renderHighchart
#' @export
renderHighchartZ <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) {
    expr <- substitute(expr)
  } # force quoted
  shinyRenderWidget(expr, highchartOutputZ, env, quoted = TRUE)
}
