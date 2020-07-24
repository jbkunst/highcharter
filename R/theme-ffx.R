#' Firefox theme for highcharts
#'
#' Firefox theme was inspired by \url{https://www.mozilla.org/en-US/styleguide/}.
#' 
#' @param ... A named parameters to modify the theme.
#' 
#' @examples
#'
#' highcharts_demo() %>%
#'   hc_add_theme(hc_theme_ffx())
#' @export
hc_theme_ffx <- function(...) {
  theme <-
    hc_theme(
      colors = c("#00AACC", "#FF4E00", "#B90000", "#5F9B0A", "#CD6723"),
      chart = list(
        backgroundColor = list(
          linearGradient = list(0, 0, 0, 150),
          stops = list(
            list(0, "#CAE1F4"),
            list(1, "#EEEEEE")
          )
        ),
        style = list(
          fontFamily = "Open Sans"
        )
      ),
      title = list(
        align = "left"
      ),
      subtitle = list(
        align = "left"
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
