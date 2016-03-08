#' Grid Light theme for highchart
#' 
#' Grid Light theme for highchart
#' 
#' @param ... Named argument to modify the theme
#' 
#' @examples 
#' 
#' hc_demo() %>% 
#'   hc_add_theme(hc_theme_gridlight())
#' 
#' @export
hc_theme_gridlight <- function(...){
  
  theme <-  
  list(
    colors = c("#7cb5ec", "#f7a35c", "#90ee7e", "#7798BF", "#aaeeee", "#ff0066", "#eeaaee",
             "#55BF3B", "#DF5353", "#7798BF", "#aaeeee"),
    chart = list(
      backgroundColor = NULL,
      style = list(
        fontFamily = "Dosis, sans-serif"
      )
    ),
    title = list(
      style = list(
        fontSize = '16px',
        fontWeight = 'bold',
        textTransform = 'uppercase'
      )
    ),
    tooltip = list(
      borderWidth = 0,
      backgroundColor = 'rgba(219,219,216,0.8)',
      shadow = FALSE
    ),
    legend = list(
      itemStyle = list(
        fontWeight = 'bold',
        fontSize = '13px'
      )
    ),
    xAxis = list(
      gridLineWidth = 1,
      labels = list(
        style = list(
          fontSize = '12px'
        )
      )
    ),
    yAxis = list(
      minorTickInterval = 'auto',
      title = list(
        style = list(
          textTransform = 'uppercase'
        )
      ),
      labels = list(
        style = list(
          fontSize = '12px'
        )
      )
    ),
    plotOptions = list(
      candlestick = list(
        lineColor = '#404048'
      )
    ),
  
    background2 = '#F0F0EA'
    
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
