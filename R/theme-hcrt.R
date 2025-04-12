#' Highcharter theme for highcharts
#'
#' hcrt theme is used for the documentation website.
#'
#' @param ... A named parameters to modify the theme.
#'
#' @examples
#'
#' highcharts_demo() |>
#'   hc_add_theme(hc_theme_hcrt())
#' @export
hc_theme_hcrt <- function(...) {
  theme <-
    hc_theme(
      colors = c(
        "#47475c", # main purple

        "#61BC7B", # green
        "#508CC8", # blue
        "#F49952", # orange
        "#9C9EDB", # purple

        "#6699a1" # gray green
      ),
      chart = list(
        style = list(
          fontFamily = "IBM Plex Sans",
          color = "#666666"
        )
      ),
      title = list(
        align = "left",
        style = list(
          fontFamily = "Alegreya Sans SC",
          fontSize = "24px"
        )
      ),
      subtitle = list(
        align = "left",
        style = list(
          fontFamily = "Alegreya Sans",
          fontSize = "16px"
        )
      ),
      caption = list(
        style = list(
          fontFamily = "Alegreya Sans",
          fontSize = "14px"
        )
      ),
      credits = list(
        style = list(
          fontFamily = "Roboto",
          fontSize = "10px"
        )
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
