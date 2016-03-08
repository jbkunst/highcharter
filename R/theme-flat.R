#' Base16 Insipred theme
#' 
#' Theme inspired by https://github.com/chriskempson/base16 and
#' https://github.com/cttobin/ggthemr#flat
#' 
#' @param ... Named argument to modify the theme
#' 
#' @examples 
#' 
#' hc_demo() %>% 
#'   hc_add_theme(hc_theme_flat())
#' 
#' @export
hc_theme_flat <- function(...){
  
  theme <-
  list(
    colors =  c('#f1c40f', '#2ecc71', '#9b59b6', '#e74c3c', 
                '#34495e', '#3498db', '#1abc9c', '#f39c12', '#d35400'),
    chart = list(
      backgroundColor = "#ECF0F1"
    ),
    xAxis = list(
      gridLineDashStyle = "Dash",
      gridLineWidth = 1,
      gridLineColor = '#BDC3C7',
      lineColor = '#BDC3C7',
      minorGridLineColor = '#BDC3C7',
      tickColor = '#BDC3C7',
      tickWidth = 1
    ),
    yAxis = list(
      gridLineDashStyle = "Dash",
      gridLineColor = '#BDC3C7',
      lineColor = '#BDC3C7',
      minorGridLineColor = '#BDC3C7',
      tickColor = '#BDC3C7',
      tickWidth = 1
    ),
    
    legendBackgroundColor = 'rgba(0, 0, 0, 0.5)',
    background2 = '#505053',
    dataLabelsColor = '#B0B0B3',
    textColor = '#34495e',
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



#' @rdname hc_theme_flat
#' 
#' @examples 
#' 
#' hc_demo() %>% 
#'   hc_add_theme(hc_theme_flatdark())
#' 
#' @export
hc_theme_flatdark <- function(...){
  
  theme <- hc_theme_flat(
    chart = list(
      backgroundColor = "#34495e"
      ),
    xAxis = list(
      gridLineColor = '#46627f',
      tickColor = '#46627f',
      lineColor = '#46627f',
      title = list(  
        style = list(  
          color = "#FFFFFF"
          )
        )
      ),
    yAxis = list(
      gridLineColor = '#46627f',
      tickColor = '#46627f',
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
