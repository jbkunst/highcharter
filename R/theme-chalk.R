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
        
      ),
      gridLineColor = "transparent"
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
