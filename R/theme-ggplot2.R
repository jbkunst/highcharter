#' ggplot2 theme for highcharts
#'
#' ggplot2 theme is based on \url{https://ggplot2.tidyverse.org/}.
#'
#' @rdname hc_theme_538
#'
#' @examples
#'
#' highcharts_demo() %>%
#'   hc_add_theme(hc_theme_ggplot2())
#' @export
hc_theme_ggplot2 <- function(...) {
  theme <- hc_theme(
    chart = list(
      plotBackgroundColor = "#EBEBEB",
      style = list(
        color = "#000000",
        fontFamily = "Arial, sans-serif"
      )
    ),
    colors = c("#595959", "#F8766D", "#A3A500", "#00BF7D", "#00B0F6", "#E76BF3"),
    xAxis = list(
      labels = list(style = list(color = "#666666")),
      title = list(style = list(color = "#000000")),
      startOnTick = FALSE,
      endOnTick = FALSE,
      gridLineColor = "#FFFFFF",
      gridLineWidth = 1.5,
      tickWidth = 1.5,
      tickLength = 5,
      tickColor = "#666666",
      minorTickInterval = 0,
      minorGridLineColor = "#FFFFFF",
      minorGridLineWidth = 0.5
    ),
    yAxis = list(
      labels = list(style = list(color = "#666666")),
      title = list(style = list(color = "#000000")),
      startOnTick = FALSE,
      endOnTick = FALSE,
      gridLineColor = "#FFFFFF",
      gridLineWidth = 1.5,
      tickWidth = 1.5,
      tickLength = 5,
      tickColor = "#666666",
      minorTickInterval = 0,
      minorGridLineColor = "#FFFFFF",
      minorGridLineWidth = 0.5
    ),
    legendBackgroundColor = "rgba(0, 0, 0, 0.5)",
    background2 = "#505053",
    dataLabelsColor = "#B0B0B3",
    textColor = "#C0C0C0",
    contrastTextColor = "#F0F0F3",
    maskColor = "rgba(255,255,255,0.3)"
  )

  if (length(list(...)) > 0) {
    theme <- hc_theme_merge(
      theme,
      hc_theme(...)
    )
  }

  theme
}
