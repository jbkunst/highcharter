#' Superheroes theme for highcharts
#'
#' The superheroes theme is inspired by \url{https://public.tableau.com/profile/ryansmith#!/vizhome/HeroesofNewYork/SuperheroesinNewYork}
#'
#' @examples
#'
#' highcharts_demo() %>%
#'   hc_add_theme(hc_theme_superheroes())
#'   
#' @export
hc_theme_superheroes <- function(...) {
  theme <- hc_theme_flat(
    chart = list(
      backgroundColor = "#0B486B",
      style = list(
        color = "white",
        fontFamily = "Oswald",
        fontWeight = "normal"
      )
    ),
    xAxis = list(
      gridLineColor = "#46627f",
      tickColor = "#46627f",
      lineColor = "#46627f",
      title = list(
        style = list(
          color = "#FFFFFF"
        )
      )
    ),
    yAxis = list(
      gridLineColor = "#46627f",
      tickColor = "#46627f",
      title = list(
        style = list(
          color = "#FFFFFF"
        )
      )
    ),
    title = list(
      style = list(
        fontSize = "2em",
        fontFamily = "Bangers",
        color = "#FFFFFF"
      )
    ),
    subtitle = list(
      style = list(
        color = "#FFFFFF"
      )
    ),
    legend = list(
      itemStyle = list(
        color = "white",
        fontWeight = "normal"
      ),
      itemHoverStyle = list(
        color = "#C0C0C0"
      ),
      itemHiddenStyle = list(
        color = "#444444"
      )
    )
  )

  if (length(list(...)) > 0) {
    theme <- hc_theme_merge(
      theme,
      hc_theme(...)
    )
  }

  theme
}
