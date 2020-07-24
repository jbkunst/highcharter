#' Grid Light theme for highcharts
#' 
#' @param ... A named parameters to modify the theme.
#' 
#' @examples
#'
#' highcharts_demo() %>%
#'   hc_add_theme(hc_theme_gridlight())
#' @export
hc_theme_gridlight <- function(...) {
  theme <-
    list(
      colors = c(
        "#7CB5EC", "#F7A35C", "#90EE7E", "#7798BF",
        "#AAEEEE", "#FF0066", "#EEAAEE", "#55BF3B"
      ),
      chart = list(
        backgroundColor = NULL,
        style = list(
          fontFamily = "Dosis, sans-serif"
        )
      ),
      title = list(
        style = list(
          fontSize = "16px",
          fontWeight = "bold",
          textTransform = "uppercase"
        )
      ),
      tooltip = list(
        borderWidth = 0,
        backgroundColor = "rgba(219,219,216,0.8)",
        shadow = FALSE
      ),
      legend = list(
        itemStyle = list(
          fontWeight = "bold",
          fontSize = "13px"
        )
      ),
      xAxis = list(
        gridLineWidth = 1,
        labels = list(
          style = list(
            fontSize = "12px"
          )
        )
      ),
      yAxis = list(
        minorTickInterval = "auto",
        title = list(
          style = list(
            textTransform = "uppercase"
          )
        ),
        labels = list(
          style = list(
            fontSize = "12px"
          )
        )
      ),
      plotOptions = list(
        candlestick = list(
          lineColor = "#404048"
        )
      ),

      background2 = "#F0F0EA"
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
