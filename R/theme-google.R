#' Google theme for highcharts
#'
#' Google theme for highcharts is based on \url{https://books.google.com/ngrams/}.
#'
#' @param ... A named parameters to modify the theme.
#'
#' @examples
#'
#' highcharts_demo() |>
#'   hc_add_theme(hc_theme_google())
#' @export
hc_theme_google <- function(...) {
  theme <-
    list(
      colors = c("#0266C8", "#F90101", "#F2B50F", "#00933B"),
      chart = list(
        style = list(
          fontFamily = "Roboto",
          color = "#444444"
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
      legendBackgroundColor = "rgba(0, 0, 0, 0.5)",
      background2 = "#505053",
      dataLabelsColor = "#B0B0B3",
      textColor = "#C0C0C0",
      contrastTextColor = "#F0F0F3",
      maskColor = "rgba(255,255,255,0.3)"
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
