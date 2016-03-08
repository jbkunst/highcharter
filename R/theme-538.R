#' Fivethirtyeight theme for highcharts
#' 
#' Fivethirtyeight theme for highcharts
#' 
#' @param ... Named argument to modify the theme
#' 
#' @examples 
#' 
#' hc_demo() %>% 
#'   hc_add_theme(hc_theme_538())
#'    
#' hc_demo() %>%
#'   hc_add_theme(
#'     hc_theme_538(
#'       colors = c("red", "blue", "green"),
#'       chart = list(backgroundColor = "white")
#'     )
#'   )
#' 
#' @export
hc_theme_538 <- function(...){
  
  theme <-
  list(
    colors = c("#FF2700", "#008FD5", "#77AB43", "#636464", "#C4C4C4"),
    chart = list(
      backgroundColor = "#F0F0F0",
      plotBorderColor = '#606063',
      style = list(
        fontFamily = "Roboto",
        color = '#3C3C3C'
      )
    ),
    title = list(
      align = "left",
      style = list(
        fontWeight = "bold"
      )
    ),
    subtitle = list(
      align = "left"
    ),
    xAxis = list(
      gridLineWidth = 1,
      gridLineColor = '#D7D7D8',
      labels = list(
        style = list(
          fontFamily = "Unica One, sans-serif",
          color = '#3C3C3C'
        )
      ),
      lineColor = '#D7D7D8',
      minorGridLineColor = '#505053',
      tickColor = '#D7D7D8',
      tickWidth = 1,
      title = list(
        style = list(
          color = '#A0A0A3'
        )
      )
    ),
    yAxis = list(
      gridLineColor = '#D7D7D8',
      labels = list(
        style = list(
          fontFamily = "Unica One, sans-serif",
          color = '#3C3C3C'
        )
      ),
      lineColor = '#D7D7D8',
      minorGridLineColor = '#505053',
      tickColor = '#D7D7D8',
      tickWidth = 1,
      title = list(
        style = list(
          color = '#A0A0A3'
        )
      )
    ),
    tooltip = list(
      backgroundColor = 'rgba(0, 0, 0, 0.85)',
      style = list(
        color = '#F0F0F0'
      )
    ),
    legend = list(
      itemStyle = list(
        color = '#3C3C3C'
      ),
      itemHiddenStyle = list(
        color = '#606063'
      )
    ),
    credits = list(
      style = list(
        color = '#666'
      )
    ),
    labels = list(
      style = list(
        color = '#D7D7D8'
      )
    ),
    
    legendBackgroundColor = 'rgba(0, 0, 0, 0.5)',
    background2 = '#505053',
    dataLabelsColor = '#B0B0B3',
    textColor = '#C0C0C0',
    contrastTextColor = '#F0F0F3',
    maskColor = 'rgba(255,255,255,0.3)'
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

