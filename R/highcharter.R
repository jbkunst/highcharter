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
#' tokyo <- subset(city_weather, city == "Tokyo")
#' highchart(width = "100%") |>
#'   hc_add_series(tokyo, "line", hcaes(date, temp_mean), name = "Tokyo") |>
#'   hc_xAxis(type = "datetime") |>
#'   hc_title(text = "Daily mean temperature in Tokyo, 2025")
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
    type = type
  )

  attr(x, "TOJSON_FUNC") <- widget_json

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

# htmlwidgets calls this for both standalone widgets and Shiny outputs.
widget_json <- function(
  x,
  pretty = FALSE,
  digits = getOption("shiny.json.digits", 16L)
) {
  yyjsonr::write_json_str(
    widget_json_value(x),
    pretty = pretty,
    digits_signif = if (is.finite(digits)) digits else -1L,
    auto_unbox = TRUE,
    dataframe = "columns",
    name_repair = "minimal",
    json_verbatim = TRUE
  )
}

# Preserve the shapes used by htmlwidgets for options and point metadata.
widget_json_value <- function(x) {
  if (is.raw(x)) {
    return(jsonlite::base64_enc(x))
  }
  if (is.complex(x)) {
    x <- as.character(x)
  }
  if (is.list(x) && !inherits(x, "POSIXlt") && !is.array(x)) {
    fields <- lapply(x, widget_json_value)
    if (is.data.frame(x) && nrow(x) == 1L) {
      fields <- lapply(fields, I)
    }
    return(fields)
  }
  if (is.null(attributes(x))) {
    return(x)
  }
  if (inherits(x, "POSIXt")) {
    stamp <- format(as.POSIXct(x), "%Y-%m-%dT%H:%M:%SZ", tz = "UTC")
    x <- if (inherits(x, "AsIs")) I(stamp) else stamp
  }
  if (length(dim(x)) > 2L) {
    return(lapply(asplit(x, 1L), widget_json_value))
  }
  if (length(x) && !is.null(names(x)) && is.null(dim(x))) {
    names(x)[is.na(names(x))] <- ""
    return(as.list(x))
  }
  x
}

#' Create a Highcharts Stock widget with Stock Tools
#'
#' `highchartstock()` creates a Stock chart with the official Stock Tools GUI,
#' advanced annotations and technical indicators. Use `highchart(type = "stock")`
#' for a Stock chart without these additional interface assets.
#'
#' @inheritParams highchart
#' @examplesIf requireNamespace("xts", quietly = TRUE) && requireNamespace("quantmod", quietly = TRUE)
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
