#' Adding data to highchart objects
#'
#' @param hc A `highchart` `htmlwidget` object.
#' @param data An R object like numeric, list, ts, xts, etc.
#' @param ... Arguments defined in \url{https://api.highcharts.com/highcharts/plotOptions.series}.
#' @examples
#'
#' highchart() |>
#'   hc_add_series(data = abs(rnorm(5)), type = "column") |>
#'   hc_add_series(data = purrr::map(0:4, function(x) list(x, x)), type = "scatter", color = "orange")
#' @export
hc_add_series <- function(hc, data = NULL, ...) {
  UseMethod("hc_add_series", data)
}


#' @export
hc_add_series.default <- function(hc, data = NULL, ...) {
  if (getOption("highcharter.verbose")) {
    message("hc_add_series.default")
  }

  options <- validate_args("hc_add_series", list(...))
  if (!missing(data)) {
    options <- c(list(data = data), options)
  }
  hc_add_series_list(hc, list(options))
}


#' `hc_add_series` for numeric objects
#' @param hc A `highchart` `htmlwidget` object.
#' @param data A numeric object
#' @param ... Arguments defined in \url{https://api.highcharts.com/highcharts/plotOptions.series}.
#' @export
hc_add_series.numeric <- hc_add_series.default


ts_axis_type <- function(x) {
  if (stats::is.ts(x) && stats::frequency(x) %in% c(1, 4, 12)) {
    "datetime"
  } else {
    "linear"
  }
}

ts_x_values <- function(data) {
  if (ts_axis_type(data) == "datetime") {
    return(datetime_to_timestamp(zoo::as.Date(data)))
  }
  as.numeric(time(data))
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

  series <- list_parse2(data.frame(ts_x_values(data), as.vector(data)))

  hc_add_series(hc, data = series, ...)
}


#' Add xts series to a chart
#'
#' A single instrument with Open, High, Low and Close columns produces a
#' candlestick series. Additional columns such as Volume are ignored. With
#' incomplete or ordinary data, each column produces its own line. Select one
#' instrument before passing a data set with ambiguous OHLC columns.
#' @param hc A `highchart` widget.
#' @param data An `xts` object.
#' @param name Optional series name, or one name per column for multiple lines.
#' @param ... Highcharts series options. To set `id` for multiple lines, supply
#'   a different ID for each column. Other options apply to every line.
#' @examples
#' if (requireNamespace("xts", quietly = TRUE)) {
#'   dates <- as.Date("2025-01-01") + 0:2
#'   quotes <- xts::xts(cbind(A = c(42, 45, 44), B = c(30, NA, 32)), dates)
#'   hchart(quotes, id = c("a", "b"))
#'
#'   if (requireNamespace("quantmod", quietly = TRUE)) {
#'     prices <- xts::xts(cbind(Open = 4:6, High = 6:8, Low = 3:5, Close = 5:7), dates)
#'     highchart(type = "stock") |> hc_add_series(prices, name = "Price")
#'   }
#' }
#' @export
hc_add_series.xts <- function(hc, data, ..., name = NULL) {
  if (getOption("highcharter.verbose")) {
    message("hc_add_series.xts")
  }

  rlang::check_installed("xts", reason = "to chart an xts object.")

  # quantmod also recognises columns marked with Op, Hi, Lo and Cl attributes.
  fields <- c(Op = "Open", Hi = "High", Lo = "Low", Cl = "Close")
  has_field <- function(tag) {
    !is.null(attr(data, tag, exact = TRUE)) ||
      any(grepl(
        paste0("\\b", fields[[tag]], "\\b"),
        colnames(data),
        ignore.case = TRUE
      ))
  }
  if (all(vapply(names(fields), has_field, logical(1)))) {
    return(hc_add_series.ohlc(hc, data, ..., name = name))
  }

  timestamps <- datetime_to_timestamp(time(data))
  n <- NCOL(data)
  opts <- validate_args("hc_add_series", list(...))
  if (is.null(name)) {
    name <- colnames(data)
  }
  if (!is.null(name) && length(name) != n) {
    stop("Supply one name per xts column.", call. = FALSE)
  }
  id <- opts$id
  if (!is.null(id) && (length(id) != n || anyNA(id) || anyDuplicated(id))) {
    stop("Supply one distinct series ID per xts column.", call. = FALSE)
  }
  if (is.null(opts$type)) {
    opts$type <- "line"
  }

  series <- lapply(seq_len(n), function(i) {
    opts$name <- name[i]
    opts$id <- id[i]
    opts$data <- list_parse2(data.frame(
      timestamps,
      value = as.vector(data[, i])
    ))
    opts
  })
  hc_add_series_list(hc, series)
}


