#' Shortcut to make spkarlines
#' @param x A numeric vector.
#' @param type Type sparkline: line, bar, etc.
#' @param ... Additional arguments for the data series \url{https://api.highcharts.com/highcharts/series}.
#'
#' @examples
#'
#' set.seed(123)
#' x <- cumsum(rnorm(10))
#'
#' hcspark(x)
#' hcspark(x, "columnn")
#' hcspark(c(1, 4, 5), "pie")
#' hcspark(x, type = "area")
#' @export
hcspark <- function(x = NULL, type = NULL, ...) {
  .Deprecated(
    msg = "Use type 'hc_theme_sparkline' or hc_theme_sparkline_bv theme instead."
  )

  stopifnot(is.numeric(x))

  highchart() |>
    hc_plotOptions(
      series = list(showInLegend = FALSE, dataLabels = list(enabled = FALSE)),
      line = list(marker = list(enabled = FALSE))
    ) |>
    hc_add_series(data = x, type = type, ...) |>
    hc_add_theme(hc_theme_sparkline())
}

#' Shortcut to make icon arrays charts
#' @param labels A character vector
#' @param counts A integer vector
#' @param rows A integer to set
#' @param icons A character vector same length (o length 1) as labels
#' @param size Font size
#' @param ... Additional arguments for the data series \url{https://api.highcharts.com/highcharts/series}.
#' @importFrom dplyr ungroup group_by
#' @importFrom rlang .data
#' @export
hciconarray <- function(labels, counts, rows = NULL, icons = NULL, size = 4,
                        ...) {
  .Deprecated(
    msg = "Use type 'item' instead (`hchart(df, \"item\", hcaes(name = labels, y = counts))`).
Item chart provides better behaviour beside is a specific type of chart of HighchartsJS."
  )

  assertthat::assert_that(length(counts) == length(labels))

  if (is.null(rows)) {
    sizegrid <- n2mfrow(sum(counts))
    w <- sizegrid[1]
    h <- sizegrid[2]
  } else {
    h <- rows
    w <- ceiling(sum(counts) / rows)
  }

  ds <- tibble(x = rep(1:w, h), y = rep(1:h, each = w)) |>
    head(sum(counts)) |>
    mutate(y = -.data$y) |>
    mutate(gr = rep(seq_along(labels), times = counts)) |>
    left_join(tibble(gr = seq_along(labels), name = as.character(labels)),
      by = "gr"
    ) |>
    group_by(.data$name) |>
    do(data = list_parse2(tibble(.$x, .$y))) |>
    ungroup() |>
    left_join(tibble(labels = as.character(labels), counts),
      by = c("name" = "labels")
    ) |>
    arrange_("-counts") |>
    mutate(percent = .data$counts / sum(.data$counts) * 100)

  if (!is.null(icons)) {
    assertthat::assert_that(length(icons) %in% c(1, length(labels)))

    dsmrk <- ds |>
      mutate(iconm = icons) |>
      group_by(.data$name) |>
      do(marker = list(symbol = fa_icon_mark(.$iconm)))

    ds <- ds |>
      left_join(dsmrk, by = "name") |>
      mutate(icon = fa_icon(icons))
  }

  ds <- mutate(ds, ...)

  hc <- highchart() |>
    hc_chart(type = "scatter") |>
    hc_add_series_list(ds) |>
    hc_plotOptions(
      series =
        list(
          cursor = "default",
          marker = list(radius = size),
          states = list(hover = list(enabled = FALSE)),
          events = list(
            legendItemClick = JS("function () { return false; }")
          )
        )
    ) |>
    hc_tooltip(pointFormat = "{point.series.options.counts} ({point.series.options.percent:.2f}%)") |>
    hc_add_theme(
      hc_theme_merge(
        getOption("highcharter.theme"),
        hc_theme_null()
      )
    )

  if (!is.null(icons)) {
    hc <- hc |> hc_add_dependency_fa()
  }

  hc
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
