#' Highcharter theme for highcharts
#'
#' Theme use for the documentatios webiste.
#'
#' @rdname hc_theme_538
#'
#' @examples
#'
#' highcharts_demo() %>%
#'   hc_add_theme(hc_theme_hcrt())
#'   
#' @export
hc_theme_hcrt <- function(...) {
  theme <-
    hc_theme(
      colors = c(
        "#47475c", # main purple
        
        "#61BC7B", # green
        "#508CC8", # blue
        "#F49952", # orange
        "#9C9EDB",  # purple
        
        "#6699a1" # gray green
        
      ),
      chart = list(
        style = list(
          fontFamily = "Roboto",
          color = "#666666"
        )
      ),
      title = list(
        align = "left",
        style = list(
          fontFamily = "Alegreya Sans SC",
          fontSize = "2em"
        )
      ),
      subtitle = list(
        align = "left",
        style = list(
          fontFamily = "Alegreya Sans",
          fontSize = "1.3em"
        )
      ),
      caption = list(
        style = list(
          fontFamily = "Alegreya Sans",
          fontSize = "1.25em"
        )
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
