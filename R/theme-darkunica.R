#' Dark Unica theme for highcharts
#' 
#' Dark unica theme for highcharts
#' 
#' @param ... Named argument to modify the theme
#' 
#' @examples 
#' 
#' hc_demo() %>% 
#'   hc_add_theme(hc_theme_darkunica())
#' 
#' @export
hc_theme_darkunica <- function(...){
  
  theme <-
  list(
    colors = c("#2b908f", "#90ee7e", "#f45b5b", "#7798BF", "#aaeeee", "#ff0066", "#eeaaee",
               "#55BF3B", "#DF5353", "#7798BF", "#aaeeee"),
    chart = list(
      backgroundColor = list(
        linearGradient = list( x1 = 0, y1 = 0, x2 = 1, y2 = 1 ),
        stops = list(
          list(0, '#2a2a2b'),
          list(1, '#3e3e40')
        )
      ),
      style = list(
        fontFamily = "Unica One, sans-serif"
      ),
      plotBorderColor = '#606063'
    ),
    title = list(
      style = list(
        color = '#E0E0E3',
        textTransform = 'uppercase',
        fontSize = '20px'
      )
    ),
    subtitle = list(
      style = list(
        color = '#E0E0E3',
        textTransform = 'uppercase'
      )
    ),
    xAxis = list(
      gridLineColor = '#707073',
      labels = list(
        style = list(
          color = '#E0E0E3'
        )
      ),
      lineColor = '#707073',
      minorGridLineColor = '#505053',
      tickColor = '#707073',
      title = list(
        style = list(
          color = '#A0A0A3'
          
        )
      )
    ),
    yAxis = list(
      gridLineColor = '#707073',
      labels = list(
        style = list(
          color = '#E0E0E3'
        )
      ),
      lineColor = '#707073',
      minorGridLineColor = '#505053',
      tickColor = '#707073',
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
    plotOptions = list(
      series = list(
        dataLabels = list(
          color = '#B0B0B3'
        ),
        marker = list(
          lineColor = '#333'
        )
      ),
      boxplot = list(
        fillColor = '#505053'
      ),
      candlestick = list(
        lineColor = 'white'
      ),
      errorbar = list(
        color = 'white'
      )
    ),
    legend = list(
      itemStyle = list(
        color = '#E0E0E3'
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
        color = '#707073'
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
    
    rangeSelector = list(
      buttonTheme = list(
        fill = '#505053',
        stroke = '#000000',
        style = list(
          color = '#CCC'
        ),
        states = list(
          hover = list(
            fill = '#707073',
            stroke = '#000000',
            style = list(
              color = 'white'
            )
          ),
          select = list(
            fill = '#000003',
            stroke = '#000000',
            style = list(
              color = 'white'
            )
          )
        )
      ),
      inputBoxBorderColor = '#505053',
      inputStyle = list(
        backgroundColor = '#333',
        color = 'silver'
      ),
      labelStyle = list(
        color = 'silver'
      )
    ),
    
    navigator = list(
      handles = list(
        backgroundColor = '#666',
        borderColor = '#AAA'
      ),
      outlineColor = '#CCC',
      maskFill = 'rgba(255,255,255,0.1)',
      series = list(
        color = '#7798BF',
        lineColor = '#A6C7ED'
      ),
      xAxis = list(
        gridLineColor = '#505053'
      )
    ),
    
    scrollbar = list(
      barBackgroundColor = '#808083',
      barBorderColor = '#808083',
      buttonArrowColor = '#CCC',
      buttonBackgroundColor = '#606063',
      buttonBorderColor = '#606063',
      rifleColor = '#FFF',
      trackBackgroundColor = '#404043',
      trackBorderColor = '#404043'
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