#' @rdname hc_add_series.xts
#' @param type Financial series type, usually `"candlestick"` or `"ohlc"`.
#' @export
hc_add_series.ohlc <- function(
  hc,
  data,
  type = "candlestick",
  ...,
  name = NULL
) {
  rlang::check_installed("quantmod", reason = "to chart OHLC prices.")
  columns <- quantmod::has.OHLC(data, which = TRUE)
  select_one <- "Select the OHLC columns for one instrument before adding the series."
  if (
    length(columns) != 4L ||
      anyNA(columns) ||
      anyDuplicated(columns) ||
      !all(columns %in% seq_len(NCOL(data)))
  ) {
    stop(select_one, call. = FALSE)
  }
  price_names <- colnames(data)[columns]
  field <- "^(.*)\\b(Open|High|Low|Close)\\b(.*)$"
  labeled <- grep(field, price_names, ignore.case = TRUE, value = TRUE)
  symbols <- sub(field, "\\1\\3", labeled, ignore.case = TRUE)
  symbols <- unique(gsub("^[. -]+|[. -]+$", "", symbols))
  if (length(symbols) > 1L) {
    stop(select_one, call. = FALSE)
  }
  if (is.null(name)) {
    name <- if (length(symbols) && nzchar(symbols)) symbols else "OHLC"
  }

  timestamps <- datetime_to_timestamp(time(data))
  points <- list_parse2(data.frame(
    timestamps,
    as.matrix(data[, columns, drop = FALSE])
  ))
  hc_add_series(hc, data = points, name = name, type = type, ...)
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
hc_add_series.forecast <- function(
  hc,
  data,
  addOriginal = FALSE,
  addLevels = TRUE,
  fillOpacity = 0.1,
  name = NULL,
  ...
) {
  if (getOption("highcharter.verbose")) {
    message("hc_add_series.forecast")
  }

  rid <- basename(tempfile("hc-"))
  method <- data$method
  forecast_name <- if (is.null(name)) {
    paste("Forecast:", method)
  } else {
    paste(name, "forecast")
  }

  if (addOriginal) {
    observed_name <- if (is.null(name)) "Observed" else paste(name, "observed")
    hc <- hc_add_series(hc, data$x, name = observed_name, zIndex = 3, ...)
  }

  # Regression forecasts can have ordinary numeric responses with no ts index.
  tmf <- if (stats::is.ts(data$mean)) {
    ts_x_values(data$mean)
  } else {
    NROW(data$x) + seq_along(data$mean) - 1
  }
  hc <- hc_add_series(
    hc,
    data = list_parse2(data.frame(t = tmf, y = as.numeric(data$mean))),
    name = forecast_name,
    zIndex = 2,
    id = rid,
    ...
  )

  if (addLevels) {
    nmf <- paste(forecast_name, paste0(data$level, "% interval"))

    for (m in seq_along(data$level)) {
      dfbands <- tibble(
        t = tmf,
        l = as.vector(data$lower[, m]),
        u = as.vector(data$upper[, m])
      )

      hc <- hc |>
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

  data <- list_parse(data.frame(x = data$x, y = data$y))

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

  series <- data |>
    table() |>
    as.data.frame(stringsAsFactors = FALSE) |>
    setNames(c("name", "y")) |>
    list_parse()

  hc_add_series(hc, data = series, ...)
}


#' @rdname hc_add_series.character
#' @export
hc_add_series.factor <- hc_add_series.character

# Highcharts draws Point features individually and expects a single geometry per feature.
geojson_feature_parts <- function(feature, geometry = feature$geometry) {
  switch(
    geometry$type,
    GeometryCollection = unlist(
      lapply(geometry$geometries, function(part) {
        geojson_feature_parts(feature, part)
      }),
      recursive = FALSE,
      use.names = FALSE
    ),
    MultiPoint = lapply(geometry$coordinates, function(xy) {
      feature$geometry <- list(type = "Point", coordinates = xy)
      feature
    }),
    {
      feature$geometry <- geometry
      list(feature)
    }
  )
}

#' hc_add_series for geo_json & geo_list objects
#' @param hc A `highchart` `htmlwidget` object.
#' @param data A GeoJSON FeatureCollection of class `geo_json` or `geo_list`.
#' @param type By default, draw a series for every geometry family present, in
#'   polygon, line, point order. Supply `"map"`, `"mapline"` or `"mappoint"` to
#'   select one family.
#' @param ... Highcharts series options. For multiple layers, supply one name
#'   per layer or a shared name prefix. If supplying IDs, give one distinct
#'   ID per layer, in the same order.
#' @export
hc_add_series.geo_json <- function(hc, data, type = NULL, ...) {
  if (getOption("highcharter.verbose")) {
    message("hc_add_series (GeoJSON)")
  }
  stopifnot(hc$x$type == "map")

  geo <- if (is.character(data)) {
    jsonlite::fromJSON(data, simplifyVector = FALSE)
  } else {
    data
  }
  geometry <- purrr::map_chr(
    geo$features,
    c("geometry", "type"),
    .default = NA_character_
  )
  if (any(geometry %in% c("GeometryCollection", "MultiPoint"))) {
    features <- geo$features[!is.na(geometry)]
    geo$features <- as.list(unlist(
      lapply(features, geojson_feature_parts),
      recursive = FALSE,
      use.names = FALSE
    ))
    data <- geo
    geometry <- purrr::map_chr(geo$features, c("geometry", "type"))
  }
  labels <- c(map = "Polygons", mapline = "Lines", mappoint = "Points")
  if (is.null(type)) {
    stopifnot(identical(geo$type, "FeatureCollection"))
    series_types <- c(
      Polygon = "map",
      MultiPolygon = "map",
      LineString = "mapline",
      MultiLineString = "mapline",
      Point = "mappoint"
    )
    unknown <- setdiff(geometry[!is.na(geometry)], names(series_types))
    if (length(unknown)) {
      stop(
        "Unsupported GeoJSON geometry: ",
        paste(unknown, collapse = ", "),
        call. = FALSE
      )
    }

    families <- unname(series_types[geometry])
    types <- intersect(names(labels), families)
    if (length(types) <= 1L) {
      type <- if (length(types)) types else "map"
    }
  }
  if (!is.null(type)) {
    return(hc_add_series.default(
      hc,
      data = data,
      geojson = TRUE,
      type = type,
      ...
    ))
  }

  opts <- validate_args("hc_add_series", list(...))
  layer_names <- unname(labels[types])
  if (length(opts$name) == 1L) {
    layer_names <- paste(opts$name, layer_names)
  }
  if (length(opts$name) > 1L) {
    layer_names <- opts$name
  }
  if (length(layer_names) != length(types)) {
    stop("Supply one name per GeoJSON layer or a shared prefix.", call. = FALSE)
  }
  ids <- opts$id
  if (
    !is.null(ids) &&
      (length(ids) != length(types) || anyNA(ids) || anyDuplicated(ids))
  ) {
    stop("Supply one distinct series ID per GeoJSON layer.", call. = FALSE)
  }
  series <- lapply(seq_along(types), function(i) {
    geo$features <- unname(geo$features[which(families == types[i])])
    opts$data <- geo
    opts$geojson <- TRUE
    opts$type <- types[i]
    opts$name <- layer_names[i]
    opts$id <- ids[i]
    opts
  })
  hc_add_series_list(hc, series)
}

#' @rdname hc_add_series.geo_json
#' @export
hc_add_series.geo_list <- hc_add_series.geo_json

#' hc_add_series for lm and loess objects
#' @param hc A `highchart` `htmlwidget` object.
#' @param data A \code{lm} or \code{loess} object.
#' @param type The type of the series: line, spline.
#' @param color A stringr color.
#' @param fillOpacity fillOpacity to the confidence interval.
#' @param ... Arguments defined in
#'   \url{https://api.highcharts.com/highcharts/chart}.
#' @importFrom rlang .data
#' @export
hc_add_series.lm <- function(
  hc,
  data,
  type = "line",
  color = "#5F83EE",
  fillOpacity = 0.1,
  ...
) {
  if (getOption("highcharter.verbose")) {
    message(sprintf("hc_add_series.%s", class(data)))
  }

  if (inherits(data, "loess")) {
    x <- data$x[, 1L]
    prediction <- stats::predict(data, se = TRUE)
  } else {
    frame <- stats::model.frame(data)
    if (!length(attr(stats::terms(data), "term.labels"))) {
      stop("A model with a predictor is required.", call. = FALSE)
    }
    x <- frame[[2L]]
    prediction <- stats::predict(data, se.fit = TRUE)
    # predict.lm restores excluded rows, while the model frame omits them.
    if (
      inherits(data$na.action, "exclude") && NROW(prediction$fit) != NROW(x)
    ) {
      prediction$fit <- prediction$fit[-data$na.action]
      prediction$se.fit <- prediction$se.fit[-data$na.action]
    }
  }
  if (NCOL(x) > 1L || NCOL(prediction$fit) > 1L) {
    stop(
      "The fitted series requires one response and a one-dimensional x axis.",
      call. = FALSE
    )
  }
  points <- data.frame(
    x = drop(x),
    fit = as.vector(prediction$fit),
    se = as.vector(prediction$se.fit)
  )
  points <- points[order(points$x), , drop = FALSE]

  rid <- basename(tempfile("hc-"))

  hc |>
    hc_add_series(
      points,
      type = type,
      hcaes(x = x, y = .data$fit),
      id = rid,
      color = color,
      ...
    ) |>
    hc_add_series(
      points,
      type = "arearange",
      hcaes(
        x = x,
        low = .data$fit - 2 * .data$se,
        high = .data$fit + 2 * .data$se
      ),
      color = hex_to_rgba(color, fillOpacity),
      linkedTo = rid,
      zIndex = -2,
      ...
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
#' @param ... Arguments defined in
#'   \url{https://api.highcharts.com/highcharts/chart}.
#' @examples
#' # Add a band using point options specific to range charts.
#' intervals <- data.frame(day = as.Date("2025-01-01") + 0:2,
#'                         estimate = c(10, 12, 11), se = c(1, 2, 1))
#' highchart() |>
#'   hc_add_series(intervals, "arearange",
#'     hcaes(day, low = estimate - se, high = estimate + se), name = "Range") |>
#'   hc_add_series(intervals, "line", hcaes(day, estimate), name = "Estimate")
#' @importFrom rlang .data
#' @export
hc_add_series.data.frame <- function(
  hc,
  data,
  type = NULL,
  mapping = hcaes(),
  ...
) {
  check_removed_fast(...)
  if (getOption("highcharter.verbose")) {
    message("hc_add_series.data.frame")
  }

  if (length(mapping) == 0) {
    if (has_name(data, "series")) {
      data <- rename(data, seriess = "series")
    }

    if (identical(type, "xrange")) {
      data <- convert_date_coordinates(data, c("x", "x2"))
    }

    return(hc_add_series(hc, data = list_parse(data), type = type, ...))
  }

  data <- mutate_mapping(data, mapping)

  series <- data_to_series(data, mapping, type = type, ...)

  hc_add_series_list(hc, series)
}

# Series options pass through `...` to Highcharts, where `fast` would be ignored.
check_removed_fast <- function(...) {
  if ("fast" %in% ...names()) {
    stop(
      "The `fast` argument was removed. Omit it when charting a data frame.",
      call. = FALSE
    )
  }
}

#' Map data-frame columns to Highcharts point options
#'
#' Expressions are evaluated in the data frame and can use variables from the
#' function that created the mapping. `group` creates one series per distinct
#' value. Other named mappings become point options.
#'
#' @param x,y,... Columns or expressions to map. Only `x` and `y` can be
#'   supplied by position. A quoted column name or expression is also accepted.
#' @seealso [hcaes_string()], [mutate_mapping()]
#' @examples
#' # Split points into series and assign colors from a numeric column.
#' hchart(iris, "scatter",
#'   hcaes(Sepal.Length, Petal.Length, group = Species, color = Petal.Width))
#'
#' # Keep supplied hex colors and map size to the bubble radius scale.
#' cars <- head(mtcars)
#' cars$paint <- ifelse(cars$am == 1, "#0072B2", "#D55E00")
#' hchart(cars, "scatter", hcaes(wt, mpg, size = hp, color = paint))
#'
#' # Use a date axis, a local multiplier and a gap in the line.
#' readings <- data.frame(day = as.Date("2025-01-01") + 0:3,
#'                        rate = c(0.02, 0.04, NA, 0.03))
#' plot_rates <- function(data, multiplier) {
#'   hchart(data, "line", hcaes(day, rate * multiplier))
#' }
#' plot_rates(readings, 100)
#'
#' # Heatmaps use a value and two category axes.
#' cells <- data.frame(day = c("Mon", "Tue", "Mon", "Tue"),
#'                     shift = rep(c("AM", "PM"), each = 2), n = c(3, 7, 5, 2))
#' hchart(cells, "heatmap", hcaes(day, shift, value = n))
#'
#' # Task intervals
#' tasks <- data.frame(
#'   start = as.Date(c("2025-01-06", "2025-01-08")),
#'   finish = as.Date(c("2025-01-09", "2025-01-13")),
#'   lane = 0:1
#' )
#' hchart(tasks, "xrange", hcaes(x = start, x2 = finish, y = lane)) |>
#'   hc_yAxis(categories = c("Design", "Review"))
#'
#' # Five-number summaries
#' waits <- data.frame(
#'   clinic = c("North", "South"), lower = c(4, 6), p25 = c(6, 8),
#'   p50 = c(10, 12), p75 = c(14, 15), upper = c(19, 22)
#' )
#' hchart(waits, "boxplot",
#'   hcaes(x = clinic, low = lower, q1 = p25, median = p50, q3 = p75, high = upper))
#'
#' # Flows between nodes
#' trips <- data.frame(
#'   origin = c("North", "North", "South"), destination = c("Bus", "Rail", "Rail"),
#'   passengers = c(30, 20, 15)
#' )
#' hchart(trips, "sankey", hcaes(from = origin, to = destination, weight = passengers))
#' @export
hcaes <- function(x, y, ...) {
  mapping <- rlang::enquos(x = x, y = y, ..., .ignore_empty = "all")
  as_hcaes(mapping, rlang::caller_env())
}

#' Map point options using strings
#'
#' Use this form when the column names come from variables, such as Shiny
#' inputs. Strings may also contain a single R expression.
#' @param x,y,... Column names or expressions as strings. Only `x` and `y`
#'   can be supplied by position.
#' @seealso [hcaes()]
#' @examples
#' x_col <- "Sepal.Length"
#' y_col <- "Petal.Length"
#' hchart(iris, "scatter", hcaes_string(x_col, y_col, group = "Species"))
#'
#' # Backticks quote a column name containing spaces.
#' sales <- data.frame(store = c("North", "South"))
#' sales[["net sales"]] <- c(150, 200)
#' highchart() |>
#'   hc_add_series(sales, "column", hcaes_string("store", "`net sales` / 1000"),
#'                 name = "Sales (thousands)")
#' @export
hcaes_string <- function(x, y, ...) {
  mapping <- list(...)
  if (!missing(x)) {
    mapping["x"] <- list(x)
  }
  if (!missing(y)) {
    mapping["y"] <- list(y)
  }
  as_hcaes(mapping, rlang::caller_env())
}

as_hcaes <- function(mapping, env) {
  if (length(mapping) && !rlang::is_named(mapping)) {
    stop(
      "Name each mapping after x and y, for example `group = Species`.",
      call. = FALSE
    )
  }
  mapping <- lapply(mapping, function(value) {
    expr <- rlang::get_expr(value)
    if (is.character(expr)) {
      rlang::parse_quo(expr, env)
    } else {
      rlang::as_quosure(value, env)
    }
  })
  structure(mapping, class = c("hcaes", "uneval"))
}

#' Apply point mappings to a data frame
#'
#' @param data A data frame.
#' @param mapping A mapping from [hcaes()] or [hcaes_string()].
#' @param drop If `TRUE`, keep only the mapped columns, in mapping order.
#' @importFrom rlang "!!!" ":=" .data
#' @examples
#' cars <- head(mtcars, 3)
#' mapping <- hcaes(wt, mpg, group = factor(cyl), name = rownames(cars))
#' mutate_mapping(cars, mapping)
#' mutate_mapping(cars, mapping, drop = TRUE)
#' @export
mutate_mapping <- function(data, mapping, drop = FALSE) {
  stopifnot(is.data.frame(data), inherits(mapping, "hcaes"), is.logical(drop))
  # Mappings saved by older releases contain bare expressions and strings.
  if (!all(vapply(mapping, rlang::is_quosure, logical(1)))) {
    mapping <- as_hcaes(mapping, globalenv())
  }
  data <- dplyr::mutate(data, !!!mapping)
  if (drop) {
    data <- dplyr::select(data, all_of(names(mapping)))
  }
  # Highcharts reserves point.series (#241).
  if (has_name(data, "series")) {
    data <- dplyr::rename(data, seriess = "series")
  }
  data
}

convert_date_coordinates <- function(data, keys) {
  for (key in keys) {
    if (inherits(data[[key]], c("Date", "POSIXt"))) {
      data[[key]] <- datetime_to_timestamp(data[[key]])
    }
  }
  data
}

#' @importFrom dplyr mutate
#' @importFrom tibble tibble has_name
data_to_series <- function(data, mapping, type, ...) {
  if (identical(type, "point")) {
    type <- "scatter"
  }
  if (identical(type, "scatter") && any(c("size", "z") %in% names(mapping))) {
    type <- "bubble"
  }

  cell_sizes <- list()
  if (identical(type, "heatmap")) {
    for (axis in intersect(c("x", "y"), names(data))) {
      values <- data[[axis]]
      if (is.numeric(values)) {
        next
      }
      labels <- as.factor(values)
      data[[paste0(axis, "f")]] <- labels
      if (inherits(values, c("Date", "POSIXt"))) {
        times <- datetime_to_timestamp(values)
        data[[axis]] <- times
        size <- if (axis == "x") "colsize" else "rowsize"
        step <- if (inherits(values, "Date")) {
          86400000
        } else {
          diff(sort(unique(times)))
        }
        cell_sizes[[size]] <- if (length(step)) min(step) else 1000
      } else {
        data[[axis]] <- as.integer(labels) - 1
      }
    }
  }

  coordinates <- intersect(names(mapping), c("x", "x2"))
  if (identical(type, "xrange")) {
    coordinates <- c("x", "x2")
  }
  data <- convert_date_coordinates(data, c(coordinates, "y"))
  if (
    has_name(mapping, "x") &&
      (is.character(data[["x"]]) || is.factor(data[["x"]]))
  ) {
    data[["name"]] <- data[["x"]]
    data[["x"]] <- NULL
  }

  # color
  if (has_name(mapping, "color")) {
    if (identical(type, "treemap")) {
      data <- rename(data, colorValue = "color")
    } else if (!all(is.hexcolor(data[["color"]]), na.rm = TRUE)) {
      data <- mutate(
        data,
        colorv = .data$color,
        color = highcharter::colorize(.data$color)
      )
    }
  } else if (has_name(data, "color")) {
    data <- rename(data, colorv = "color")
  }

  if (identical(type, "bubble") && has_name(mapping, "size")) {
    data[["z"]] <- data[["size"]]
  }

  if (!has_name(mapping, "group")) {
    data[["group"]] <- rep("group", nrow(data))
  }
  groups <- dplyr::group_data(group_by(data, .data$group))
  data <- dplyr::ungroup(data)
  data[["group"]] <- NULL
  points <- lapply(groups$.rows, function(i) {
    list_parse(data[i, , drop = FALSE])
  })
  series <- tibble(group = groups$group, data = points)
  series$type <- type

  if (...length()) {
    options <- validate_args("hc_add_series", list(...))
    series <- as_tibble(c(as.list(series), map_if(options, is.list, list)))
  }
  for (size in setdiff(names(cell_sizes), names(series))) {
    series[[size]] <- cell_sizes[[size]]
  }
  if (has_name(mapping, "group") && !("name" %in% ...names())) {
    series <- rename(series, name = "group")
  }
  list_parse(series)
}

data_to_options <- function(data, type, mapping) {
  heatmap <- identical(type, "heatmap")
  opts <- list(
    series_plotOptions_showInLegend = has_name(mapping, "group"),
    add_colorAxis = heatmap ||
      (identical(type, "treemap") && has_name(data, "color"))
  )

  for (axis in intersect(c("x", "y"), names(data))) {
    values <- data[[axis]]
    axis_type <- if (inherits(values, c("Date", "POSIXt"))) {
      "datetime"
    } else if (heatmap && !is.numeric(values)) {
      opts[[paste0(axis, "Axis_categories")]] <- levels(as.factor(values))
      "category"
    } else if (is.character(values) || is.factor(values)) {
      "category"
    } else {
      "linear"
    }
    opts[[paste0(axis, "Axis_type")]] <- axis_type
  }

  opts
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
#' highchart() |>
#'   hc_plotOptions(series = list(marker = list(enabled = FALSE))) |>
#'   hc_add_series_list(ds)
#' @export
hc_add_series_list <- function(hc, x) {
  stopifnot(is.highchart(hc), (is.list(x) | is.data.frame(x)))

  if (is.data.frame(x)) {
    x <- list_parse(x)
  }

  # Highcharts expects an array even for a single numeric point.
  for (i in seq_along(x)) {
    points <- x[[i]][["data"]]
    if (is.numeric(points) && length(points) == 1L && is.null(dim(points))) {
      x[[i]]$data <- list(unname(points))
    }
  }

  start <- length(hc$x$hc_opts$series)
  hc$x$hc_opts$series <- append(hc$x$hc_opts$series, x)
  .hc_apply_fonts(hc, "hc_opts", "series", append_from = start)
}

#' Use chart events as Shiny inputs
#'
#' For an output named `sales`, Shiny receives point clicks automatically at
#' `input$sales_point_click`. Register other Highcharts events with these
#' helpers. For example, `hc_add_event_point(event = "drop")` sends the
#' released point to `input$sales_point_drop`, and
#' `hc_add_event_series(event = "mouseOver")` sends the hovered series to
#' `input$sales_series_mouseOver`.
#'
#' Point events include `series`, `seriesid`, `pointid`, `name`, `x`, `y` and
#' `category` when available. During a drag or drop, the coordinates reflect
#' the proposed position. Series events include `name` and `seriesid`.
#'
#' @param hc A `highchart` htmlwidget.
#' @param series Highcharts series type to listen to, such as `"column"`.
#'   The default `"series"` applies to all types.
#' @param event Case-sensitive Highcharts event name, such as `"mouseOver"`.
#'   See the [point events](https://api.highcharts.com/highcharts/plotOptions.series.point.events)
#'   and [series events](https://api.highcharts.com/highcharts/plotOptions.series.events).
#' @return The chart with the requested event configured.
#' @export
hc_add_event_point <- function(hc, series = "series", event = "click") {
  if (!identical(event, "click")) {
    hc$x$hc_opts$plotOptions[[series]]$point$events[[event]] <- JS(
      "function(e) { HighcharterWidget.sendEvent(this, 'point', e); }"
    )
  }
  hc
}

#' @rdname hc_add_event_point
#' @export
hc_add_event_series <- function(hc, series = "series", event = "click") {
  hc$x$hc_opts$plotOptions[[series]]$events[[event]] <- JS(
    "function(e) { HighcharterWidget.sendEvent(this, 'series', e); }"
  )
  hc
}

#' Add annotations to a chart
#'
#' @param hc A `highchart` widget.
#' @param ... Named options for one Highcharts annotation, including `labels`
#'   and `shapes`. See [data_to_annotation_labels()] to create labels from rows.
#' @export
hc_add_annotation <- function(hc, ...) {
  hc_add_annotations(hc, list(validate_args("hc_add_annotation", list(...))))
}

#' @rdname hc_add_annotation
#' @param x A list of annotations or a data frame with one annotation per row.
#' @export
hc_add_annotations <- function(hc, x) {
  stopifnot(is.highchart(hc), (is.list(x) | is.data.frame(x)))

  if (is.data.frame(x)) {
    x <- list_parse(x)
  }

  start <- length(hc$x$hc_opts$annotations)
  hc$x$hc_opts$annotations <- append(hc$x$hc_opts$annotations, x)
  .hc_apply_fonts(hc, "hc_opts", "annotations", append_from = start)
}

#' Add a bundled community plugin to a chart
#'
#' @param hc A `highchart` `htmlwidget` object.
#' @param name The path to a packaged plugin, such as
#'   `"plugins/highcharts-regression.js"`
#' @examples
#'
#' hchart(mtcars, "scatter", hcaes(wt, mpg),
#'   regression = TRUE,
#'   regressionSettings = list(type = "polynomial", order = 2, hideInLegend = TRUE)
#' ) |>
#'   hc_add_dependency("plugins/highcharts-regression.js")
#'
#' hchart(mtcars, "scatter", hcaes(wt, mpg, group = factor(cyl)), regression = TRUE) |>
#'   hc_colors(c("#d35400", "#2980b9", "#2ecc71")) |>
#'   hc_add_dependency("plugins/highcharts-regression.js")
#' @details Use [highchart()] for built-in modules and [highchartstock()]
#'   for Stock Tools and technical indicators.
#' @importFrom htmltools htmlDependency
#' @export
hc_add_dependency <- function(hc, name) {
  if (!is.character(name) || length(name) != 1L || is.na(name)) {
    stop("Supply one plugin path.", call. = FALSE)
  }
  if (startsWith(name, "modules/")) {
    stop(
      "Remove hc_add_dependency() for built-in modules. ",
      "Use highchartstock() for Stock Tools and technical indicators. ",
      "This function accepts packaged community plugins only.",
      call. = FALSE
    )
  }

  directory <- system.file(
    "htmlwidgets/lib/highcharts/plugins",
    package = "highcharter"
  )
  plugins <- file.path("plugins", list.files(directory, pattern = "\\.js$"))
  if (!name %in% plugins) {
    stop(
      "Choose a packaged plugin: ",
      paste(plugins, collapse = ", "),
      call. = FALSE
    )
  }
  dep <- htmlDependency(
    name = basename(name),
    version = as.character(utils::packageVersion("highcharter")),
    src = c(file = directory),
    script = basename(name),
    all_files = FALSE
  )
  hc$dependencies <- c(hc$dependencies, list(dep))

  hc
}
