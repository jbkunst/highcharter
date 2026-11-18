validate_args <- function(name, lstargs) {
  lstargsnn <- lstargs[which(names(lstargs) == "")]
  lenlst <- length(lstargsnn)

  if (lenlst != 0) {
    chrargs <- lstargsnn |>
      unlist() |>
      as.character()

    chrargs <- paste0("'", chrargs, "'", collapse = ", ")

    txt <- ifelse(lenlst == 1, " is ", "s are ")

    stop(
      chrargs,
      " argument",
      txt,
      "not named in ",
      paste0("hc_", name),
      call. = FALSE
    )
  }
}

# Merge named objects recursively and replace arrays as a whole.
.merge_options <- function(base, overrides, keep_null = FALSE) {
  for (key in names(overrides)) {
    value <- overrides[[key]]
    if (
      is.list(base[[key]]) &&
        !is.null(names(base[[key]])) &&
        is.list(value) &&
        !is.null(names(value))
    ) {
      base[[key]] <- .merge_options(base[[key]], value, keep_null)
    } else if (is.null(value) && !keep_null) {
      base[[key]] <- NULL
    } else {
      base[key] <- overrides[key]
    }
  }
  base
}

# Merge named option objects in order, including NULL deletions.
.merge_hc_options <- function(...) {
  options <- list(...)
  if (any(vapply(options, function(x) is.null(names(x)), logical(1)))) {
    stop("All arguments must be named lists.", call. = FALSE)
  }
  Reduce(.merge_options, options, init = list())
}

# Named options update the primary axis. Unnamed axis objects replace the collection.
.hc_axis_options <- function(current, options) {
  # htmlwidgets unboxes atomic scalars, but Highcharts expects a category array.
  normalize_categories <- function(axis) {
    categories <- axis[["categories"]]
    if (is.atomic(categories) && length(categories) == 1L) {
      axis$categories <- as.list(unname(categories))
    }
    axis
  }
  if (!length(options)) {
    return(current)
  }
  if (!is.null(names(options))) {
    if (!all(nzchar(names(options)))) {
      stop("Supply named axis options or a list of axes.", call. = FALSE)
    }
    options <- normalize_categories(options)
    if (length(current) && is.null(names(current))) {
      current[[1L]] <- .merge_options(current[[1L]], options)
      return(current)
    }
    return(.merge_options(
      if (is.null(current)) list() else current,
      options
    ))
  }

  if (
    length(options) == 1L &&
      is.list(options[[1L]]) &&
      is.null(names(options[[1L]]))
  ) {
    options <- options[[1L]]
  }
  valid_axis <- function(x) is.list(x) && (!length(x) || rlang::is_named(x))
  if (!all(vapply(options, valid_axis, logical(1)))) {
    stop("Each axis must be a list of named Highcharts options.", call. = FALSE)
  }
  lapply(unclass(options), normalize_categories)
}

.hc_opt <- function(hc, name, ...) {
  stopifnot(is.highchart(hc))
  options <- list(...)
  current <- hc$x$hc_opts[[name]]
  if (name %in% c("xAxis", "yAxis", "zAxis")) {
    hc$x$hc_opts[[name]] <- .hc_axis_options(current, options)
  } else {
    validate_args(name, eval(substitute(alist(...))))
    hc$x$hc_opts[[name]] <- if (is.null(current)) {
      options
    } else {
      .merge_hc_options(current, options)
    }
  }

  # Setting fonts
  hc$x$fonts <- unique(c(hc$x$fonts, .hc_get_fonts(hc$x$hc_opts)))

  hc
}

.hc_tooltip_table <- function(hc, ...) {
  # https://stackoverflow.com/a/22327749/829971
  hc |>
    highcharter::hc_tooltip(
      shared = TRUE,
      useHTML = TRUE,
      headerFormat = "<small>{point.key}</small><table>",
      pointFormat = "<tr><td style=\"color: {series.color}\">{series.name}: </td><td style=\"text-align: right\"><b>{point.y}</b></td></tr>",
      footerFormat = "</table>"
    )
}

