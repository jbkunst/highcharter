#' Flatdark theme for highcharts
#' 
#' Base16 inspired theme \url{https://github.com/chriskempson/base16} and
#' \url{https://github.com/cttobin/ggthemr#flat}
#' 
#' @param ... Named argument to modify the theme
#' 
#' @examples 
#' 
#' highcharts_demo() %>% 
#'   hc_add_theme(hc_theme_flatdark())
#' 
#' @export
hc_theme_flatdark <- function(...){
  
  theme <- hc_theme_flat(
    chart = list(
      backgroundColor = "#34495e"
      ),
    xAxis = list(
      gridLineColor = "#46627f",
      tickColor = "#46627f",
      lineColor = "#46627f",
      title = list(  
        style = list(  
          color = "#FFFFFF"
          )
        )
      ),
    yAxis = list(
      gridLineColor = "#46627f",
      tickColor = "#46627f",
      title = list(
        style = list(  
          color = "#FFFFFF"
          )
        )
      ),
    title = list(
      style = list(  
        color = "#FFFFFF"
        )
      ),
    subtitle = list(
      style = list(  
        color = "#666666"
        )
      ),
    legend = list(
      itemStyle = list(  
        color = "#C0C0C0"
        ),
      itemHoverStyle = list(  
        color = "#C0C0C0"
      ),
      itemHiddenStyle = list(  
        color = "#444444"
        )
      )
    )
  
  if (length(list(...)) > 0) {
    theme <- hc_theme_merge(
      theme,
      hc_theme(...)
    )
  } 
  
  theme
  
}
