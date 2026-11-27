#' Connect interactions between charts in an HTML document
#'
#' Apply this helper to each widget, including widgets rendered in separate
#' Quarto HTML chunks. Each widget keeps its own data. The first X axis is
#' used for hover and zoom. Points are matched by their exact numeric X value
#' (including timestamps). Category axes should have the same category order.
#' A missing match clears the receiving tooltip and crosshair.
#'
#' @param hc A highchart widget.
#' @param group A non-empty group name shared by the charts on the page.
#' @param sync Interactions to share. `"hover"` links tooltips and crosshairs,
#'   `"zoom"` links X ranges and reset buttons, and `"legend"` links series or
#'   pie points with the same explicit `id`. Enable an interaction on both widgets.
#' @return The highchart widget.
#' @seealso [Connected charts](https://jkunst.com/highcharter/articles/connected-charts.html)
#'   for linked time series, legends across chart types, and a four-chart layout.
#' @examples
#' # Fictional monthly sales. Matching series IDs link the legends.
#' cafes <- list(
#'   list(id = "harbor", name = "Harbor", data = c(12, 15, 18, 16, 22, 25)),
#'   list(id = "garden", name = "Garden", data = c(18, 16, 14, 19, 21, 23)),
#'   list(id = "station", name = "Station", data = c(9, 12, 16, 21, 18, 24))
#' )
#' base <- highchart() |>
#'   hc_add_series_list(cafes) |>
#'   hc_xAxis(categories = month.abb[1:6], crosshair = TRUE) |>
#'   hc_yAxis(title = list(text = "Sales (thousands of dollars)")) |>
#'   hc_tooltip(shared = TRUE, table = TRUE, valueDecimals = 0,
#'              valuePrefix = "$", valueSuffix = "k") |>
#'   hc_connect("cafes", sync = c("hover", "legend")) |>
#'   hc_size(height = 320)
#'
#' # Hover a month or click a legend item in either chart.
#' trends <- base |>
#'   hc_chart(type = "line") |>
#'   hc_title(text = "Coffee around town") |>
#'   hc_subtitle(text = "Hover a month or toggle a cafe")
#' sales <- base |>
#'   hc_chart(type = "column") |>
#'   hc_title(text = "The same sales, another view") |>
#'   hc_plotOptions(column = list(
#'     borderRadius = 4,
#'     dataLabels = list(enabled = TRUE)
#'   )) |>
#'   hc_caption(text = "Legends and tooltips are linked in both directions.")
#' htmltools::browsable(htmltools::tagList(trends, sales))
#' @export
hc_connect <- function(hc, group, sync = c("hover", "zoom")) {
  stopifnot(is.highchart(hc))
  if (!rlang::is_string(group) || !nzchar(trimws(group))) {
    stop("Supply a non-empty group name.", call. = FALSE)
  }
  if (!length(sync) || !all(sync %in% c("hover", "zoom", "legend"))) {
    stop('Choose sync from "hover", "zoom" and "legend".', call. = FALSE)
  }
  hc$x$connect <- list(group = group, sync = as.list(unique(sync)))
  hc
}
