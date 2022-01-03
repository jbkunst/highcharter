#' Adding data to highchart objects
#'
#' @param hc A `highchart` `htmlwidget` object.
#' @param data An R object like numeric, list, ts, xts, etc.
#' @param ... Arguments defined in \url{https://api.highcharts.com/highcharts/plotOptions.series}.
#' @examples
#'
#' highchart() %>%
#'   hc_add_series(data = abs(rnorm(5)), type = "column") %>%
#'   hc_add_series(data = purrr::map(0:4, function(x) list(x, x)), type = "scatter", color = "orange")
#' @export
hc_add_series <- function(hc, data = NULL, ...) {

  # assertthat::assert_that(is.highchart(hc))

  UseMethod("hc_add_series", data)
}


#' @export
hc_add_series.default <- function(hc, ...) {

  # assertthat::assert_that(is.highchart(hc))

  if (getOption("highcharter.verbose")) {
    message("hc_add_series.default")
  }

  validate_args("add_series", eval(substitute(alist(...))))

  hc$x$hc_opts$series <- append(hc$x$hc_opts$series, list(list(...)))

  hc
}


#' `hc_add_series` for numeric objects
#' @param hc A `highchart` `htmlwidget` object.
#' @param data A numeric object
#' @param ... Arguments defined in \url{https://api.highcharts.com/highcharts/plotOptions.series}.
#' @export
hc_add_series.numeric <- function(hc, data, ...) {
  if (getOption("highcharter.verbose")) {
    message("hc_add_series.numeric")
  }

  data <- fix_1_length_data(data)

  hc_add_series.default(hc, data = data, ...)
}


#' hc_add_series for time series objects
#' @param hc A `highchart` `htmlwidget` object.
#' @param data A time series `ts` object.
#' @param ... Arguments defined in \url{https://api.highcharts.com/highcharts/plotOptions.series}.
#' @importFrom zoo as.Date
#' @importFrom stats time
#' @export
hc_add_series.ts <- function(hc, data, ...) {
  if (getOption("highcharter.verbose")) {
    message("hc_add_series.ts")
  }

  # http://stackoverflow.com/questions/29202021/
  timestamps <- data %>%
    stats::time() %>%
    zoo::as.Date() %>%
    datetime_to_timestamp()

  series <- list_parse2(data.frame(timestamps, as.vector(data)))

  hc_add_series(hc, data = series, ...)
}


#' hc_add_series for xts objects
#' @param hc A `highchart` `htmlwidget` object.
#' @param data A `xts` object.
#' @param ... Arguments defined in \url{https://api.highcharts.com/highcharts/plotOptions.series}.
#' @importFrom xts is.xts
#' @importFrom quantmod is.OHLC
#' @export
hc_add_series.xts <- function(hc, data, ...) {
  if (getOption("highcharter.verbose")) {
    message("hc_add_series.xts")
  }

  if (is.OHLC(data)) {
    return(hc_add_series.ohlc(hc, data, ...))
  }

  timestamps <- datetime_to_timestamp(time(data))

  series <- list_parse2(data.frame(timestamps, as.vector(data)))

  hc_add_series(hc, data = series, ...)
}


#' @rdname hc_add_series.xts
#' @param type The way to show the `xts` object. Can be 'candlestick' or 'ohlc'.
#' @export
hc_add_series.ohlc <- function(hc, data, type = "candlestick", ...) {
  if (getOption("highcharter.verbose")) {
    message("hc_add_series.xts.ohlc")
  }

  time <- datetime_to_timestamp(time(data))
  xdf <- cbind(time, as.data.frame(
    quantmod::OHLC(data)
  ))
  xds <- list_parse2(xdf)

  nm <- ifelse(!is.null(list(...)[["name"]]),
    list(...)[["name"]],
    str_extract(names(data)[1], "^[A-Za-z]+")
  )

  hc_add_series(hc, data = xds, name = nm, type = type, ...)
}


