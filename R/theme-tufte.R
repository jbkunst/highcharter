#' Tufte theme for highcharts
#' 
#' @param ... A named parameters to modify the theme.
#' 
#' @examples
#'
#' n <- 15
#' 
#' dta <- data.frame(
#'   x = 1:n + rnorm(n),
#'   y = 2 * 1:n + rnorm(n)
#' )
#' 
#' highchart() %>%
#'   hc_chart(type = "scatter") %>%
#'   hc_add_series(data = list_parse(dta), showInLegend = FALSE) %>%
#'   hc_add_theme(hc_theme_tufte())
#'
#' @export
hc_theme_tufte <- function(...) {
  theme <-
    hc_theme(
      colors = list("#737373", "#D8D7D6", "#B2B0AD", "#8C8984"),
      chart = list(
        style = list(
          fontFamily = "Cardo"
        )
      ),
      xAxis = list(
        lineWidth = 0,
        minorGridLineWidth = 0,
        lineColor = "transparent",
        tickColor = "#737373"
      ),
      yAxis = list(
        lineWidth = 0,
        minorGridLineWidth = 0,
        lineColor = "transparent",
        tickColor = "#737373",
        # extra to yAxis
        tickWidth = 1,
        gridLineColor = "transparent"
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

#' @rdname hc_theme_538
#' 
#' @examples 
#' 
#' highchart() %>%
#'   hc_chart(type = "column") %>%
#'   hc_add_series(data = round(1 + abs(rnorm(12)), 2), showInLegend = FALSE) %>%
#'   hc_xAxis(categories = month.abb) %>%
#'   hc_add_theme(hc_theme_tufte2())
#' 
#' @export
hc_theme_tufte2 <- function(...) {
  
  theme <- hc_theme_tufte(
    xAxis = list(tickWidth = 0, lineWidth = 1, lineColor = "#737373"),
    yAxis = list(tickWidth = 0, lineWidth = 1, gridLineColor = "white", gridZIndex = 4)
  )

  if (length(list(...)) > 0) {
    theme <- hc_theme_merge(
      theme,
      hc_theme(...)
    )
  }

  theme
}
