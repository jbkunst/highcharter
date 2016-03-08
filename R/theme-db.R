#' Dotabuff theme for highcharts
#' 
#' Dotabuff theme for highcharts
#' 
#' @param ... Named argument to modify the theme
#' 
#' @examples 
#' 
#' hc_demo() %>% 
#'   hc_add_theme(hc_theme_db())
#' 
#' @export
hc_theme_db <- function(...){
  
  theme <- 
  list(  
    colors = c("#FFFFFF", "#A9CF54", "#C23C2A", "#979797", "#FBB829"),
    chart = list(  
      backgroundColor = "#242F39"
    ),
    legend = list(  
      enabled = TRUE,
      align = "right",
      verticalAlign = "bottom",
      itemStyle = list(  
        color = "#C0C0C0"
      ),
      itemHoverStyle = list(  
        color = "#C0C0C0"
      ),
      itemHiddenStyle = list(  
        color = "#444444"
      )
    ),
    title = list(  
      text = NULL,
      style = list(  
        color = "#FFFFFF"
      )
    ),
    tooltip = list(  
      backgroundColor = "#1C242D",
      borderColor = "#1C242D",
      borderWidth = 1,
      borderRadius = 0,
      style = list(  
        color = "#FFFFFF"
      )
    ),
    subtitle = list(  
      style = list(  
        color = "#666666"
      )
    ),
    xAxis = list(  
      gridLineColor = "#2E3740",
      gridLineWidth = 1,
      labels = list(  
        style = list(  
          color = "#525252"
        )
      ),
      lineColor = "#2E3740",
      tickColor = "#2E3740",
      title = list(  
        style = list(  
          color = "#FFFFFF"
        ),
      text = NULL
      )
    ),
    yAxis = list(  
      gridLineColor = "#2E3740",
      gridLineWidth = 1,
      labels = list(  
        style = list(  
          color = "#525252"
        )
      ),
      lineColor = "#2E3740",
      tickColor = "#2E3740",
      title = list(  
        style = list(  
          color = "#FFFFFF"
        ),
        text = NULL
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

