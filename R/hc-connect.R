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
#' @examples
#' north <- highchart() |>
#'   hc_add_series(id = "north", name = "North", data = c(4, 2, 7)) |>
#'   hc_connect("regions", sync = "legend")
#' shares <- highchart() |>
#'   hc_add_series(type = "pie", data = list(
#'     list(id = "north", name = "North", y = 7),
#'     list(id = "south", name = "South", y = 5)
#'   )) |>
#'   hc_legend(enabled = FALSE) |>
#'   hc_connect("regions", sync = "legend")
#' htmltools::browsable(htmltools::tagList(north, shares))
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