#' hc_add_series for forecast objects
#' @param hc A `highchart` `htmlwidget` object.
#' @param data A `forecast` object.
#' @param addOriginal Logical value to add the original series or not.
#' @param addLevels Logical value to show predictions bands.
#' @param fillOpacity The opacity of bands.
#' @param name The name of the series.
#' @param ... Arguments defined in
#'   \url{https://api.highcharts.com/highcharts/chart}.
#' @export
hc_add_series.forecast <- function(hc, data, addOriginal = FALSE,
                                   addLevels = TRUE, fillOpacity = 0.1, name = NULL, ...) {
  if (getOption("highcharter.verbose")) {
    message("hc_add_series.forecast")
  }

  rid <- random_id()
  method <- data$method

  if (addOriginal) {
    hc <- hc_add_series(hc, data$x, name = ifelse(is.null(name), method, name), zIndex = 3, ...)
  }


  hc <- hc_add_series(hc, data$mean, name = ifelse(is.null(name), method, name), zIndex = 2, id = rid, ...)

  if (addLevels) {
    tmf <- datetime_to_timestamp(zoo::as.Date(time(data$mean)))
    nmf <- paste(ifelse(is.null(name), method, name), "level", data$level)

    for (m in seq(ncol(data$upper))) {
      dfbands <- tibble(
        t = tmf,
        l = as.vector(data$lower[, m]),
        u = as.vector(data$upper[, m])
      )

      hc <- hc %>%
        hc_add_series(
          data = list_parse2(dfbands),
          name = nmf[m],
          type = "arearange",
          fillOpacity = fillOpacity,
          zIndex = 1,
          lineWidth = 0,
          linkedTo = rid,
          ...
        )
    }
  }


  hc
}


#' hc_add_series for density objects
#' @param hc A `highchart` `htmlwidget` object.
#' @param data A `density` object.
#' @param ... Arguments defined in \url{https://api.highcharts.com/highcharts/plotOptions.series}.
#' @export
hc_add_series.density <- function(hc, data, ...) {
  if (getOption("highcharter.verbose")) {
    message("hc_add_series.density")
  }

  data <- list_parse(data.frame(cbind(x = data$x, y = data$y)))

  hc_add_series(hc, data = data, ...)
}


#' hc_add_series for character and factor objects
#' @param hc A `highchart` `htmlwidget` object.
#' @param data A \code{character} or \code{factor} object.
#' @param ... Arguments defined in \url{https://api.highcharts.com/highcharts/plotOptions.series}.
#' @export
hc_add_series.character <- function(hc, data, ...) {
  if (getOption("highcharter.verbose")) {
    message("hc_add_series.character")
  }

  series <- data %>%
    table() %>%
    as.data.frame(stringsAsFactors = FALSE) %>%
    setNames(c("name", "y")) %>%
    list_parse()

  hc_add_series(hc, data = series, ...)
}


#' @rdname hc_add_series.character
#' @export
hc_add_series.factor <- hc_add_series.character

#' hc_add_series for geo_json & geo_list objects
#' @param hc A `highchart` `htmlwidget` object.
#' @param data A \code{geo_json} or \code{geo_list} object.
#' @param type Type of series. Can be 'mapline', 'mapoint'.
#' @param ... Arguments defined in \url{https://api.highcharts.com/highcharts/plotOptions.series}.
#' @export
hc_add_series.geo_json <- function(hc, data, type = NULL, ...) {
  if (getOption("highcharter.verbose")) {
    message("hc_add_series.geo_json")
  }

  stopifnot(hc$x$type == "map", !is.null(type))

  hc_add_series.default(hc, data = data, geojson = TRUE, type = type, ...)
}

#' @rdname hc_add_series.geo_json
#' @export
hc_add_series.geo_list <- function(hc, data, type = NULL, ...) {
  if (getOption("highcharter.verbose")) {
    message("hc_add_series.geo_list")
  }

  stopifnot(hc$x$type == "map", !is.null(type))

  hc_add_series.default(hc, data = data, geojson = TRUE, type = type, ...)
}

