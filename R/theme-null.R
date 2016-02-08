#' Null theme for highcharts
#' 
#' Null theme for highcharts. Axis are removed (\code{visible = FALSE}).
#' 
#' @examples
#' 
#' hc_demo() %>% 
#'   hc_add_theme(hc_theme_null())
#'   
#' @export
hc_theme_null <- function(){
  
  theme <-   
  list(
    chart = list(
      backgroundColor = "transparent"
    ),
    plotOptions = list(
      line = list(
        marker = list(
          enabled = FALSE
        )
      )
    ),
    legend = list(
      enabled = FALSE
      ),
    credits = list(
      enabled = FALSE
    ),
    xAxis = list(
      visible = FALSE
      ),
    yAxis = list(
      visible = FALSE
    )
  )
  
  theme <- structure(theme, class = "hc_theme")
  
  theme
  
}
