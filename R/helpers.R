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
#' dat <- data_to_boxplot(pokemon, height, type_1, name = "height in meters")
#'
#' highchart() |>
#'   hc_xAxis(type = "category") |>
#'   hc_add_series_list(dat)
#' \dontrun{
#'
#' }
#'
#' @importFrom dplyr transmute group_nest rename group_by bind_rows summarise
#' @importFrom purrr map_if
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
  points <- tibble(
    linkedTo = rep(groups$series, counts),
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
#' @param colors Color to chart every item in the first level.
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
data_to_hierarchical <- function(
  data,
  group_vars,
  size_var,
  colors = getOption("highcharter.color_palette")
) {
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


#' Shortcut to create parallel coordinates
#' @param df A data frame object.
#' @param ... Additional shared arguments for the data series
#'   (\url{https://api.highcharts.com/highcharts/series}) for the
#'   \code{hchar.data.frame} function.
#' @examples
#' n <- 15
#'
#' hcparcords(head(mtcars, n), color = hex_to_rgba(grDevices::hcl.colors(n, "Inferno"), 0.5))
#'
#' require(dplyr)
#' data(iris)
#' set.seed(123)
#'
#' iris <- sample_n(iris, 60)
#'
#' hcparcords(iris, color = colorize(iris$Species))
#' @export
hcparcords <- function(df, ...) {
  stopifnot(is.data.frame(df))
  validate_args("hcparcords", rlang::enquos(...))

  rescale01 <- function(x) {
    rng <- range(x, na.rm = TRUE)
    (x - rng[1]) / (rng[2] - rng[1])
  }

  columns <- lapply(df[map_lgl(df, is.numeric)], rescale01)
  df <- data.frame(
    .row = rep(rownames(df), times = length(columns)),
    var = rep(names(columns), each = nrow(df)),
    val = as.numeric(unlist(columns, use.names = FALSE))
  )

  hchart(df, "line", hcaes_string(x = "var", y = "val", group = ".row")) |>
    hc_plotOptions(series = list(showInLegend = FALSE)) |>
    hc_yAxis(min = 0, max = 1) |>
    hc_tooltip(sort = TRUE, table = TRUE, valueDecimals = 2)
}

#' Convert an object to list with identical structure
#'
#' Each row becomes one list of values. `list_parse()` keeps column names and
#' `list_parse2()` drops them. With `highcharter.rjson = TRUE`, rows with
#' missing values are omitted.
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

  if (getOption("highcharter.rjson")) {
    rows <- nrow(df)
    df <- df[vctrs::vec_detect_complete(df), , drop = FALSE]
    if (getOption("highcharter.verbose") && (rows > nrow(df))) {
      warning("Removed ", (rows - nrow(df)), " rows with NA's.")
    }
  }

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

#' Monthly temperatures in Tokyo, London and Berlin
#'
#' Use this line chart of [citytemp] to try themes and chart options.
#' @examples
#' highcharts_demo()
#' @export
highcharts_demo <- function() {
  temperatures <- highcharter::citytemp

  highchart() |>
    hc_title(text = "Monthly Average Temperature") |>
    hc_subtitle(text = "Source: WorldClimate.com") |>
    hc_caption(
      text = "Tokyo peaks in August, while London and Berlin peak in July."
    ) |>
    hc_credits(
      text = "Made with highcharter",
      href = "https://jkunst.com/highcharter/",
      enabled = TRUE
    ) |>
    hc_yAxis(title = list(text = "Temperature (\u00b0C)")) |>
    hc_xAxis(
      title = list(text = "Months"),
      categories = as.character(temperatures$month)
    ) |>
    hc_add_series(name = "Tokyo", data = temperatures$tokyo) |>
    hc_add_series(name = "London", data = temperatures$london) |>
    hc_add_series(name = "Berlin", data = temperatures$berlin)
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

#' Function to create \code{stops} argument in \code{hc_colorAxis}
#'
#' @param n A numeric indicating how much quantiles generate.
#' @param colors A character string of colors (ordered)
#'
#' @examples
#'
#' color_stops(5)
#'
#' @importFrom purrr map
#' @export
color_stops <- function(n = 10, colors = c("#440154", "#21908C", "#FDE725")) {
  palcols <- grDevices::colorRampPalette(colors)(n)

  list_parse2(
    data.frame(
      q = seq(0, n - 1) / (n - 1),
      c = palcols
    )
  )
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

#' Generate random series IDs
#' @param n Number of ids
#' @param length Length of ids
#' @keywords internal
random_id <- function(n = 1, length = 10) {
  source <- c(seq(0, 9), letters)

  replicate(
    n,
    paste0(sample(x = source, size = length, replace = TRUE), collapse = "")
  )
}
