#' Hand Drawn theme for highcharts
#' 
#' Hand Drawn theme for highcharts. Inspirated by https://www.amcharts.com/inspiration/hand-drawn/
#' 
#' @examples
#' 
#' highchart() %>% 
#'   hc_add_series(data = c(7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2,
#'                         26.5, 23.3, 18.3, 13.9, 9.6),
#'                         type = "column", color = "black") %>% 
#'   hc_add_theme(hc_theme_handdrawn())
#' 
#' @export
hc_theme_handdrawn <- function(){
  
  cols <- colorRampPalette(c("#171314", "#888782"))(4)
  
  theme <-   
  list(
    colors = cols,
    chart = list(
      divBackgroundImage = "https://www.amcharts.com/inspiration/hand-drawn/bg.jpg",
      backgroundColor = "transparent",
      style = list(
        fontFamily = "Berkshire Swash",
        color = "#000000"
      )
    ),
    plotOptions = list(
      scatter = list(
        marker = list(
          radius = 10
          
        )
        
      )
    ),
    title = list(
      style = list(
        fontSize = "30px",
        color = "#000000"
      )
    ),
    subtitle = list(
      style = list(
        fontSize = "20px",
        color = "#000000"
      )
    ),
    legend = list(
      enabled = TRUE,
      itemStyle = list(
        fontSize = "20px",
        color = "#000000"
      )
      
    ),
    credits = list(
      enabled = FALSE
      
    ),
    xAxis = list(
      lineColor = "#000000",
      tickColor = "#000000",
      lineWidth = 1,
      tickWidth = 1,
      gridLineColor = "transparent",
      labels = list(
        enabled = TRUE,
        style = list(
          color = "#000000",
          fontSize = "20px"
        )
      ),
      title = list(
        enabled = TRUE,
        style = list(
          color = "#000000",
          fontSize = "20px"
          
        )
      )
    ),
    yAxis = list(
      lineColor = "#000000",
      tickColor = "#000000",
      lineWidth = 1,
      tickWidth = 1,
      gridLineColor = "transparent",
      labels = list(
        enabled = TRUE,
        style = list(
          color = "#000000",
          fontSize = "20px"
        )
      ),
      title = list(
        enabled = TRUE,
        style = list(
          color = "#000000",
          fontSize = "20px"
          
        )
      )
    ),
    tooltip = list(
      backgroundColor = "#C9C8C3",
      style = list(
        color = "#000000",
        fontSize = "20px",
        padding = "10px"
        
      )
      
    )
  )
  
  theme <- structure(theme, class = "hc_theme")
  
  theme
  
}
