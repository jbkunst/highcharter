#' Boolmberg Graphics theme for highcharts
#' 
#' @param ... Named argument to modify the theme
#' 
#' @examples 
#' 
#' highcharts_demo() %>% 
#'   hc_add_theme(hc_theme_bloom())
#' 
#' @export
hc_theme_bloom <- function(...){
  
  theme <-
  list(
    colors = c("#E10033", "#000000", "#767676", "#E4E4E4"),
    chart = list(
      backgroundColor = "#FFFFFF",
      style = list(
        fontFamily = "Roboto",
        color = "#000000"
      )
    ),
    title = list(
      align = "left",
      style = list(
        fontFamily = "Roboto",
        color = "#000000",
        fontWeight = "bold"
      )
    ),
    subtitle = list(
      align = "left",
      style = list(
        fontFamily = "Roboto",
        color = "#000000",
        fontWeight = "bold"
      )
    ),
    xAxis = list(
      lineColor = "#000000",
      lineWidth = 2,
      tickColor = "#000000",
      tickWidth = 2,
      labels = list(
        style = list(
          color = "black"
        )
      ),
      title = list(
        style = list(
          color = "black"
        )
      )
    ),
    yAxis = list(
      opposite = TRUE,
      #gridLineDashStyle = "Dot",
      gridLineWidth = 2,
      gridLineColor = "#F3F3F3",
      lineColor = "#CEC6B9",
      minorGridLineColor = "#CEC6B9",
      labels = list(
        align = "left",
        style = list(
          color = "black"
        ),
        x = 0,
        y = -2
      ),
      tickLength = 0,
      tickColor = "#CEC6B9",
      tickWidth = 1,
      title = list(
        style = list(
          color = "black"
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
      layout ='horizontal',
      align = 'left',
      verticalAlign= 'top',
      itemStyle = list(
        color = "#3C3C3C"
      ),
      itemHiddenStyle = list(
        color = "#606063"
      )
    ),
    credits = list(
      style = list(
        color = "#666"
      )
    ),
    labels = list(
      style = list(
        color = "#D7D7D8"
      )
    ),
    
    drilldown = list(
      activeAxisLabelStyle = list(
        color = "#F0F0F3"
      ),
      activeDataLabelStyle = list(
        color = "#F0F0F3"
      )
    ),
    
    navigation = list(
      buttonOptions = list(
        symbolStroke = "#DDDDDD",
        theme = list(
          fill = "#505053"
        )
      )
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