#' hc_add_series for lm and loess objects
#' @param hc A `highchart` `htmlwidget` object.
#' @param data A \code{lm} or \code{loess} object.
#' @param type The type of the series: line, spline.
#' @param color A stringr color.
#' @param fillOpacity fillOpacity to the confidence interval.
#' @param ... Arguments defined in
#'   \url{https://api.highcharts.com/highcharts/chart}.
#' @importFrom broom augment
#' @importFrom rlang .data
#' @export
hc_add_series.lm <- function(hc, data, type = "line", color = "#5F83EE", fillOpacity = 0.1, ...) {
  if (getOption("highcharter.verbose")) {
    message(sprintf("hc_add_series.%s", class(data)))
  }

  data2 <- data %>%
    augment() %>%
    as.matrix.data.frame() %>%
    as.data.frame() %>%
    tibble::as_tibble()
  data2 <- arrange_(data2, .dots = names(data2)[2])
  data2 <- mutate(data2, x = names(data2)[2])
  data2 <- select(data2, !!!c(names(data2)[1]), .data$x, .data$.fitted, .data$.se.fit)

  rid <- random_id()

  hc %>%
    hc_add_series(data2,
      type = type, hcaes_("x", ".fitted"),
      id = rid, color = color, ...
    ) %>%
    hc_add_series(data2,
      type = "arearange",
      hcaes_("x",
        low = ".fitted - 2 * .se.fit",
        high = ".fitted + 2 * .se.fit"
      ),
      color = hex_to_rgba(color, fillOpacity),
      linkedTo = rid, zIndex = -2, ...
    )
}

#' @rdname hc_add_series.lm
#' @export
hc_add_series.loess <- hc_add_series.lm

#' hc_add_series for data frames objects
#' @param hc A `highchart` `htmlwidget` object.
#' @param data A `data.frame` object.
#' @param type The type of the series: line, bar, etc.
#' @param mapping The mapping, same idea as \code{ggplot2}.
#' @param fast convert to json during the composition of a highchart object
#' @param ... Arguments defined in
#'   \url{https://api.highcharts.com/highcharts/chart}.
#' @importFrom rlang .data
#' @export
hc_add_series.data.frame <- function(hc, data, type = NULL, mapping = hcaes(), fast = FALSE, ...) {
  if (getOption("highcharter.verbose")) {
    message("hc_add_series.data.frame")
  }

  if (length(mapping) == 0) {
    if (has_name(data, "series")) {
      data <- rename(data, seriess = .data$series)
    }

    return(hc_add_series(hc, data = list_parse(data), type = type, ...))
  }

  data <- mutate_mapping(data, mapping)

  series <- data_to_series(data, mapping, type = type, fast = fast, ...)

  hc_add_series_list(hc, series)
}

#' Define aesthetic mappings.
#' Similar in spirit to \code{ggplot2::aes}
#' @param x,y,... List of name value pairs giving aesthetics to map to
#'   variables. The names for x and y aesthetics are typically omitted because
#'   they are so common; all other aesthetics must be named.
#' @importFrom rlang enexprs is_missing
#' @examples
#'
#' hcaes(x = xval, color = colorvar, group = grvar)
#' @export
hcaes <- function(x, y, ...) {
  # taken from https://github.com/tidyverse/ggplot2/commit/d69762269787ed0799ab4fb1f35638cc46b5b7e6
  exprs <- rlang::enexprs(x = x, y = y, ...)

  is_missing <- vapply(exprs, rlang::is_missing, logical(1))

  mapping <- structure(exprs[!is_missing], class = "uneval")

  class(mapping) <- c("hcaes", class(mapping))

  mapping
}

#' Define aesthetic mappings using strings.
#' Similar in spirit to \code{ggplot2::aes_string}
#' @param x,y,... List of name value pairs giving aesthetics to map to
#'   variables. The names for x and y aesthetics are typically omitted because
#'   they are so common; all other aesthetics must be named.
#' @examples
#' hchart(mtcars, "point", hcaes_string("hp", "mpg", group = "cyl"))
#'
#' hcaes_string(x = "xval", color = "colorvar", group = "grvar")
#' @export
hcaes_string <- function(x, y, ...) {
  mapping <- list(...)

  if (!missing(x)) {
    mapping["x"] <- list(x)
  }

  if (!missing(y)) {
    mapping["y"] <- list(y)
  }

  mapping <- lapply(mapping, function(x) {
    if (is.character(x)) {
      parse(text = x)[[1]]
    }
    else {
      x
    }
  })

  mapping <- structure(mapping, class = "uneval")

  mapping <- mapping[names(mapping) != ""]

  class(mapping) <- c("hcaes", class(mapping))

  mapping
}

