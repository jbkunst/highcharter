get_box_values <- function(x, add_outliers) {
  result <- grDevices::boxplot.stats(x, do.conf = FALSE, do.out = add_outliers)
  box <- as.list(setNames(result$stats, c("low", "q1", "median", "q3", "high")))
  tibble(!!!box, out = list(result$out))
}

#' Helper to transform data frame for boxplot highcharts format
#'
#' @param data The data frame containing variables.
#' @param variable The variable to calculate the box plot data.
#' @param group_var A variable to split calculation
#' @param group_var2 A second variable to create separate series.
#' @param add_outliers A logical value indicating if outliers series should
#'   be calculated. Default to \code{FALSE}.
#' @param ... Arguments defined in \url{https://api.highcharts.com/highcharts/plotOptions.series}.
#'
#' @examples
#'
#' data(pokemon)
#'
#' dat <- data_to_boxplot(pokemon, height)
#'
#' highchart() |>
#'   hc_xAxis(type = "category") |>
#'   hc_add_series_list(dat)
#'
#' dat <- data_to_boxplot(pokemon, height / 10, type_1, name = "Height (m)")
#'
#' highchart() |>
#'   hc_xAxis(type = "category") |>
#'   hc_add_series_list(dat)
#' \dontrun{
#'
#' }
#'
#' @importFrom dplyr transmute group_nest rename group_by bind_rows summarise
#' @importFrom purrr map map_if
#' @export
data_to_boxplot <- function(
  data,
  variable,
  group_var = NULL,
  group_var2 = NULL,
  add_outliers = FALSE,
  ...
) {
  stopifnot(is.data.frame(data), !missing(variable))
  options <- validate_args("data_to_boxplot", rlang::enquos(...))

  values <- tibble::as_tibble(transmute(data, value = {{ variable }}))
  values$name <- if (missing(group_var)) {
    0
  } else {
    dplyr::pull(data, {{ group_var }})
  }
  values$series <- if (missing(group_var2)) {
    NA
  } else {
    dplyr::pull(data, {{ group_var2 }})
  }

  groups <- values |>
    group_by(.data$series, .data$name) |>
    summarise(get_box_values(.data$value, add_outliers), .groups = "drop") |>
    mutate(x = match(.data$name, unique(.data$name)) - 1L)

  boxes <- groups |>
    select(-"out") |>
    group_nest(.data$series) |>
    transmute(
      name = .data$series,
      data = map(.data$data, list_parse),
      id = .data$series,
      type = "boxplot",
      !!!options
    )

  if (!add_outliers) {
    return(boxes)
  }

  counts <- lengths(groups$out)
  parents <- if (missing(group_var2)) {
    rep(":previous", nrow(groups))
  } else {
    groups$series
  }
  points <- tibble(
    linkedTo = rep(parents, counts),
    x = rep(groups$x, counts),
    y = unlist(groups$out, use.names = FALSE)
  ) |>
    group_nest(.data$linkedTo) |>
    mutate(
      data = map(.data$data, list_parse),
      type = "scatter",
      showInLegend = FALSE,
      !!!options
    )

  bind_rows(boxes, points)
}

