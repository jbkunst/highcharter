#' Add modules or plugin dependencies to highcharts objects
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param name The partial path to the plugin or module,
#'   example: \code{""plugins/annotations.js""}
#' @examples 
#' 
#' highchart() %>% 
#'  hc_title(text = "I'm a pirate looking chart") %>% 
#'  hc_xAxis(categories = month.abb) %>% 
#'  hc_defs(
#'    patterns = list(
#'      list(
#'        id = "custom-pattern",
#'        path = list(d = "M 0 0 L 10 10 M 9 -1 L 11 1 M -1 9 L 1 11",
#'                  stroke = "black", strokeWidth = 1
#'        )
#'      )
#'    )
#'  ) %>% 
#'  hc_add_series(data = 10 * dt(1 + 1:12 - mean(1:12), df = 2),
#'                type = "area",
#'                fillColor = "url(#custom-pattern)") %>% 
#'  hc_add_theme(hc_theme_handdrawn()) %>% 
#'  hc_add_dependency(name = "plugins/pattern-fill-v2.js")
#' 
#' @importFrom purrr map_chr
#' @importFrom htmltools htmlDependency
#' @importFrom yaml yaml.load_file
#' @export
hc_add_dependency <- function(hc, name = "plugins/annotations.js") {
  
  stopifnot(!is.null(name))
  
  yml <- system.file("htmlwidgets/highchart.yaml", package = "highcharter")
  yml <- yaml.load_file(yml)[[1]]
  
  hc_ver <- map_chr(yml, c("version"))[map_chr(yml, c("name")) == "highcharts"]
  
  dep <- htmlDependency(
    name = basename(name),
    version = hc_ver,
    src = c(file = system.file(
      sprintf("htmlwidgets/lib/highcharts-%s/%s", hc_ver, dirname(name)),
      package = "highcharter")
    ),
    script = basename(name)
  )
  
  hc$dependencies <- c(hc$dependencies, list(dep))
  
  hc
  
}

#' Helpers functions to get FontAwesome icons code
#' @param hc A \code{highchart} \code{htmlwidget} object. 
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