#' @rdname hcaes_string
#' @export
hcaes_ <- hcaes_string


#' Modify data frame according to mapping
#' @param data A data frame object.
#' @param mapping A mapping from \code{hcaes} function.
#' @param drop A logical argument to you drop variables or not. Default is
#' \code{FALSE}
#' @importFrom lubridate is.Date
#' @importFrom rlang "!!!" "!!" ":=" parse_quo syms .data
#' @examples
#'
#' df <- head(mtcars)
#' mutate_mapping(data = df, mapping = hcaes(x = cyl, y = wt + cyl, group = gear))
#' mutate_mapping(data = df, mapping = hcaes(x = cyl, y = wt), drop = TRUE)
#' @export
mutate_mapping <- function(data, mapping, drop = FALSE) {
  stopifnot(is.data.frame(data), inherits(mapping, "hcaes"), inherits(drop, "logical"))

  # https://stackoverflow.com/questions/45359917/dplyr-0-7-equivalent-for-deprecated-mutate
  # https://www.johnmackintosh.com/2018-02-19-theory-free-tidyeval/

  tran <- as.character(mapping)
  newv <- names(mapping)
  list_names <- setNames(tran, newv) %>% lapply(rlang::parse_quo, env = globalenv())

  data <- dplyr::mutate(data, !!!list_names)
  # Reserverd  highcharts names (#241)
  if (has_name(data, "series")) {
    data <- dplyr::rename(data, seriess = .data$series)
  }

  if (drop) {
    newv <- rlang::syms(newv)
    data <- dplyr::select(data, !!!newv)
  }

  data
}

add_arg_to_df <- function(data, ...) {
  datal <- as.list(data)

  l <- map_if(list(...), function(x) is.list(x), list)

  datal <- append(datal, l)

  as_tibble(datal)
}

#' @importFrom dplyr mutate do arrange_
#' @importFrom tibble tibble tibble_
data_to_series <- function(data, mapping, type, fast = FALSE, ...) {

  # check type and fix
  type <- ifelse(type == "point", "scatter", type)
  type <- ifelse((has_name(mapping, "size") | has_name(mapping, "z")) & type == "scatter",
    "bubble", type
  )

  # heatmap
  if (type == "heatmap") {
    if (!is.numeric(data[["x"]])) {
      data[["xf"]] <- as.factor(data[["x"]])
      data[["x"]] <- as.numeric(as.factor(data[["x"]])) - 1
    }
    if (!is.numeric(data[["y"]])) {
      data[["yf"]] <- as.factor(data[["y"]])
      data[["y"]] <- as.numeric(as.factor(data[["y"]])) - 1
    }
  }

  # x
  if (has_name(mapping, "x")) {
    if (is.Date(data[["x"]])) {
      data[["x"]] <- datetime_to_timestamp(data[["x"]])
    } else if (is.character(data[["x"]]) | is.factor(data[["x"]])) {
      data[["name"]] <- data[["x"]]
      data[["x"]] <- NULL
    }
  }

  # color
  if (has_name(mapping, "color")) {
    if (type == "treemap") {
      data <- rename(data, colorValue = .data$color)
    } else if (!all(is.hexcolor(data[["color"]]))) {
      data <- mutate(data, colorv = .data$color, color = highcharter::colorize(.data$color))
    }
  } else if (has_name(data, "color")) {
    data <- rename(data, colorv = .data$color)
  }

  # size
  if (type %in% c("bubble", "scatter")) {
    if (has_name(mapping, "size")) {
      data <- mutate(data, z = .data$size)
    }
  }

  # group
  if (!has_name(mapping, "group")) {
    data[["group"]] <- "group"
  }

  if (isTRUE(fast)) {
    # pre-convert data to json
    data <- data %>%
      group_by(.data$group) %>%
      do(data = jsonlite::toJSON(select(., -.data$group),
        dataframe = "rows",
        verbatim = TRUE
      )) %>%
      ungroup()
  } else {
    data <- data %>%
      group_by(.data$group) %>%
      do(data = list_parse(select(., -.data$group))) %>%
      ungroup()
  }

  data$type <- type

  if (length(list(...)) > 0) {
    data <- add_arg_to_df(data, ...)
  }

  if (has_name(mapping, "group") & !has_name(list(...), "name")) {
    data <- rename(data, name = .data$group)
  }

  series <- list_parse(data)

  series
}

