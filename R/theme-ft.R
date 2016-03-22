#' Financial Times theme for highcharts
#' 
#' Financial Times theme for highcharts
#' 
#' @param ... Named argument to modify the theme
#' 
#' @examples 
#' 
#' hc_demo() %>% 
#'   hc_add_theme(hc_theme_ft())
#' 
#' @export
hc_theme_ft <- function(...){
  
  theme <-
  list(
    colors = c("#89736C",
               "#43423e",
               "#2e6e9e",
               "#FF0000",
               "#BEDDDE"),
    chart = list(
      backgroundColor = "#FFF1E0",
      style = list(
        fontFamily = "Droid Sans",
        color = '#777'
      )
    ),
    title = list(
      align = "left",
      style = list(
        fontFamily = "Droid Serif",
        color = "black",
        fontWeight = "bold"
      )
    ),
    subtitle = list(
      align = "left",
      style = list(
        fontFamily = "Droid Serif",
        fontWeight = "bold"
      )
    ),
    yAxis = list(
      gridLineDashStyle = "Dot",
      gridLineColor = '#CEC6B9',
      lineColor = '#CEC6B9',
      minorGridLineColor = '#CEC6B9',
      labels = list(
        align = "left",
        x = 0,
        y = -2
      ),
      tickLength = 0,
      tickColor = '#CEC6B9',
      tickWidth = 1,
      title = list(
        style = list(
          color = '#74736c'
        )
      )
    ),
    tooltip = list(
      backgroundColor = "#FFFFFF",
      borderColor = "#76c0c1",
      style = list(
        color = "#000000"
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
    
    drilldown = list(
      activeAxisLabelStyle = list(
        color = '#F0F0F3'
      ),
      activeDataLabelStyle = list(
        color = '#F0F0F3'
      )
    ),
    
    navigation = list(
      buttonOptions = list(
        symbolStroke = '#DDDDDD',
        theme = list(
          fill = '#505053'
        )
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

