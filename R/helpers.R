get_box_values <- function(x) {
  boxplot.stats(x)$stats |>
    t() |>
    as.data.frame() |>
    setNames(c("low", "q1", "median", "q3", "high"))
}

get_outliers_values <- function(x) {
  boxplot.stats(x)$out
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
#' @importFrom dplyr transmute group_nest rename group_by bind_cols bind_rows summarise
#' @importFrom purrr map_if
#' @importFrom grDevices boxplot.stats
#' @export
data_to_boxplot <- function(
  data,
  variable,
  group_var = NULL,
  group_var2 = NULL,
  add_outliers = FALSE,
  ...
) {
  stopifnot(
    is.data.frame(data),
    !missing(variable)
  )

  dx <- data |>
    transmute(x = {{ variable }})

  if (!missing(group_var)) {
    dg <- data |>
      select({{ group_var }})
  } else {
    dg <- data.frame(rep(0, nrow(dx)))
  }

  if (!missing(group_var2)) {
    dg2 <- data |>
      select({{ group_var2 }})
  } else {
    dg2 <- data.frame(rep(NA, nrow(dx)))
  }

  dg <- dg |> setNames("name")
  dg2 <- dg2 |> setNames("series")

  dat <- bind_cols(dx, dg, dg2)

  dat1 <- dat |>
    group_by(.data$series, .data$name) |>
    summarise(get_box_values(.data$x), .groups = "drop") |>
    group_nest(.data$series) |>
    mutate(data = map(data, list_parse)) |>
    rename(name = "series") |>
    mutate(id = .data$name) |>
    mutate(type = "boxplot", ...)
  # list_parse()

  if (add_outliers) {
    dat2 <- dat |>
      mutate(name = as.numeric(factor(.data$name)) - 1) |>
      group_by(.data$series, .data$name) |>
      dplyr::group_modify(~ data.frame(y = get_outliers_values(.x$x))) |>
      ungroup() |>
      rename(x = "name") |>
      group_nest(.data$series) |>
      mutate(data = map(data, list_parse)) |>
      rename(linkedTo = "series") |>
      mutate(type = "scatter", showInLegend = FALSE, ...)

    dout <- bind_rows(dat1, dat2)
  } else {
    dout <- dat1
  }

  dout
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
#' @importFrom dplyr group_by_at arrange desc distinct rename_all everything
#' @importFrom purrr reduce
#' @export
data_to_hierarchical <- function(
  data,
  group_vars,
  size_var,
  colors = getOption("highcharter.color_palette")
) {
  dat <- data |>
    select({{ group_vars }}, {{ size_var }})

  ngvars <- ncol(dat) - 1

  names(dat) <- c(str_c("group_var_", seq(1, ngvars)), "value")

  gvars <- names(dat)[seq(1, ngvars)]

  # group to calculate the sum if there are duplicated combinations
  dat <- dat |>
    group_by_at(all_of(gvars)) |>
    summarise(value = sum(.data$value, na.rm = TRUE), .groups = "drop") |>
    ungroup() |>
    mutate_if(is.factor, as.character) |>
    arrange(desc(.data$value))

  dout <- map(seq_along(gvars), function(depth = 1) {
    datg <- dat |>
      select(1:depth) |>
      distinct()

    ids <- do.call(paste, c(as.list(datg), sep = "_"))
    dd <- list(tibble(name = datg[[depth]], id = str_to_id_vec(ids)))

    if (depth > 1L) {
      parents <- do.call(paste, c(as.list(datg[-depth]), sep = "_"))
      dd <- append(dd, list(tibble(parent = str_to_id(parents))))
    }

    # depth == 1 add colors
    if (depth == 1 & !is.null(colors)) {
      dd <- dd |>
        append(list(tibble(color = rep(colors, length.out = nrow(datg)))))
    }

    # depth == lastdepth add value
    if (depth == ngvars) {
      dd <- dd |> append(list(dat |> select("value")))
    }

    dd <- dd |>
      bind_cols() |>
      mutate(level = depth)

    dd

    list_parse(dd)
  })

  dout <- reduce(dout, c)

  dout
}

#' Helper to transform data frame for sankey highcharts format
#'
#' @param data A data frame
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
#' @importFrom dplyr all_of count group_by_all vars mutate_at
#' @export
data_to_sankey <- function(data = NULL) {
  # numeric to categories
  if (any(unlist(purrr::map(data, class)) %in% c("integer", "numeric"))) {
    warning("numeric variables were treated with cut() function")
    data <- dplyr::mutate_if(
      data,
      function(x) is.numeric(x) && length(unique(x)) > 10,
      ~ cut(.x, breaks = c(-Inf, quantile(.x, c(2, 4, 6, 8) / 10), Inf))
    )
  }

  columns <- names(data)
  dcmb <- tibble::tibble(var1 = head(columns, -1L), var2 = tail(columns, -1L))

  # sankey data
  dsnky <- purrr::pmap_df(dcmb, function(var1 = "cut", var2 = "color") {
    data |>
      select(all_of(var1), all_of(var2)) |>
      group_by_all() |>
      count() |>
      ungroup() |>
      setNames(c("from", "to", "weight")) |>
      mutate_if(is.factor, as.character) |>
      mutate_at(vars(1, 2), as.character) |>
      mutate(id = paste0(.data$from, .data$to))
  })

  dsnky
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
#' @importFrom dplyr mutate_if
#' @export
hcparcords <- function(df, ...) {
  stopifnot(is.data.frame(df))

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

#' @rdname str_to_id
str_to_id_vec <- function(x) {
  id <- str_to_id(x)
  suffix <- cumsum(duplicated(id))
  str_c(id, ifelse(suffix == 0L, "", str_c("_", suffix)))
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
  # http://stackoverflow.com/questions/10160822/
  stopifnot(inherits(dt, c("Date", "POSIXt")))

  tmstmp <- as.numeric(as.POSIXct(dt))

  tmstmp <- 1000 * tmstmp

  tmstmp
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
  rgb <- x |>
    col2rgb() |>
    # t() |>
    as.data.frame() |>
    purrr::map_chr(str_c, collapse = ",")

  rgba <- sprintf("rgba(%s,%s)", rgb, alpha)
  rgba
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

#' Function to generate iids
#' @param n Number of ids
#' @param length Length of ids
random_id <- function(n = 1, length = 10) {
  source <- c(seq(0, 9), letters)

  replicate(
    n,
    paste0(sample(x = source, size = length, replace = TRUE), collapse = "")
  )
}

#' Function to avoid the jsonlite::auto_unbox default
#' @param x And element, numeric or character
#' @examples
#'
#' hchart("A")
#'
#' highchart() |>
#'   hc_add_series(data = 1)
#' @noRd
fix_1_length_data <- function(x) {
  if (getOption("highcharter.verbose")) {
    message("fix_1_length")
  }

  if (!is.list(x) && length(x) == 1) {
    x <- list(x)
  }
  x
}
