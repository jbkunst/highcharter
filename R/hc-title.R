# Generated from Highcharts 12.6.0 by dev/generate-highcharts-title.R
#' Title options for highcharter objects
#'
#' The chart's main title.
#'
#' @param hc A `highchart` `htmlwidget` object.
#' @param ... Arguments defined in \url{https://api.highcharts.com/highcharts/title}.
#' @examples
#' highcharts_demo() |>
#'   hc_title(text = "Average monthly temperature by city", align = "left")
#' @export
hc_title <- function(hc, ...) {
  .hc_opt(hc, "title", ...)
}
