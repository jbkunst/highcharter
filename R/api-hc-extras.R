#' Adding Color Axis options to highchart objects
#'
#' Function to set the axis color to highcharts objects.
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param ... Arguments are defined in \url{http://api.highcharts.com/highmaps#colorAxis}. 
#' 
#' @examples 
#' 
#' 
#' nyears <- 5
#' 
#' df <- expand.grid(seq(12) - 1, seq(nyears) - 1)
#' df$value <- abs(seq(nrow(df)) + 10 * rnorm(nrow(df))) + 10
#' df$value <- round(df$value, 2)
#' ds <- list.parse2(df)
#' 
#' 
#' hc <- highchart() %>% 
#'   hc_chart(type = "heatmap") %>% 
#'   hc_title(text = "Simulated values by years and months") %>% 
#'   hc_xAxis(categories = month.abb) %>% 
#'   hc_yAxis(categories = 2016 - nyears + seq(nyears)) %>% 
#'   hc_add_series(name = "value", data = ds)
#' 
#' hc_colorAxis(hc, minColor = "#FFFFFF", maxColor = "#434348")
#' 
#' hc_colorAxis(hc, minColor = "#FFFFFF", maxColor = "#434348",
#'              type = "logarithmic") 
#' 
#' 
#' require("viridisLite")
#' 
#' n <- 4
#' stops <- data.frame(q = 0:n/n,
#'                     c = substring(viridis(n + 1), 0, 7),
#'                     stringsAsFactors = FALSE)
#' stops <- list.parse2(stops)
#' 
#' hc_colorAxis(hc, stops = stops, max = 75) 
#' 
#' @export
hc_colorAxis  <- function(hc, ...) {
  
  .hc_opt(hc, "colorAxis", ...)
  
}

#' Drilldown options for higcharts objects
#'
#' Options for drill down, the concept of inspecting increasingly high 
#' resolution data through clicking on chart items like columns or pie slices.
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param ... Arguments defined in \url{http://api.highcharts.com/highcharts#drilldown}. 
#' 
#' @examples 
#' 
#' library("dplyr")
#' library("purrr")
#' 
#' df <- data_frame(
#'   name = c("Animals", "Fruits", "Cars"),
#'   y = c(5, 2, 4),
#'   drilldown = tolower(name)
#' )
#' 
#' df
#' 
#' ds <- list.parse3(df)
#' names(ds) <- NULL
#' str(ds)
#' 
#' hc <- highchart() %>% 
#'   hc_chart(type = "column") %>% 
#'   hc_title(text = "Basic drilldown") %>% 
#'   hc_xAxis(type = "category") %>% 
#'   hc_legend(enabled = FALSE) %>% 
#'   hc_plotOptions(
#'     series = list(
#'       boderWidth = 0,
#'       dataLabels = list(enabled = TRUE)
#'     )
#'   ) %>% 
#'   hc_add_series(
#'     name = "Things",
#'     colorByPoint = TRUE,
#'     data = ds
#'   )
#' 
#' dfan <- data_frame(
#'   name = c("Cats", "Dogs", "Cows", "Sheep", "Pigs"),
#'   value = c(4, 3, 1, 2, 1)
#' )
#' 
#' dffru <- data_frame(
#'   name = c("Apple", "Organes"),
#'   value = c(4, 2)
#' )
#' 
#' dfcar <- data_frame(
#'   name = c("Toyota", "Opel", "Volkswage"),
#'   value = c(4, 2, 2) 
#' )
#' 
#' second_el_to_numeric <- function(ls){
#'   
#'   map(ls, function(x){
#'     x[[2]] <- as.numeric(x[[2]])
#'     x
#'   })
#'   
#' }
#' 
#' dsan <- second_el_to_numeric(list.parse2(dfan))
#' 
#' dsfru <- second_el_to_numeric(list.parse2(dffru))
#' 
#' dscar <- second_el_to_numeric(list.parse2(dfcar))
#' 
#' 
#' hc <- hc %>% 
#'   hc_drilldown(
#'     allowPointDrilldown = TRUE,
#'     series = list(
#'       list(
#'         id = "animals",
#'         data = dsan
#'       ),
#'       list(
#'         id = "fruits",
#'         data = dsfru
#'       ),
#'       list(
#'         id = "cars",
#'         data = dscar
#'       )
#'     )
#'   )
#' 
#' hc
#' 
#' @export
hc_drilldown <- function(hc, ...) {
  
  .hc_opt(hc, "drilldown", ...)
  
}

#' Adding scrollbar options to highstock objects
#' 
#' Options regarding the scrollbar which is a means of panning 
#' over the X axis of a chart.
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param ... Arguments defined in \url{http://api.highcharts.com/highstock#scrollbar}. 
#' 
#' @export
hc_scrollbar  <- function(hc, ...) {
  
  .hc_opt(hc, "scrollbar", ...)
  
}

#' Adding navigator options to highstock charts
#' 
#' Options regarding the navigator: The miniseries below chart 
#' in a highstock chart.
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param ... Arguments defined in \url{http://api.highcharts.com/highstock#navigator}. 
#' 
#' @export
hc_navigator <- function(hc, ...) {
  
  .hc_opt(hc, "navigator", ...)
  
}

#' Adding scrollbar options to highstock charts
#' 
#' Options to edit the range selector which is The range selector is a tool 
#' for selecting ranges to display within the chart. It provides buttons 
#' to select preconfigured ranges in the chart, like 1 day, 1 week, 1 month 
#' etc. It also provides input boxes where min and max dates can be manually
#' input.
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param ... Arguments defined in \url{http://api.highcharts.com/highstock#rangeSelector}. 
#' 
#' @export
hc_rangeSelector <- function(hc, ...) {
  
  .hc_opt(hc, "rangeSelector", ...)
  
}

#' Adding mapNavigation options to highmaps charts
#' 
#' Options regarding the mapNavigation: A collection of options for zooming 
#' and panning in a map.
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param ... Arguments defined in \url{http://api.highcharts.com/highmaps#mapNavigation}. 
#' 
#' @export
hc_mapNavigation <- function(hc, ...) {
  
  .hc_opt(hc, "mapNavigation", ...)
  
}

#' Adding patterns to be used in highcharts series
#' 
#' Helper function to use the fill patter plugin http://www.highcharts.com/plugin-registry/single/9/Pattern-Fill.
#' 
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param ... Arguments defined in \url{http://www.highcharts.com/plugin-registry/single/9/Pattern-Fill}. 
#' 
#' @export
hc_defs <- function(hc, ...) {
  
  .hc_opt(hc, "defs", ...)
  
}

#' Adding annotations to highcharts objects
#' 
#' Helper function to add annotations to highcharts library.
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param ... Arguments defined in \url{http://www.highcharts.com/plugin-registry/single/17/Annotations}. 
#' 
#' @export
hc_annotations <- function(hc, ...) {
  
  .hc_opt(hc, "annotations", ...)
  
}


#' Adding annotations to highcharts objects
#' 
#' Applies only to polar charts and angular gauges. This configuration object
#' holds general options for the combined X and Y axes set. Each xAxis or
#' yAxis can reference the pane by index.
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param ... Arguments defined in \url{http://api.highcharts.com/highcharts#pane}. 
#' 
#' @export
hc_pane <- function(hc, ...) {
  
  .hc_opt(hc, "pane", ...)
  
}
