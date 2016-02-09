#' Fivethirtyeight theme for highcharts
#' 
#' Fivethirtyeight theme for highcharts
#' 
#' @examples 
#' 
#' hc_demo() %>% 
#'   hc_add_theme(hc_theme_economist())
#' 
#' @export
hc_theme_economist <- function(){
  
  theme <-
  list(
    colors = c("#6794a7",
               "#014d64",
               "#76c0c1",
               "#01a2d9",
               "#7ad2f6",
               "#00887d",
               "#adadad",
               "#7bd3f6",
               "#7c260b",
               "#ee8f71",
               "#76c0c1",
               "#a18376"),
    chart = list(
      backgroundColor = "#d5e4eb",
      style = list(
        fontFamily = "Droid Sans",
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
    yAxis = list(
      gridLineColor = '#FFFFFF',
      lineColor = '#FFFFFF',
      minorGridLineColor = '#FFFFFF',
      tickColor = '#D7D7D8',
      tickWidth = 1,
      title = list(
        style = list(
          color = '#A0A0A3'
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
      itemHoverStyle = list(
        color = '#FFF'
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
  
  theme
  
}

