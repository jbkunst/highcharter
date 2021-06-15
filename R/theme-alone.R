#' Alone theme for highcharts
#'
#' @param ... A named parameters to modify the theme.
#'
#' @examples
#'
#' highcharts_demo() %>%
#'   hc_add_theme(hc_theme_alone())
#' @export
hc_theme_alone <- function(...) {
  theme <-
    hc_theme(
      colors = c(
        "#d35400", "#2980b9", "#2ecc71",
        "#f1c40f", "#2c3e50", "#7f8c8d"
      ),
      chart = list(
        backgroundColor = "#161C20",
        style = list(
          fontFamily = "Roboto",
          color = "#666666"
        )
      ),
      title = list(
        align = "left",
        style = list(
          fontFamily = "Roboto Condensed",
          fontWeight = "bold"
        )
      ),
      subtitle = list(
        align = "left",
        style = list(
          fontFamily = "Roboto Condensed"
        )
      ),
      legend = list(
        align = "right",
        verticalAlign = "bottom",
        itemStyle = list(
          color = "#424242"
        )
      ),
      xAxis = list(
        gridLineColor = "#424242",
        gridLineWidth = 1,
        minorGridLineColor = "#424242",
        minoGridLineWidth = 0.5,
        tickColor = "#424242",
        minorTickColor = "#424242",
        lineColor = "#424242"
      ),
      yAxis = list(
        gridLineColor = "#424242",
        ridLineWidth = 1,
        minorGridLineColor = "#424242",
        inoGridLineWidth = 0.5,
        tickColor = "#424242",
        minorTickColor = "#424242",
        lineColor = "#424242"
      ),
      plotOptions = list(
        line = list(
          marker = list(enabled = FALSE)
        ),
        spline = list(
          marker = list(enabled = FALSE)
        ),
        area = list(
          marker = list(enabled = FALSE)
        ),
        areaspline = list(
          marker = list(enabled = FALSE)
        ),
        arearange = list(
          marker = list(enabled = FALSE)
        ),
        bubble = list(
          maxSize = "10%"
        )
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
