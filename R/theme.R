#' Highchart theme constructor
#' 
#' Function to create highcharts themes.
#' 
#' @param ... A named list with the parameters.
#' 
#' @examples 
#' 
#' require("dplyr")
#' 
#' hc <- highchart(debug = TRUE) %>% 
#'   hc_add_serie_scatter(mtcars$wt, mtcars$mpg, color = mtcars$cyl) %>% 
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
#' @export
hc_add_theme <- function(hc, hc_thm){
  
  assert_that(.is_highchart(hc),
              .is_hc_theme(hc_thm))
  
  hc$x$fonts <- unique(c(hc$x$fonts, .hc_get_fonts(hc_thm)))
  
  hc$x$theme <- hc_thm
  
  hc
  
}

#' Merge themes
#' 
#' Function to combine hc_theme objects.
#' 
#' @param ... A \code{hc_theme} objects.
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