data_to_options <- function(data, type) {
  opts <- list()

  # x
  if (has_name(data, "x")) {
    if (is.Date(data[["x"]])) {
      opts$xAxis_type <- "datetime"
    } else if (is.character(data[["x"]]) | is.factor(data[["x"]])) {
      opts$xAxis_type <- "category"
    } else {
      opts$xAxis_type <- "linear"
    }
  }

  # y
  if (has_name(data, "x")) {
    if (is.Date(data[["y"]])) {
      opts$yAxis_type <- "datetime"
    } else if (is.character(data[["y"]]) | is.factor(data[["y"]])) {
      opts$yAxis_type <- "category"
    } else {
      opts$yAxis_type <- "linear"
    }
  }

  # showInLegend
  opts$series_plotOptions_showInLegend <- "group" %in% names(data)

  # colorAxis
  opts$add_colorAxis <-
    (type == "treemap" & "color" %in% names(data)) | (type == "heatmap")

  # heatmap
  if (type == "heatmap") {
    if (!is.numeric(data[["x"]])) {
      opts$xAxis_categories <- levels(as.factor(data[["x"]]))
    }
    if (!is.numeric(data[["y"]])) {
      opts$yAxis_categories <- levels(as.factor(data[["y"]]))
    }
  }

  opts
}


#' Removing series to highchart objects
#'
#' @param hc A `highchart` `htmlwidget` object.
#' @param names The series's names to delete.
#'
#' @export
hc_rm_series <- function(hc, names = NULL) {
  stopifnot(!is.null(names))

  positions <- hc$x$hc_opts$series %>%
    map("name") %>%
    unlist()

  position <- which(positions %in% names)

  hc$x$hc_opts$series[position] <- NULL

  hc
}

#' Shortcut for data series from a list of data series
#'
#' @param hc A `highchart` `htmlwidget` object.
#' @param x A `list` or a `data.frame` of series.
#'
#' @examples
#'
#' ds <- lapply(seq(5), function(x) {
#'   list(data = cumsum(rnorm(100, 2, 5)), name = x)
#' })
#'
#' highchart() %>%
#'   hc_plotOptions(series = list(marker = list(enabled = FALSE))) %>%
#'   hc_add_series_list(ds)
#' @export
hc_add_series_list <- function(hc, x) {
  assertthat::assert_that(is.highchart(hc), (is.list(x) | is.data.frame(x)))

  if (is.data.frame(x)) {
    x <- list_parse(x)
  }

  hc$x$hc_opts$series <- append(hc$x$hc_opts$series, x)

  hc
}

#' Helpers to use highcharter as input in shiny apps
#'
#' When you use highcharter in a shiny app, for example
#' \code{renderHighcharter('my_chart')}, you can access to the actions of the
#' user using and then use the \code{hc_add_event_point} via the
#' \code{my_chart} input (\code{input$my_chart}). That's a way you can
#' use a chart as an input.
#'
#' @param hc A `highchart` `htmlwidget` object.
#' @param series The name of type of series to apply the event.
#' @param event The name of event: click, mouseOut,  mouseOver. See
#'   \url{https://api.highcharts.com/highcharts/plotOptions.areasplinerange.point.events.select}
#'   for more details.
#'
#' @note Event details are accessible from hc_name_EventType, i.e. if a highchart is rendered against output$my_hc and
#'     and we wanted the coordinates of the user-clicked point we would use input$my_hc_click
#'
#' @export
hc_add_event_point <- function(hc, series = "series", event = "click") {
  fun <- paste0("function(){
  var pointinfo = {series: this.series.name, seriesid: this.series.id,
  name: this.name, x: this.x, y: this.y, category: this.category.name}
  window.x = this;
  console.log(pointinfo);

  if (typeof Shiny != 'undefined') { Shiny.onInputChange(this.series.chart.renderTo.id + '_' + '", event, "', pointinfo); }
}")

  fun <- JS(fun)

  eventobj <- structure(
    list(structure(
      list(structure(
        list(structure(
          list(fun),
          .Names = event
        )),
        .Names = "events"
      )),
      .Names = "point"
    )),
    .Names = series
  )

  hc$x$hc_opts$plotOptions <- rlist::list.merge(
    hc$x$hc_opts$plotOptions,
    eventobj
  )

  hc
}

