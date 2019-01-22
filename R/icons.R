#' Helpers functions to get FontAwesome icons code
#' @param hc A `highchart` `htmlwidget` object. 
#' @examples 
#' 
#' dcars <- data.frame(x = runif(10), y = runif(10))
#' dtrck <- data.frame(x = rexp(10), y = rexp(10))
#' 
#' highchart() %>%
#'   hc_chart(zoomType = "xy") %>% 
#'   hc_tooltip(
#'     useHTML = TRUE,
#'     pointFormat = paste0("<span style=\"color:{series.color};\">{series.options.icon}</span>",
#'                          "{series.name}: <b>[{point.x}, {point.y}]</b><br/>")
#'                          ) %>% 
#'   hc_add_series(dcars, "scatter", marker = list(symbol = fa_icon_mark("car")),
#'                 icon = fa_icon("car"), name = "car") %>% 
#'   hc_add_series(dtrck, "scatter", marker = list(symbol = fa_icon_mark("plane")),
#'                 icon = fa_icon("plane"), name = "plane") %>% 
#'   hc_add_dependency_fa()
#' 
#' @export
hc_add_dependency_fa <- function(hc) {

  dep <- htmlDependency(
    name = "font-awesome",
    version = "0.0.0",
    src = c(file = system.file("www/shared/font-awesome", package = "shiny")),
    stylesheet = "css/font-awesome.min.css"
  )
  
  hc$dependencies <- c(hc$dependencies, list(dep))
  
  hc
  
}

#' @rdname hc_add_dependency_fa
#' @param iconname The icon's name
#' @examples
#' fa_icon("car")
#' @export
fa_icon <- function(iconname = "circle") {
  
  # faicos <- readRDS(system.file("extdata/faicos.rds", package = "highcharter"))
  # stopifnot(iconname %in% faicos$name)
  
  sprintf("<i class=\"fa fa-%s\"></i>", iconname)
}

#' @rdname hc_add_dependency_fa
#' @examples
#' fa_icon_mark("car")
#' fa_icon_mark(iconname = c("car", "plane", "car"))
#' @export
fa_icon_mark <- function(iconname = "circle"){
  
  faicos <- readRDS(system.file("extdata/faicos.rds", package = "highcharter"))
  # stopifnot(all(iconname %in% faicos$name))
  
  idx <- purrr::map_int(iconname, function(icn) which(faicos$name %in% icn))
  
  cod <- faicos$code[idx]
  
  # this is for the plugin: need the text:code to parse
  paste0("text:", cod)
  
}



