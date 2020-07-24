#' Monokai theme for highcharts
#'
#' Monokai is a well know text editor theme.
#'
#' @examples
#'
#' highcharts_demo() %>%
#'   hc_add_theme(hc_theme_monokai())
#'   
#' @export
hc_theme_monokai <- function(...) {
  theme <-
    hc_theme(
      colors = c("#F92672", "#66D9EF", "#A6E22E", "#A6E22E"),
      chart = list(
        backgroundColor = "#272822",
        style = list(
          fontFamily = "Inconsolata",
          color = "#A2A39C"
        )
      ),
      title = list(
        style = list(
          color = "#A2A39C"
        ),
        align = "left"
      ),
      subtitle = list(
        style = list(
          color = "#A2A39C"
        ),
        align = "left"
      ),
      legend = list(
        align = "right",
        verticalAlign = "bottom",
        itemStyle = list(
          fontWeight = "normal",
          color = "#A2A39C"
        )
      ),
      xAxis = list(
        gridLineDashStyle = "Dot",
        gridLineWidth = 1,
        gridLineColor = "#A2A39C",
        lineColor = "#A2A39C",
        minorGridLineColor = "#A2A39C",
        tickColor = "#A2A39C",
        tickWidth = 1
      ),
      yAxis = list(
        gridLineDashStyle = "Dot",
        gridLineColor = "#A2A39C",
        lineColor = "#A2A39C",
        minorGridLineColor = "#A2A39C",
        tickColor = "#A2A39C",
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