#' @rdname hc_add_event_point
#' @export
hc_add_event_series <- function(hc, series = "series", event = "click") {
  fun <- paste0("function(){
  var seriesinfo = {name: this.name }
  console.log(seriesinfo);
  window.x = this;
  if (typeof Shiny != 'undefined') { Shiny.onInputChange(this.chart.renderTo.id + '_' + '", event, "', seriesinfo); }

}")
  fun <- JS(fun)

  eventobj <- structure(
    list(structure(
      list(structure(
        list(fun),
        .Names = event
      )),
      .Names = "events"
    )),
    .Names = series
  )

  hc$x$hc_opts$plotOptions <- rlist::list.merge(
    hc$x$hc_opts$plotOptions,
    eventobj
  )

  hc
}

#' Helper to add annotations from data frame or list
#'
#' @param hc A `highchart` `htmlwidget` object.
#' @param ... Arguments defined in \url{https://api.highcharts.com/highcharts/annotations}.
#'
#' @export
hc_add_annotation <- function(hc, ...) {
  assertthat::assert_that(is.highchart(hc))

  hc$x$hc_opts[["annotations"]] <- append(
    hc$x$hc_opts[["annotations"]],
    list(list(...))
  )

  hc
}

#' @rdname hc_add_annotation
#' @param x A \code{list} or a \code{data.frame} of annotations.
#' @details The \code{x} elements must have \code{xValue} and \code{yValue}
#'   elements
#' @export
hc_add_annotations <- function(hc, x) {
  assertthat::assert_that(is.highchart(hc), (is.list(x) | is.data.frame(x)))

  if (is.data.frame(x)) {
    x <- list_parse(x)
  }

  hc$x$hc_opts[["annotations"]] <- append(hc$x$hc_opts[["annotations"]], x)

  hc
}

#' Add modules or plugin dependencies to highcharts objects
#'
#' @param hc A `highchart` `htmlwidget` object.
#' @param name The partial path to the plugin or module,
#'   example: `"plugins/annotations.js"`
#' @examples
#'
#' data(mpg, package = "ggplot2")
#'
#' hchart(mpg, "point", hcaes(displ, hwy),
#'   regression = TRUE,
#'   regressionSettings = list(type = "polynomial", order = 5, hideInLegend = TRUE)
#' ) %>%
#'   hc_add_dependency("plugins/highcharts-regression.js")
#'
#' hchart(mpg, "point", hcaes(displ, hwy, group = drv), regression = TRUE) %>%
#'   hc_colors(c("#d35400", "#2980b9", "#2ecc71")) %>%
#'   hc_add_dependency("plugins/highcharts-regression.js")
#' @details See `vignette("modules")`
#' @importFrom purrr map_chr
#' @importFrom htmltools htmlDependency
#' @importFrom yaml yaml.load_file
#' @export
hc_add_dependency <- function(hc, name = "plugins/annotations.js") {
  stopifnot(!is.null(name))

  yml <- system.file("htmlwidgets/highchart.yaml", package = "highcharter")
  yml <- yaml.load_file(yml)[[1]]

  hc_ver <- map_chr(yml, c("version"))[map_chr(yml, c("name")) == "highcharts"]

  dep <- htmlDependency(
    name = basename(name),
    version = hc_ver,
    src = c(file = system.file(
      sprintf("htmlwidgets/lib/highcharts/%s", dirname(name)),
      package = "highcharter"
    )),
    script = basename(name)
  )

  hc$dependencies <- c(hc$dependencies, list(dep))

  hc
}
