#' Null theme for highcharts
#'
#' For Null theme the axis are removed (\code{visible = FALSE}).
#' 
#' @param ... A named parameters to modify the theme.
#' 
#' @examples
#'
#' highcharts_demo() %>%
#'   hc_add_theme(hc_theme_null())
#' @export
hc_theme_null <- function(...) {
  theme <-
    list(
      chart = list(
        backgroundColor = "transparent"
      ),
      plotOptions = list(
        line = list(
          marker = list(
            enabled = FALSE
          )
        )
      ),
      legend = list(
        enabled = TRUE,
        align = "right",
        verticalAlign = "bottom"
      ),
      credits = list(
        enabled = FALSE
      ),
      xAxis = list(
        visible = FALSE
      ),
      yAxis = list(
        visible = FALSE
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
