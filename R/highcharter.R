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
#' @param width A numeric width in pixels, or a CSS width such as `"100%"`.
#' @param height  A numeric input in pixels.
#' @param elementId	Use an explicit element ID for the widget.
#' @importFrom htmlwidgets createWidget sizingPolicy
#' @examples
#' highchart(width = "100%") |>
#'   hc_xAxis(categories = citytemp$month) |>
#'   hc_add_series(name = "Tokyo", data = citytemp$tokyo) |>
#'   hc_add_series(name = "London", data = citytemp$london) |>
#'   hc_title(text = "Monthly temperatures")
#'
#' # Stock navigation is available in the shared bundle.
#' prices <- data.frame(
#'   day = base::as.Date("2025-01-01") + 0:9,
#'   close = c(100, 102, 101, 104, 103, 106, 108, 107, 109, 112)
#' )
#' highchart(type = "stock", width = "100%") |>
#'   hc_add_series(prices, "line", hcaes(x = day, y = close), name = "Close")
#' @seealso [hchart()], [hcmap()], [highchartstock()]
#' @export
highchart <- function(
  hc_opts = list(),
  theme = getOption("highcharter.theme"),
  type = "chart",
  width = NULL,
  height = NULL,
  elementId = NULL
) {
  .highchart_widget(
    name = "highchart",
    hc_opts = hc_opts,
    theme = theme,
    type = type,
    width = width,
    height = height,
    elementId = elementId
  )
}

.highchart_widget <- function(
  name,
  hc_opts,
  theme,
  type,
  width,
  height,
  elementId
) {
  stopifnot(length(type) == 1L, type %in% c("chart", "stock", "map", "gantt"))

  if (identical(hc_opts, list())) {
    hc_opts <- getOption("highcharter.chart")
  }

  conf_opts <- list(lang = getOption("highcharter.lang"))
  conf_opts$global <- getOption("highcharter.global")

  # forward options using x
  x <- list(
    hc_opts = hc_opts,
    theme = theme,
    conf_opts = conf_opts,
    type = type,
    debug = getOption("highcharter.debug")
  )

  if (getOption("highcharter.debug")) {
    attr(x, "TOJSON_ARGS") <- list(pretty = getOption("highcharter.debug"))
  }

  if (getOption("highcharter.rjson")) {
    rlang::check_installed(
      "rjson",
      reason = "to use `options(highcharter.rjson = TRUE)`."
    )
    attr(x, "TOJSON_FUNC") <- rjson::toJSON
  }

  # create widget
  hc <- htmlwidgets::createWidget(
    name = name,
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

  hc <- .hc_apply_fonts(hc, "theme")
  hc <- .hc_apply_fonts(hc, "hc_opts")

  # set sizing for `shinyRenderer`
  hc <- hc_size(hc, width = width, height = height)

  hc
}

#' Create a Highcharts Stock widget with Stock Tools
#'
#' `highchartstock()` creates a Stock chart with the official Stock Tools GUI,
#' advanced annotations and technical indicators. Use `highchart(type = "stock")`
#' for a Stock chart without these additional interface assets.
#'
#' @inheritParams highchart
#' @examples
#' data(sample_matrix, package = "xts")
#' prices <- xts::as.xts(sample_matrix)
#' highchartstock(width = "100%") |>
#'   hc_add_series(prices, name = "Price", id = "price") |>
#'   hc_add_series(type = "sma", linkedTo = "price", name = "5-day mean",
#'                 params = list(period = 5)) |>
#'   hc_title(text = "Explore prices with Stock Tools")
#' @seealso [highchart()]
#' @export
highchartstock <- function(
  hc_opts = list(),
  theme = getOption("highcharter.theme"),
  width = NULL,
  height = NULL,
  elementId = NULL
) {
  .highchart_widget(
    name = "highchartstock",
    hc_opts = hc_opts,
    theme = theme,
    type = "stock",
    width = width,
    height = height,
    elementId = elementId
  )
}

#' Reports whether x is a highchart object
#'
#' @param x An object to test
#' @export
is.highchart <- function(x) {
  inherits(x, c("highchart", "highchartstock"))
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
  shinyWidgetOutput(
    outputId,
    "highchart",
    width,
    height,
    package = "highcharter"
  )
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

#' @rdname highchartOutput
#' @export
highchartStockOutput <- function(outputId, width = "100%", height = "400px") {
  shinyWidgetOutput(
    outputId,
    "highchartstock",
    width,
    height,
    package = "highcharter"
  )
}

#' @rdname renderHighchart
#' @export
renderHighchartStock <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) {
    expr <- substitute(expr)
  }
  shinyRenderWidget(expr, highchartStockOutput, env, quoted = TRUE)
}