#' Helper to transform data frame for treemap/sunburst highcharts format
#'
#' @param data data frame containing variables to organize each level of
#'   the treemap.
#' @param group_vars Variables to generate treemap levels.
#' @param size_var Variable to aggregate.
#' @param colors Optional vector of colors for first-level groups, recycled as
#'   needed. With the default `NULL`, nodes inherit colors from the chart theme.
#'
#' @examples
#' \dontrun{
#'
#' library(dplyr)
#' data(gapminder, package = "gapminder")
#'
#' gapminder_2007 <- gapminder::gapminder |>
#'   filter(year == max(year)) |>
#'   mutate(pop_mm = round(pop / 1e6))
#'
#' dout <- data_to_hierarchical(gapminder_2007, c(continent, country), pop_mm)
#'
#' hchart(dout, type = "sunburst")
#'
#' hchart(dout, type = "treemap")
#' }
#'
#' @importFrom dplyr arrange desc
#' @export
data_to_hierarchical <- function(data, group_vars, size_var, colors = NULL) {
  dat <- data |>
    select({{ group_vars }}, {{ size_var }})

  if (ncol(dat) < 2L) {
    stop("Select at least one group column and a size column.", call. = FALSE)
  }
  if (!nrow(dat)) {
    return(list())
  }
  groups <- paste0("group_", seq_len(ncol(dat) - 1L))
  names(dat) <- c(groups, "value")
  dat <- dat |>
    group_by(dplyr::across(all_of(groups))) |>
    summarise(value = sum(.data$value, na.rm = TRUE), .groups = "drop") |>
    arrange(desc(.data$value))

  paths <- lapply(seq_along(groups), function(i) unique(dat[seq_len(i)]))
  keys <- lapply(paths, function(path) {
    do.call(paste, c(as.list(path), sep = "_"))
  })
  ids <- str_to_id(unlist(keys, use.names = FALSE))
  ids[ids == ""] <- "node"
  ids <- utils::relist(make.unique(ids, sep = "_"), keys)

  levels <- lapply(seq_along(paths), function(i) {
    path <- paths[[i]]
    nodes <- tibble(name = path[[i]], id = ids[[i]])
    if (i > 1L) {
      parent <- vctrs::vec_match(path[-i], paths[[i - 1L]])
      nodes$parent <- ids[[i - 1L]][parent]
    } else if (!is.null(colors)) {
      nodes$color <- rep(colors, length.out = nrow(path))
    }
    if (i == length(paths)) {
      nodes$value <- dat$value
    }
    nodes$level <- i
    list_parse(nodes)
  })
  unlist(levels, recursive = FALSE, use.names = FALSE)
}

#' Count links between consecutive columns for a Sankey chart
#'
#' @param data A data frame with one column per stage, in traversal order.
#'   Numeric columns with more than ten distinct finite values are grouped by
#'   quintiles. Tied cut points produce fewer groups.
#' @return A tibble with `from`, `to`, `weight` (number of transitions) and a
#'   unique link `id`. Links with a missing endpoint are omitted. Fewer than
#'   two columns produce an empty tibble with the same columns.
#'
#' @examples
#' \dontrun{
#' library(dplyr)
#' data(diamonds, package = "ggplot2")
#'
#' diamonds2 <- select(diamonds, cut, color, clarity)
#'
#' data_to_sankey(diamonds2)
#'
#' hchart(data_to_sankey(diamonds2), "sankey", name = "diamonds")
#' }
#'
#' @importFrom dplyr all_of count
#' @export
data_to_sankey <- function(data = NULL) {
  if (length(data) < 2L) {
    return(tibble(
      from = character(),
      to = character(),
      weight = integer(),
      id = character()
    ))
  }
  columns <- as.list(data)
  bin <- vapply(
    columns,
    function(x) {
      is.numeric(x) && length(unique(x[is.finite(x)])) > 10L
    },
    logical(1)
  )

  if (any(bin)) {
    warning(
      "Numeric columns grouped by quantiles: ",
      paste(names(columns)[bin], collapse = ", ")
    )
    columns[bin] <- lapply(columns[bin], function(x) {
      cuts <- stats::quantile(x[is.finite(x)], (1:4) / 5, names = FALSE)
      cut(x, unique(c(-Inf, cuts, Inf)), include.lowest = -Inf %in% x)
    })
  }

  links <- Map(
    function(from, to) {
      tibble(from, to) |>
        dplyr::filter(!is.na(.data$from), !is.na(.data$to)) |>
        count(.data$from, .data$to, name = "weight") |>
        mutate(dplyr::across(c("from", "to"), as.character))
    },
    head(columns, -1L),
    tail(columns, -1L)
  )

  bind_rows(unname(links)) |>
    mutate(id = make.unique(paste0(.data$from, .data$to)))
}

