#' Chalk theme for highcharts
#' 
#' Chalk theme for highcharts. Inspirated by https://www.amcharts.com/inspiration/chalk/
#' 
#' @examples
#' 
#' highchart() %>% 
#'   hc_add_series(data = c(7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2,
#'                         26.5, 23.3, 18.3, 13.9, 9.6),
#'                         type = "column") %>% 
#'   hc_add_theme(hc_theme_chalk())
#' 
#' @export
hc_theme_chalk <- function(){
  
  theme <-   
  list(
    colors = c("#FAFAFA", "#DEDEDE","#FFFFFF"),
    chart = list(
      divBackgroundImage = 'https://www.amcharts.com/inspiration/chalk/bg.jpg',
      backgroundColor = "transparent",
      style = list(
        fontFamily = "Shadows Into Light",
        color = "#FFFFFF"
      )
    ),
    plotOptions = list(
      line = list(
        marker = list(
          enabled = FALSE
          
        )
        
      )
    ),
    title = list(
      style = list(
        fontSize = "30px",
        color = "#FFFFFF"
      )
    ),
    subtitle = list(
      style = list(
        fontSize = "20px",
        color = "#FFFFFF"
      )
    ),
    legend = list(
      enabled = TRUE,
      itemStyle = list(
        fontSize = "30px",
        color = "#FFFFFF"
      )
      
    ),
    credits = list(
      enabled = FALSE
      
    ),
    xAxis = list(
      lineWidth = 1,
      tickWidth = 1,
      gridLineColor = "transparent",
      labels = list(
        enabled = TRUE,
        style = list(
          color = "#FFFFFF",
          fontSize = "17px"
        )
      ),
      title = list(
        enabled = TRUE,
        style = list(
          color = "#FFFFFF",
          fontSize = "0px"
          
        )
      )
    ),
    yAxis = list(
      lineWidth = 1,
      tickWidth = 1,
      gridLineColor = "transparent",
      labels = list(
        enabled = TRUE,
        style = list(
          color = "#FFFFFF",
          fontSize = "20px"
        )
      ),
      title = list(
        enabled = TRUE,
        style = list(
          color = "#FFFFFF",
          fontSize = "20px"
          
        )
      )
    ),
    tooltip = list(
      backgroundColor = "#333333",
      style = list(
        color = "#FFFFFF",
        fontSize = "20px",
        padding = "10px"
        
      )
      
    )
  )
  
  theme <- structure(theme, class = "hc_theme")
  
  theme
  
}
