#' Sparkline theme for highcharts
#'
#' Sparkline theme is based on \url{http://www.highcharts.com/demo/sparkline}
#' and this post  \url{http://jkunst.com/blog/posts/2020-06-26-valuebox-and-sparklines/}.
#'
#' @rdname hc_theme_538
#'
#' @examples
#'
#' highcharts_demo() %>%
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
        "function (w, h, point) { return {
            x: point.plotX - w / 2,
            y: point.plotY - h
          };
        }"
      )
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


#' @rdname hc_theme_538
#' 
#' @examples
#'
#' highcharts_demo() %>%
#'   hc_add_theme(hc_theme_sparkline_vb())
#' 
#' @export
hc_theme_sparkline_vb <- function(...) {
  
  theme <- list(
    chart = list(
      backgroundColor = NULL,
      margins = c(0, 0, 0, 0),
      spacingTop = 0,
      spacingRight = 0,
      spacingBottom = 0,
      spacingLeft = 0,
      plotBorderWidth = 0,
      borderWidth = 0,
      style = list(overflow = "visible")
    ),
    xAxis = list(
      visible = FALSE, 
      endOnTick = FALSE, 
      startOnTick = FALSE
    ),
    yAxis = list(
      visible = FALSE,
      endOnTick = FALSE, 
      startOnTick = FALSE
    ),
    tooltip = list(
      outside = FALSE,
      shadow = FALSE,
      borderColor = "transparent",
      botderWidth = 0,
      backgroundColor = "transparent",
      style = list(textOutline = "5px white")
    ),
    plotOptions = list(
      series = list(
        marker = list(enabled = FALSE),
        shadow = FALSE,
        fillOpacity = 0.25,
        color = "#FFFFFFBF",
        fillColor = list(
          linearGradient = list(x1 = 0, y1 = 1, x2 = 0, y2 = 0),
          stops = list(
            list(0.00, "#FFFFFF00"),
            list(0.50, "#FFFFFF7F"),
            list(1.00, "#FFFFFFFF")
          )
        )
      )
    ),
    credits = list(
      enabled = FALSE,
      text = ""
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