.hc_tooltip_sort <- function(hc, ...) {
  # https://stackoverflow.com/a/16954666/829971
  hc |>
    highcharter::hc_tooltip(
      shared = TRUE,
      formatter = JS(
        "function(tooltip){
          function isArray(obj) {
          return Object.prototype.toString.call(obj) === '[object Array]';
          }

          function splat(obj) {
          return isArray(obj) ? obj : [obj];
          }

          var items = this.points || splat(this), series = items[0].series, s;

          // sort the values
          items.sort(function(a, b){
          return ((a.y < b.y) ? -1 : ((a.y > b.y) ? 1 : 0));
          });
          items.reverse();

          return tooltip.defaultFormatter.call(this, tooltip);
        }"
      )
    )
}

#' Helper to create charts in tooltips.
#'
#' @details This function needs to be used in the `pointFormatter` argument
#' inside of `hc_tooltip` function an `useHTML = TRUE` option.
#'
#' @param accesor A string indicating the name of the column where the data is.
#' @param hc_opts A list of options using the  \url{https://api.highcharts.com/highcharts/}
#'   syntax.
#' @param width	A numeric input in pixels indicating the with of the tooltip.
#' @param height	A numeric input in pixels indicating the height of the tooltip.
#'
#' @importFrom stringr str_glue
#' @importFrom htmlwidgets JS
#' @examples
#'
#' require(dplyr)
#' require(purrr)
#' if (requireNamespace("gapminder", quietly = TRUE)) {
#' data(gapminder, package = "gapminder")
#'
#' gp <- gapminder |>
#'   arrange(desc(year)) |>
#'   distinct(country, .keep_all = TRUE)
#'
#' gp2 <- gapminder |>
#'   group_nest(country) |>
#'   mutate(
#'     data = map(data, mutate_mapping, hcaes(x = lifeExp, y = gdpPercap), drop = TRUE),
#'     data = map(data, list_parse)
#'   ) |>
#'   rename(ttdata = data)
#'
#' gptot <- left_join(gp, gp2)
#'
#' hc <- hchart(
#'   gptot,
#'   "point",
#'   hcaes(
#'     lifeExp,
#'     gdpPercap,
#'     name = country,
#'     size = pop,
#'     group = continent
#'   )
#' ) |>
#'   hc_yAxis(type = "logarithmic")
#'
#' hc |>
#'   hc_tooltip(useHTML = TRUE, pointFormatter = tooltip_chart(accesor = "ttdata"))
#'
#' hc |>
#'   hc_tooltip(useHTML = TRUE, pointFormatter = tooltip_chart(
#'     accesor = "ttdata",
#'     hc_opts = list(chart = list(type = "column"))
#'   ))
#'
#' hc |>
#'   hc_tooltip(
#'     useHTML = TRUE,
#'     positioner = JS("function () { return { x: this.chart.plotLeft + 10, y: 10}; }"),
#'     pointFormatter = tooltip_chart(
#'       accesor = "ttdata",
#'       hc_opts = list(
#'         title = list(text = "point.country"),
#'         xAxis = list(title = list(text = "lifeExp")),
#'         yAxis = list(title = list(text = "gdpPercap"))
#'       )
#'     )
#'   )
#'
#' hc |>
#'   hc_tooltip(
#'     useHTML = TRUE,
#'     pointFormatter = tooltip_chart(
#'       accesor = "ttdata",
#'       hc_opts = list(
#'         legend = list(enabled = TRUE),
#'         series = list(list(color = "gray", name = "point.name"))
#'       )
#'     )
#'   )
#'
#'
#' }
#' @export
tooltip_chart <- function(
  accesor = NULL,
  hc_opts = NULL,
  width = 250,
  height = 150
) {
  stopifnot(is.character(accesor), length(accesor) == 1L)

  if (is.null(hc_opts)) {
    hc_opts[["series"]][[1]] <- list(data = sprintf("point.%s", accesor))
  } else {
    if (!has_name(hc_opts, "series")) {
      hc_opts[["series"]][[1]] <- list()
    }
    hc_opts[["series"]][[1]][["data"]] <- sprintf("point.%s", accesor)
  }

  defaults <- getOption("highcharter.chart")
  fields <- c("title", "yAxis", "xAxis", "credits", "exporting")
  hc_opts <- .merge_hc_options(
    defaults[intersect(names(defaults), fields)],
    list(chart = list(backgroundColor = "transparent")),
    list(
      legend = list(enabled = FALSE),
      plotOptions = list(series = list(animation = FALSE))
    ),
    hc_opts
  )

  if (!has_name(hc_opts[["series"]][[1]], "color")) {
    hc_opts[["series"]][[1]][["color"]] <- "point.color"
  }

  hcopts <- toJSON(
    x = hc_opts,
    pretty = TRUE,
    auto_unbox = TRUE,
    json_verbatim = TRUE,
    force = TRUE,
    null = "null",
    na = "null"
  )
  hcopts <- as.character(hcopts)

  # fix point.color
  hcopts <- str_replace(hcopts, "\\{point.color\\}", "point.color")

  # remove "\"" to have access to the point object
  ts <- stringr::str_extract_all(hcopts, "\"point\\.\\w+\"") |> unlist()
  for (t in ts) {
    hcopts <- str_replace(hcopts, t, str_replace_all(t, "\"", ""))
  }

  # remove "\"" in the options
  ts <- stringr::str_extract_all(hcopts, "\"\\w+\":") |> unlist()
  for (t in ts) {
    t2 <- str_replace_all(t, "\"", "")
    hcopts <- str_replace(hcopts, t, t2)
  }

  jss <- "function() {{
  var point = this;
  console.log(point);
  console.log(point.{accesor});
  setTimeout(function() {{

  $(\"#tooltipchart-{id}\").highcharts(hcopts);

  }, 0);

  return '<div id=\"tooltipchart-{id}\" style=\"width: {w}px; height: {h}px;\"></div>';

  }}"

  jsss <- stringr::str_glue(
    jss,
    id = random_id(),
    w = width,
    h = height,
    accesor = accesor
  )

  jsss <- stringr::str_replace(jsss, "hcopts", hcopts)

  JS(jsss)
}

