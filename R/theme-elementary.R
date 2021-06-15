#' Elementary (OS) theme for highcharts
#'
#' Elementary (OS) theme for highcharts was based on \url{https://elementary.io}
#'
#' @param ... A named parameters to modify the theme.
#'
#' @examples
#'
#' highcharts_demo() %>%
#'   hc_add_theme(hc_theme_elementary())
#' @export
hc_theme_elementary <- function(...) {
  theme <-
    list(
      colors = list("#41B5E9", "#FA8832", "#34393C", "#E46151"),
      chart = list(
        style = list(
          color = "#333",
          fontFamily = "Open Sans"
        )
      ),
      title = list(
        style = list(
          fontFamily = "Raleway",
          fontWeight = "100"
        )
      ),
      subtitle = list(
        style = list(
          fontFamily = "Raleway",
          fontWeight = "100"
        )
      ),
      legend = list(
        align = "right",
        verticalAlign = "bottom"
      ),
      xAxis = list(
        gridLineWidth = 1,
        gridLineColor = "#F3F3F3",
        lineColor = "#F3F3F3",
        minorGridLineColor = "#F3F3F3",
        tickColor = "#F3F3F3",
        tickWidth = 1
      ),
      yAxis = list(
        gridLineColor = "#F3F3F3",
        lineColor = "#F3F3F3",
        minorGridLineColor = "#F3F3F3",
        tickColor = "#F3F3F3",
        tickWidth = 1
      )
    )
  theme <- structure(theme, class = "hc_theme")

  if (length(list(...)) > 0) {
    theme <- hc_theme_merge(
      theme,
      hc_theme(...)
    )
  }

  theme
}
