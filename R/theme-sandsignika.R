#' Sand Signika theme for highcharts
#'
#' @param ... A named parameters to modify the theme.
#'
#' @examples
#'
#' highcharts_demo() %>%
#'   hc_add_theme(hc_theme_sandsignika())
#' @export
hc_theme_sandsignika <- function(...) {
  theme <-
    list(
      colors = c(
        "#F45B5B", "#8085E9", "#8D4654", "#7798BF", "#AAEEEE",
        "#FF0066", "#EEAAEE", "#55BF3B", "#DF5353"
      ),
      chart = list(
        backgroundColor = NULL,
        divBackgroundImage =
          "https://www.highcharts.com/samples/graphics/sand.png",
        style = list(
          fontFamily = "Signika, serif"
        )
      ),
      title = list(
        style = list(
          color = "black",
          fontSize = "16px",
          fontWeight = "bold"
        )
      ),
      subtitle = list(
        style = list(
          color = "black"
        )
      ),
      tooltip = list(
        borderWidth = 0
      ),
      legend = list(
        itemStyle = list(
          fontWeight = "bold",
          fontSize = "13px"
        )
      ),
      xAxis = list(
        labels = list(
          style = list(
            color = "#6e6e70"
          )
        )
      ),
      yAxis = list(
        labels = list(
          style = list(
            color = "#6e6e70"
          )
        )
      ),
      plotOptions = list(
        series = list(
          shadow = FALSE
        ),
        candlestick = list(
          lineColor = "#404048"
        ),
        map = list(
          shadow = FALSE
        )
      ),
      navigator = list(
        xAxis = list(
          gridLineColor = "#D0D0D8"
        )
      ),
      rangeSelector = list(
        buttonTheme = list(
          fill = "white",
          stroke = "#C0C0C8",
          "stroke-width" = 1,
          states = list(
            select = list(
              fill = "#D0D0D8"
            )
          )
        )
      ),
      scrollbar = list(
        trackBorderColor = "#C0C0C8"
      ),
      background2 = "#E0E0E8"
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