#' Helper for make table in tooltips
#'
#' Helper to make table in tooltips for the \code{pointFormat}
#' parameter in \code{hc_tooltip}
#'
#' @param x A string vector with description text
#' @param y A string with accessors example: \code{point.series.name},
#'   \code{point.x}
#' @param title A title tag with accessors or string
#' @param img Image tag
#' @param ... html attributes for the table element
#'
#' @examples
#'
#' x <- c("Income:", "Genre", "Runtime")
#' y <- c(
#'   "$ {point.y}", "{point.series.options.extra.genre}",
#'   "{point.series.options.extra.runtime}"
#' )
#'
#' tooltip_table(x, y)
#' @importFrom purrr map2
#' @importFrom htmltools tags tagList
#' @export
tooltip_table <- function(x, y, title = NULL, img = NULL, ...) {
  stopifnot(length(x) == length(y))

  tbl <- map2(x, y, function(x, y) {
    tags$tr(
      tags$th(x),
      tags$td(y)
    )
  })

  tbl <- tags$table(tbl, ...)

  if (!is.null(title)) {
    tbl <- tagList(title, tbl)
  }

  if (!is.null(img)) {
    tbl <- tagList(tbl, img)
  }

  as.character(tbl)
}

#' Setting \code{elementId}
#'
#' Function to modify the \code{id} for the container.
#'
#' @param hc A `highchart` `htmlwidget` object.
#' @param id A string
#'
#' @examples
#'
#' hchart(rnorm(10)) |>
#'   hc_elementId("newid")
#' @export
hc_elementId <- function(hc, id = NULL) {
  stopifnot(is.highchart(hc))

  hc$elementId <- as.character(id)

  hc
}

#' Changing the size of a `highchart` object
#'
#' @param hc A `highchart` `htmlwidget` object.
#' @param width	A numeric input in pixels.
#' @param height	A numeric input in pixels.
#'
#' @examples
#'
#' hc <- hchart(ts(rnorm(100)), showInLegend = FALSE)
#'
#' hc_size(hc, 200, 200)
#' @export
hc_size <- function(hc, width = NULL, height = NULL) {
  stopifnot(is.highchart(hc))

  if (!is.null(width)) {
    # Set for both static renderer and `shinyRenderer`,
    # where width is handled by Highcharts in the htmlwidget.
    hc$width <- width
    hc <- .hc_opt(hc, "chart", width = width)
  }

  if (!is.null(height)) {
    # Set for both static renderer and `shinyRenderer`,
    # where height is handled by Highcharts in the htmlwidget.
    hc$height <- height
    hc <- .hc_opt(hc, "chart", height = height)
  }

  hc
}

