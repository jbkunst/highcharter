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
#' @importFrom dplyr transmute group_nest rename group_by bind_rows
#' @importFrom tidyr unnest
#' @importFrom purrr map_if
#' @importFrom grDevices boxplot.stats
#' @export
data_to_boxplot <- function(data, variable, group_var = NULL, group_var2 = NULL, add_outliers = FALSE, ...) {
  stopifnot(
    is.data.frame(data),
    !missing(variable)
  )

  dx <- data |>
    transmute(x := {{ variable }})

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
    group_by(series, name) |>
    summarise(data = list(get_box_values(x)), .groups = "drop") |>
    unnest(cols = data) |>
    group_nest(series) |>
    mutate(data = map(data, list_parse)) |>
    rename(name = series) |>
    mutate(id = name) |>
    mutate(type = "boxplot", ...)
  # list_parse()

  if (add_outliers) {
    dat2 <- dat |>
      mutate(name = as.numeric(factor(name)) - 1) |>
      group_by(series, name) |>
      summarise(y = list(get_outliers_values(x)), .groups = "drop") |>
      unnest(cols = y) |>
      rename(x = name) |>
      group_nest(series) |>
      mutate(data = map(data, list_parse)) |>
      rename(linkedTo = series) |>
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
#' @importFrom tidyr unite
#' @importFrom purrr reduce
#' @export
data_to_hierarchical <- function(data, group_vars, size_var, colors = getOption("highcharter.color_palette")) {
  dat <- data |>
    select({{ group_vars }}, {{ size_var }})

  ngvars <- ncol(dat) - 1

  names(dat) <- c(str_c("group_var_", seq(1, ngvars)), "value")

  gvars <- names(dat)[seq(1, ngvars)]

  # group to calculate the sum if there are duplicated combinations
  dat <- dat |>
    group_by_at(all_of(gvars)) |>
    summarise(value = sum(value, na.rm = TRUE), .groups = "drop") |>
    ungroup() |>
    mutate_if(is.factor, as.character) |>
    arrange(desc(value))

  dout <- map(seq_along(gvars), function(depth = 1) {
    datg <- dat |>
      select(1:depth) |>
      distinct()

    datg_name <- datg |>
      select(depth) |>
      rename_all(~"name")

    datg_id <- datg |>
      unite("id", everything(), sep = "_") |>
      mutate(id = str_to_id_vec(id))

    datg_parent <- datg |>
      select(1:(depth - 1)) |>
      unite("parent", everything(), sep = "_") |>
      mutate(parent = str_to_id(parent))

    dd <- list(datg_name, datg_id)

    # depth != 1 add parents
    if (depth != 1) dd <- dd |> append(list(datg_parent))

    # depth == 1 add colors
    if (depth == 1 & !is.null(colors)) {
      dd <- dd |> append(list(tibble(color = rep(colors, length.out = nrow(datg)))))
    }

    # depth == lastdepth add value
    if (depth == ngvars) dd <- dd |> append(list(dat |> select(value)))

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
#' @importFrom dplyr all_of count group_by_all vars
#' @importFrom stats complete.cases
#' @export
data_to_sankey <- function(data = NULL) {

  # numeric to categories
  if (any(unlist(purrr::map(data, class)) %in% c("integer", "numeric"))) {
    warning("numeric variables were treated with cut() function")
    data <- dplyr::mutate_if(data, function(x) is.numeric(x) && length(unique(x)) > 10, ~ cut(.x, breaks = c(-Inf, quantile(.x, c(2, 4, 6, 8) / 10), Inf)))
  }

  # combintaion data
  dcmb <- tibble::tibble(
    var1 = names(data),
    var2 = dplyr::lead(var1)
  ) |>
    dplyr::filter(complete.cases(.))

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
      mutate(id := paste0(from, to))
  })

  dsnky
}

#' Shortcut to create parallel coordinates
#' @param df A data frame object.
#' @param ... Additional shared arguments for the data series
#'   (\url{https://api.highcharts.com/highcharts/series}) for the
#'   \code{hchar.data.frame} function.
#' @examples
#' require(viridisLite)
#'
#' n <- 15
#'
#' hcparcords(head(mtcars, n), color = hex_to_rgba(magma(n), 0.5))
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

  df <- df[map_lgl(df, is.numeric)]

  # Add row identifier
  df <- rownames_to_column(df, ".row")

  df <- dplyr::mutate_if(df, is.numeric, rescale01)

  df <- tidyr::gather(df, "var", "val", setdiff(names(df), ".row"))

  hchart(df, "line", hcaes_(x = "var", y = "val", group = ".row")) |>
    hc_plotOptions(series = list(showInLegend = FALSE)) |>
    hc_yAxis(min = 0, max = 1) |>
    hc_tooltip(sort = TRUE, table = TRUE, valueDecimals = 2)
}

#' Convert an object to list with identical structure
#'
#' This functions are similar to \code{rlist::list.parse} but this removes
#' names. \code{NA}s are removed for compatibility with rjson::toJSON.
#'
#' @param df A data frame to parse to list
#' @examples
#'
#' x <- data.frame(a = 1:3, type = c("A", "C", "B"), stringsAsFactors = FALSE)
#' list_parse(x)
#' list_parse2(x)
#' @importFrom purrr transpose
#' @export
list_parse <- function(df) {
  assertthat::assert_that(is.data.frame(df))

  if (getOption("highcharter.rjson")) {
    rows <- nrow(df)
    df <- tidyr::drop_na(df)
    if (getOption("highcharter.verbose") && (rows > nrow(df))) {
      warning("Removed ", (rows - nrow(df)), " rows with NA's.")
    }
  }

  purrr::map_if(df, is.factor, as.character) |>
    as_tibble() |>
    list.parse() |>
    setNames(NULL)
}

#' @importFrom rlist list.parse
#' @rdname list_parse
#' @export
list_parse2 <- function(df) {
  assertthat::assert_that(is.data.frame(df))

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
  assertthat::assert_that(is.character(x) | is.factor(x))

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

  # x <- c("A_ aa", "A_  Aa", "a_   aa"

  tibble(
    var = x,
    id = str_to_id(x),
    un = cumsum(duplicated(id))
  ) |>
    mutate(
      un = ifelse(un == 0, "", str_c("_", un)),
      id2 = str_c(id, un)
    ) |>
    pull("id2")
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
  assertthat::assert_that(assertthat::is.date(dt) | assertthat::is.time(dt))

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
#' @importFrom tidyr unite_
#' @export
hex_to_rgba <- function(x, alpha = 1) {
  rgb <- x |>
    col2rgb() |>
    # t() |>
    as.data.frame() |>
    map_chr(str_c, collapse = ",")
  
  rgba <- sprintf("rgba(%s,%s)", rgb, alpha)
  rgba
}

#' Chart a demo for testing themes
#'
#' Chart a demo for testing themes
#'
#' @examples
#'
#' highcharts_demo()
#' @export
highcharts_demo <- function() {
  dtemp <- structure(
    list(
      month = c(
        "Jan", "Feb", "Mar", "Apr", "May", "Jun",
        "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
      ),
      tokyo = c(
        7, 6.9, 9.5, 14.5, 18.2, 21.5,
        25.2, 26.5, 23.3, 18.3, 13.9, 9.6
      ),
      new_york = c(
        -0.2, 0.8, 5.7, 11.3, 17, 22,
        24.8, 24.1, 20.1, 14.1, 8.6, 2.5
      ),
      berlin = c(
        -0.9, 0.6, 3.5, 8.4, 13.5, 17,
        18.6, 17.9, 14.3, 9, 3.9, 1
      ),
      london = c(
        3.9, 4.2, 5.7, 8.5, 11.9, 15.2,
        17, 16.6, 14.2, 10.3, 6.6, 4.8
      )
    ),
    .Names = c("month", "tokyo", "new_york", "berlin", "london"),
    row.names = c(NA, 12L), class = c("tbl_df", "tbl", "data.frame")
  )

  highchart() |>
    hc_title(text = "Monthly Average Temperature") |>
    hc_subtitle(text = "Source: WorldClimate.com") |>
    hc_caption(text = "This is a caption text to show the style of this type of text") |>
    hc_credits(text = "Made with highcharter", href = "http://jkunst.com/highcharter/", enabled = TRUE) |>
    hc_yAxis(title = list(text = "Temperature")) |>
    hc_xAxis(title = list(text = "Months")) |>
    hc_xAxis(categories = dtemp$month) |>
    hc_add_series(name = "Tokyo", data = dtemp$tokyo) |>
    hc_add_series(name = "London", data = dtemp$london) |>
    hc_add_series(name = "Berlin", data = dtemp$berlin)
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
    y <- as.numeric(as.factor(x))
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
color_classes <- function(breaks = NULL,
                          colors = c("#440154", "#21908C", "#FDE725")) {
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

#' Auxiliar function to get series and options from tidy frame for hchart.data.frame
#'
#' This function is used in \code{hchart.data.frame}.
#'
#' @param data A `data.frame` object.
#' @param type The type of chart. Possible values are line, scatter, point, column.
#' @param ... Aesthetic mappings as \code{x y group color low high}.
#'
#' @examples
#'
#' highcharter:::get_hc_series_from_df(iris, type = "point", x = Sepal.Width)
#' 
#' @importFrom tibble has_name
#' @importFrom rlang .data
get_hc_series_from_df <- function(data, type = NULL, ...) {
  assertthat::assert_that(is.data.frame(data))
  stopifnot(!is.null(type))

  pars <- eval(substitute(alist(...)))
  parsc <- map(pars, as.character)

  data <- mutate(data, ...)
  data <- ungroup(data)

  # check type
  type <- ifelse(type == "point", "scatter", type)
  type <- ifelse("size" %in% names(data) & type == "scatter", "bubble", type)

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
  if (has_name(parsc, "x")) {
    if (is.Date(data[["x"]])) {
      data[["x"]] <- datetime_to_timestamp(data[["x"]])
    } else if (is.character(data[["x"]]) | is.factor(data[["x"]])) {
      data[["name"]] <- data[["x"]]
      data[["x"]] <- NULL
    }
  }

  # color
  if (has_name(parsc, "color")) {
    if (type == "treemap") {
      data <- rename(data, colorValue = .data$color)
    } else {
      data <- mutate(data,
        colorv = .data$color,
        color = highcharter::colorize(.data$color)
      )
    }
  }

  # size
  if (has_name(parsc, "size") & type %in% c("bubble", "scatter")) {
    data <- mutate(data, z = .data$size)
  }

  # group
  if (!has_name(parsc, "group")) {
    data[["group"]] <- "Series"
  }

  data[["charttpye"]] <- type

  dfs <- data |>
    group_by(.data$group, .data$charttpye) |>
    do(data = list_parse(select(., -.data$group, -.data$charttpye))) |>
    ungroup() |>
    rename(name = .data$group, type = .data$charttpye)

  if (!has_name(parsc, "group")) {
    dfs[["name"]] <- NULL
  }

  series <- list_parse(dfs)

  series
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

  replicate(n, paste0(sample(x = source, size = length, replace = TRUE), collapse = ""))
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

#' Function to create annotations arguments from a data frame
#' @param df A data frame with `x`, `y` and `text` columns names.
#' @param xAxis Index (js 0-based) of the x axis to put the annotations.
#' @param yAxis Index (js 0-based) of the y axis to put the annotations.
#' @examples
#'
#' df <- data.frame(text = c("hi", "bye"), x = c(0, 1), y = c(1, 0))
#'
#' df_to_annotations_labels(df)
#' @importFrom utils hasName
#' @importFrom dplyr rowwise
#' @export
df_to_annotations_labels <- function(df, xAxis = 0, yAxis = 0) {
  stopifnot(hasName(df, "x"))
  stopifnot(hasName(df, "y"))
  stopifnot(hasName(df, "text"))

  df |>
    rowwise() |>
    mutate(point = list(list(x = x, y = y, xAxis = 0, yAxis = 0))) |>
    select(-x, -y) |>
    list_parse()
}
