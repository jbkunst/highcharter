#' Fivethirtyeight theme for highcharts
#' 
#' Fivethirtyeight theme for highcharts
#' 
#' @examples 
#' 
#' highchart() %>% 
#'   hc_add_series(data = list.parse2(data.frame(rnorm(15), runif(15))), type = "scatter") %>% 
#'   hc_add_series(data = list.parse2(data.frame(rexp(15), rexp(15))), type = "scatter") %>% 
#'   hc_add_theme(hc_theme_538()) %>% 
#'   hc_title(text = "Some Long Title") %>% 
#'   hc_subtitle(text = "Some subtitle")
#' 
#' @export
hc_theme_538 <- function(){
  
  theme <-
  list(
    colors = c("#636464", "#C4C4C4","#FF2700", "#008FD5", "#77AB43"),
    chart = list(
      backgroundColor = "#F0F0F0",
      plotBorderColor = '#606063'
    ),
    title = list(
      align = "left",
      style = list(
        fontWeight = "bold",
        color = '#3C3C3C',
        fontSize = '20px'
      )
    ),
    subtitle = list(
      align = "left",
      style = list(
        color = '#3C3C3C'
      )
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
    
    rangeSelector = list(
      buttonTheme = list(
        fill = '#505053',
        stroke = '#000000',
        style = list(
          color = '#CCC'
        ),
        states = list(
          hover = list(
            fill = '#D7D7D8',
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
  
  theme
  
}