#' Setting Motion options to highcharts objects
#'
#' The Motion Highcharts Plugin adds an interactive HTML5 player
#' to any Highcharts chart (Highcharts, Highmaps and Highstock).
#'
#' @param hc A \code{highchart} \code{htmlwidget} object.
#' @param enabled Enable the motion plugin.
#' @param startIndex start index, default to 0.
#' @param ... Arguments defined in \url{https://github.com/TorsteinHonsi/Motion-Highcharts-Plugin/wiki}.
#'
#' @export
hc_motion <- function(hc, enabled = TRUE, startIndex = 0, ...) {
  hc <- .hc_opt(hc, "motion", enabled = enabled, startIndex = startIndex, ...)

  if (enabled) {
    dep <- htmltools::htmlDependency(
      name = "highcharts-motion",
      version = "1.0.0",
      src = c(
        file = system.file(
          "htmlwidgets/lib/highcharts",
          package = "highcharter"
        )
      ),
      script = "plugins/motion.js",
      stylesheet = "css/motion.css"
    )
    hc$dependencies <- c(hc$dependencies, list(dep))
  }

  hc
}

#' Arrange vertical axes in stacked panels
#'
#' @param naxis Number of axis an integer.
#' @param heights A numeric vector. This values will be normalized.
#' @param sep A numeric value for the separation (in percentage) for the panes.
#' @param offset A numeric value (in percentage).
#' @param turnopposite A logical value to turn the side of each axis or not.
#' @param ... Arguments defined in \url{https://api.highcharts.com/highcharts/yAxis}.
#'
#' @examples
#'
#' highchart() |>
#'   hc_yAxis(create_axis(naxis = 2, heights = c(2, 1))) |>
#'   hc_add_series(data = c(1, 3, 2), yAxis = 0) |>
#'   hc_add_series(data = c(20, 40, 10), yAxis = 1)
#'
#' highchart() |>
#'   hc_yAxis(create_axis(naxis = 3, lineWidth = 2, title = list(text = NULL))) |>
#'   hc_add_series(data = c(1, 3, 2)) |>
#'   hc_add_series(data = c(20, 40, 10), type = "area", yAxis = 1) |>
#'   hc_add_series(data = c(200, 400, 500), yAxis = 2) |>
#'   hc_add_series(data = c(500, 300, 400), type = "areaspline", yAxis = 2)
#'
#' @export
create_axis <- function(
  naxis = 2,
  heights = 1,
  sep = 0.01,
  offset = 0,
  turnopposite = TRUE,
  ...
) {
  stopifnot(
    length(naxis) == 1L,
    is.finite(naxis),
    naxis >= 1,
    naxis == as.integer(naxis),
    length(heights) > 0L,
    all(is.finite(heights)),
    all(heights > 0),
    length(sep) == 1L,
    is.finite(sep),
    sep >= 0
  )
  heights <- rep_len(heights, naxis)
  total <- 1 + sep * (naxis - 1)
  heights <- heights / sum(heights) / total
  tops <- c(0, head(cumsum(heights + sep / total), -1L))
  options <- list(...)
  lapply(seq_len(naxis), function(i) {
    axis <- list(
      height = paste0(round(100 * heights[i], 4), "%"),
      top = paste0(round(100 * tops[i], 4), "%"),
      offset = rep_len(offset, naxis)[i]
    )
    if (turnopposite) {
      axis$opposite <- i %% 2L == 0L
    }
    for (key in names(options)) {
      value <- options[[key]]
      if (is.atomic(value) && length(value) == naxis) {
        value <- value[i]
      }
      axis[key] <- list(value)
    }
    axis
  })
}

#' Compatibility alias for multiple y axes
#'
#' @inheritParams hc_yAxis
#' @export
hc_yAxis_multiples <- function(hc, ...) {
  .Deprecated("hc_yAxis")
  hc_yAxis(hc, ...)
}
