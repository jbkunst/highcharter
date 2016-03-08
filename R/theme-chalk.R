#' Chalk theme for highcharts
#' 
#' Chalk theme for highcharts. Inspirated by https://www.amcharts.com/inspiration/chalk/
#' 
#' @param ... Named argument to modify the theme
#' 
#' @examples
#' 
#' hc_demo() %>% 
#'   hc_add_theme(hc_theme_chalk())
#' 
#' @importFrom grDevices colorRampPalette 
#' @export
hc_theme_chalk <- function(...){
  
  cols <- colorRampPalette(c("#FFFFFF", "#8C8984"))(4)
  
  theme <-   
  list(
    colors = cols,
    chart = list(
      divBackgroundImage = "https://www.amcharts.com/inspiration/chalk/bg.jpg",
      backgroundColor = "transparent",
      style = list(
        fontFamily = "Shadows Into Light",
        color = "#FFFFFF"
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
        fontSize = "20px",
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
  
  if (length(list(...)) > 0) {
    theme <- hc_theme_merge(
      theme,
      hc_theme(...)
    )
  } 
  
  theme
  
}