#' Convert data to annotation labels
#'
#' @param data A data frame with columns `x`, `y` and `text`. Each row defines
#'   one label. Additional columns supply label options such as `backgroundColor`.
#' @param xAxis,yAxis Axis index (starting at zero) or axis ID for the points.
#' @return A list for the `labels` option of [hc_add_annotation()].
#' @examples
#' peaks <- data.frame(x = c(0, 2), y = c(5, 6), text = c("Start", "Peak"))
#' highchart() |>
#'   hc_add_series(data = c(5, 3, 6)) |>
#'   hc_add_annotation(labels = data_to_annotation_labels(peaks))
#' @export
data_to_annotation_labels <- function(data, xAxis = 0, yAxis = 0) {
  stopifnot(
    is.data.frame(data),
    all(c("x", "y", "text") %in% names(data)),
    length(xAxis) == 1L,
    length(yAxis) == 1L
  )
  data$point <- Map(
    function(x, y) list(x = x, y = y, xAxis = xAxis, yAxis = yAxis),
    data$x,
    data$y
  )
  data[c("x", "y")] <- NULL
  list_parse(data)
}


#' Prepare series for a parallel coordinates chart
#'
#' @param data A data frame of numeric measurements. Each row is an observation
#'   and each column is an axis, in display order.
#' @param ... Named series options such as `name` or `color`. Supply one value
#'   for all observations or one value per row.
#' @return A tibble for [hc_add_series_list()] with one series per row.
#'   Its `data` column holds the measurements in their original units.
#'   Missing measurements leave gaps on their axes.
#' @examples
#' measurements <- iris[1:4]
#' series <- data_to_parallel_coordinates(measurements, color = colorize(iris$Species))
#'
#' highchart() |>
#'   hc_chart(type = "line", parallelCoordinates = TRUE) |>
#'   hc_xAxis(categories = names(measurements)) |>
#'   hc_add_series_list(series)
#' @export
data_to_parallel_coordinates <- function(data, ...) {
  stopifnot(is.data.frame(data), ncol(data) > 0L)
  if (
    !all(vapply(data, function(x) is.numeric(x) && is.null(dim(x)), logical(1)))
  ) {
    stop("Select one numeric column per axis.", call. = FALSE)
  }
  options <- validate_args("data_to_parallel_coordinates", list(...))
  rows <- purrr::pmap(unname(as.list(data)), function(...) {
    values <- list(...)
    replace(values, is.na(values), list(NULL))
  })
  tibble(data = rows, !!!options, .rows = nrow(data))
}

#' Convert an object to list with identical structure
#'
#' Each row becomes one list of values. `list_parse()` keeps column names and
#' `list_parse2()` drops them. Both keep rows with missing values.
#'
#' @importFrom tibble as_tibble
#' @param df A data frame to parse to list
#' @examples
#'
#' x <- data.frame(a = 1:3, type = c("A", "C", "B"), stringsAsFactors = FALSE)
#' list_parse(x)
#' list_parse2(x)
#' @export
list_parse <- function(df) {
  stopifnot(is.data.frame(df))

  columns <- as_tibble(purrr::map_if(df, is.factor, as.character))
  .mapply(list, columns, NULL)
}

#' @rdname list_parse
#' @export
list_parse2 <- function(df) {
  list_parse(df) |>
    map(setNames, NULL)
}

#' String to 'id' format
#'
#' Turn a string to \code{id} format used in treemaps.
#'
#' @param x A vector string.
#'
#' @examples
#'
#' str_to_id(" A string _ with sd / sdg    Underscores \   ")
#' @export
str_to_id <- function(x) {
  stopifnot(is.character(x) | is.factor(x))

  x |>
    as.character() |>
    stringr::str_trim() |>
    stringr::str_to_lower() |>
    stringr::str_replace_all("\\s+", "_") |>
    stringr::str_replace_all("\\\\|/", "_") |>
    stringr::str_replace_all("\\[|\\]", "_") |>
    stringr::str_replace_all("_+", "_") |>
    stringr::str_replace_all("_$|^_", "")
}

#' Date to timestamps
#'
#' Turn a date time vector to \code{timestamp} format
#'
#' @param dt Date or datetime vector
#'
#' @examples
#'
#' datetime_to_timestamp(
#'   as.Date(c("2015-05-08", "2015-09-12"),
#'     format = "%Y-%m-%d"
#'   )
#' )
#' @export
datetime_to_timestamp <- function(dt) {
  stopifnot(inherits(dt, c("Date", "POSIXt")))
  1000 * as.numeric(as.POSIXct(dt))
}

