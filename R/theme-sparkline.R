#' Sparkline theme for highcharts
#' 
#' Based on \url{http://www.highcharts.com/demo/sparkline}.
#' 
#' @param ... Named argument to modify the theme
#' 
#' @examples
#' 
#' hc_demo() %>% 
#'   hc_add_theme(hc_theme_sparkline())
#'   
#' @export
hc_theme_sparkline <- function(...) {
  
  theme <- list(
    chart = list(
      backgroundColor = NULL,
      borderWidth = 0,
      margin = list(2, 0, 2, 0),
      style = list(
        overflow = "visible"
      ),
      skipClone = TRUE
    ),
    title = list(text = ""),
    xAxis = list(
      labels = list(enabled = FALSE),
      title = list(text = NULL),
      startOnTick = FALSE,
      endOnTick = FALSE,
      tickPositions = list()
    ),
    yAxis = list(
      endOnTick = FALSE,
      startOnTick = FALSE,
      labels = list(
        enabled = FALSE
      ),
      title = list(
        text = NULL
      ),
      tickPositions = list()
    ),
    tooltip = list(
      backgroundColor = NULL,
      borderWidth = 0,
      shadow = FALSE,
      useHTML = TRUE,
      hideDelay = 0,
      shared = TRUE,
      padding = 0,
      positioner = JS(
        "function (w, h, point) { return { x: point.plotX - w / 2,
        y: point.plotY - h };}")
      ),
    plotOptions = list(
      series = list(
        animation = FALSE,
        lineWidth = 1,
        shadow = FALSE,
        states = list(
          hover = list(
            lineWidth = 1
          )
        ),
        marker = list(
          radius = 1,
          states = list(
            hover = list(
              radius = 2
            )
          )
        ),
        fillOpacity = 0.25
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
