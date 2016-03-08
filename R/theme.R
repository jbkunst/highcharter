#' Highchart theme constructor
#' 
#' Function to create highcharts themes.
#' 
#' More examples are in http://www.highcharts.com/docs/chart-design-and-style/themes.
#' 
#' @param ... A named parameters.
#' 
#' @examples 
#' 
#' hc <- highchart(debug = TRUE) %>% 
#'   hc_add_series_scatter(mtcars$wt, mtcars$mpg, color = mtcars$cyl) %>% 
#'   hc_chart(zoomType = "xy") %>% 
#'   hc_title(text = "Motor Trend Car Road Tests") %>% 
#'   hc_subtitle(text = "Motor Trend Car Road Tests") %>% 
#'   hc_xAxis(title = list(text = "Weight")) %>% 
#'   hc_yAxis(title = list(text = "Miles/gallon")) %>% 
#'   hc_tooltip(headerFormat = "<b>{series.name} cylinders</b><br>",
#'              pointFormat = "{point.x} (lb/1000), {point.y} (miles/gallon)")
#' 
#' hc
#' 
#' thm <- hc_theme(
#'  colors = c('red', 'green', 'blue'),
#'  chart = list(
#'  backgroundColor = "#15C0DE"
#'  ),
#'  title = list(
#'    style = list(
#'      color = '#333333',
#'      fontFamily = "Erica One"
#'    )
#'  ),
#'  subtitle = list(
#'    style = list(
#'      color = '#666666',
#'      fontFamily = "Shadows Into Light"
#'    )
#'  ),
#'  legend = list(
#'    itemStyle = list(
#'      fontFamily = 'Tangerine',
#'      color = 'black'
#'    ),
#'    itemHoverStyle = list(
#'      color = 'gray'
#'    )   
#'   )
#' )
#' 
#' hc %>% hc_add_theme(thm)
#' 
#' @export
hc_theme <- function(...){
  
  structure(list(...), class = "hc_theme")
  
}

#' Add themes to a highchart object
#' 
#' Add highcharts themes to a highchart object.
#' 
#' @param hc A highchart object
#' @param hc_thm A highchart theme object (\code{"hc_theme"} class)
#' 
#' @examples 
#' 
#' highchart() %>% 
#'   hc_add_series(data = c(7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2,
#'                         26.5, 23.3, 18.3, 13.9, 9.6),
#'                         type = "column") %>% 
#'   hc_add_theme(hc_theme_sandsignika())
#'   
#' @export
hc_add_theme <- function(hc, hc_thm){
  
  assert_that(.is_highchart(hc), .is_hc_theme(hc_thm))
  
  hc$x$fonts <- unique(c(hc$x$fonts, .hc_get_fonts(hc_thm)))
  
  hc$x$theme <- hc_thm
  
  hc
  
}

#' Merge themes
#' 
#' Function to combine hc_theme objects.
#' 
#' @param ... \code{hc_theme} objects.
#' 
#' @examples 
#' 
#' thm <- hc_theme_merge(
#'   hc_theme_darkunica(),
#'   hc_theme(
#'     chart = list(
#'       backgroundColor = "transparent",
#'       divBackgroundImage = "http://cdn.wall-pix.net/albums/art-3Dview/00025095.jpg"
#'     ),
#'     title = list(
#'       style = list(
#'         color = 'white',
#'         fontFamily = "Erica One"
#'       )
#'     )
#'   )
#' )
#' 
#' @export
hc_theme_merge <- function(...){
  
  themes <- list(...)
  
  assert_that(unique(unlist(purrr::map(themes, class))) == "hc_theme")
  
  theme <- structure(list.merge(...), class = "hc_theme")
  
  theme
  
}

#' @importFrom stringr str_replace_all str_replace str_trim
.hc_get_fonts <- function(lst){
  
  unls <- unlist(lst)
  unls <- unls[grepl("fontFamily", names(unls))]
  
  fonts <- unls %>% 
    str_replace_all(",\\s+sans-serif|,\\s+serif", "") %>% 
    str_replace("\\s+", "+") %>% 
    str_trim() %>% 
    unlist()
  
  fonts
  
}