#' Transform colors from hexadecimal format to rgba hc notation
#'
#' @param x colors in hexadecimal format
#' @param alpha alpha
#'
#' @examples
#'
#' hex_to_rgba(x <- c("#440154", "#21908C", "#FDE725", "red"))
#' @importFrom grDevices col2rgb
#' @export
hex_to_rgba <- function(x, alpha = 1) {
  rgb <- col2rgb(x)
  sprintf("rgba(%d,%d,%d,%s)", rgb[1L, ], rgb[2L, ], rgb[3L, ], alpha)
}

#' Monthly temperatures in four cities
#'
#' Use this line chart to try themes and chart options. Each point is the
#' mean of the daily temperatures in [city_weather] for one city and month.
#' @examples
#' highcharts_demo()
#' @export
highcharts_demo <- function() {
  daily <- highcharter::city_weather
  monthly <- stats::aggregate(
    list(temperature = daily$temp_mean),
    list(month = as.integer(format(daily$date, "%m")), city = daily$city),
    mean
  )
  monthly$month <- monthly$month - 1L
  hchart(
    monthly,
    "line",
    hcaes(x = .data$month, y = .data$temperature, group = .data$city)
  ) |>
    hc_title(text = "Monthly mean temperatures in 2025") |>
    hc_subtitle(text = "ERA5 reanalysis via Open-Meteo") |>
    hc_caption(text = "July was warmer in Tokyo than in Santiago.") |>
    hc_xAxis(categories = month.abb, title = list(text = NULL)) |>
    hc_yAxis(title = list(text = "Temperature (\u00b0C)")) |>
    hc_tooltip(shared = TRUE, valueDecimals = 1, valueSuffix = " \u00b0C")
}

#' Create vector of color from vector
#'
#' @param x A numeric, character or factor object.
#' @param colors A character string of colors (ordered) to colorize `x`
#' @examples
#'
#' colorize(runif(10))
#'
#' colorize(LETTERS[rbinom(20, 5, 0.5)], c("#FF0000", "#00FFFF"))
#' @importFrom grDevices colorRampPalette
#' @importFrom stats ecdf
#' @export
colorize <- function(x, colors = c("#440154", "#21908C", "#FDE725")) {
  nuniques <- length(unique(x))

  palcols <- grDevices::colorRampPalette(colors)(nuniques)

  if (!is.numeric(x) | nuniques < 10) {
    y <- as.numeric(factor(x))
    xcols <- palcols[y]
  } else {
    ecum <- ecdf(x)
    xcols <- palcols[ceiling(nuniques * ecum(x))]
  }

  xcols
}

#' Create color stops for \code{hc_colorAxis}
#'
#' @param n Positive integer number of evenly spaced stops. A single stop is
#'   placed at zero.
#' @param colors Character vector of colors in gradient order.
#'
#' @examples
#'
#' color_stops(5)
#'
#' @export
color_stops <- function(n = 10, colors = c("#440154", "#21908C", "#FDE725")) {
  stopifnot(is.numeric(n), length(n) == 1L, is.finite(n), n >= 1, n == floor(n))
  positions <- (seq_len(n) - 1L) / max(1, n - 1L)
  Map(list, positions, grDevices::colorRampPalette(colors)(n))
}

#' Function to create \code{dataClasses} argument in \code{hc_colorAxis}
#'
#' @param breaks A numeric vector
#' @param colors A character string of colors (ordered)
#'
#' @examples
#'
#' color_classes(c(0, 10, 20, 50))
#' @export
color_classes <- function(
  breaks = NULL,
  colors = c("#440154", "#21908C", "#FDE725")
) {
  lbrks <- length(breaks)

  list_parse(
    data.frame(
      from = breaks[-lbrks],
      to = breaks[-1],
      color = grDevices::colorRampPalette(colors)(lbrks - 1),
      stringsAsFactors = FALSE
    )
  )
}

#' Check if a string vector is in hexadecimal color format
#'
#' @param x A string vectors
#'
#' @examples
#'
#' x <- c("#f0f0f0", "#FFf", "#99990000", "#00FFFFFF")
#'
#' is.hexcolor(x)
#' @export
is.hexcolor <- function(x) {
  pattern <- "^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3}|[A-Fa-f0-9]{8})$"

  str_detect(x, pattern)
}
