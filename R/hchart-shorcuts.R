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
