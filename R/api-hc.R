#' @importFrom rlist list.merge
.hc_opt <- function(hc, name, ...) {
  
  assertthat::assert_that(.is_highchart(hc))
  
  if (is.null(hc$x$hc_opts[[name]])) {
    
    hc$x$hc_opts[[name]] <- list(...)
    
  } else {
    
    hc$x$hc_opts[[name]] <- list.merge(hc$x$hc_opts[[name]], list(...))
    
  }
  
  # adding fonts
  hc$x$fonts <- unique(c(hc$x$fonts, .hc_get_fonts(hc$x$hc_opts)))
  
  hc
}

#' Adding chart options to highchart objects
#' 
#' Options regarding the chart area and plot area as well as general chart options. 
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param ... Arguments defined in \url{http://api.highcharts.com/highcharts#chart}. 
#' 
#' @examples 
#' 
#' data(citytemp)
#' 
#' hc <- highchart() %>% 
#'   hc_xAxis(categories = citytemp$month) %>% 
#'   hc_add_series(name = "Tokyo", data = citytemp$tokyo) %>% 
#'   hc_add_series(name = "London", data = citytemp$london)
#' 
#' hc %>% 
#'   hc_chart(type = "column",
#'            options3d = list(enabled = TRUE, beta = 15, alpha = 15))
#' 
#' 
#' hc %>% 
#'   hc_chart(borderColor = '#EBBA95',
#'            borderRadius = 10,
#'            borderWidth = 2,
#'            backgroundColor = list(
#'              linearGradient = c(0, 0, 500, 500),
#'              stops = list(
#'                list(0, 'rgb(255, 255, 255)'),
#'                list(1, 'rgb(200, 200, 255)')
#'              )))
#' 
#' @export
hc_chart <- function(hc, ...) {
  
  .hc_opt(hc, "chart", ...)
  
}

#' Adding axis options to highchart objects
#'
#' Change axis labels or style. Add lines or band to charts.
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param ... Arguments defined in \url{http://api.highcharts.com/highcharts#xAxis}. 
#' 
#' @examples 
#' 
#' highchart() %>% 
#'   hc_add_series(data = c(7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2,
#'                         26.5, 23.3, 18.3, 13.9, 9.6),
#'                         type = "spline") %>% 
#'   hc_xAxis(title = list(text = "x Axis at top"),
#'          opposite = TRUE,
#'          plotLines = list(
#'            list(label = list(text = "This is a plotLine"),
#'                 color = "#'FF0000",
#'                 width = 2,
#'                 value = 5.5))) %>% 
#'   hc_yAxis(title = list(text = "y Axis at right"),
#'            opposite = TRUE,
#'            minorTickInterval = "auto",
#'            minorGridLineDashStyle = "LongDashDotDot",
#'            showFirstLabel = FALSE,
#'            showLastLabel = FALSE,
#'            plotBands = list(
#'              list(from = 25, to = 80, color = "rgba(100, 0, 0, 0.1)",
#'                   label = list(text = "This is a plotBand")))) 
#'                   
#' @export
hc_xAxis  <- function(hc, ...) {
  
  .hc_opt(hc, "xAxis", ...)
  
}

#' @rdname hc_xAxis
#' @export
hc_yAxis  <- function(hc, ...) {
  
  .hc_opt(hc, "yAxis", ...)
  
}

#' Adding title and subtitle options to highchart objects
#'
#' Function to add and change title and subtitle'a style.
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param ... Arguments are defined in \url{http://api.highcharts.com/highcharts#title}. 
#'
#' @examples 
#' 
#' highchart() %>% 
#'   hc_add_series(data = c(7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2,
#'                         26.5, 23.3, 18.3, 13.9, 9.6),
#'                         type = "column") %>% 
#'   hc_title(text = "This is a title with <i>margin</i> and <b>Strong or bold text</b>",
#'            margin = 20, align = "left",
#'            style = list(color = "#90ed7d", useHTML = TRUE)) %>%
#'   hc_subtitle(text = "And this is a subtitle with more information",
#'               align = "left", style = list(color = "#2b908f", fontWeight = "bold")) 
#'
#' @export
hc_title <- function(hc, ...) {
  
  .hc_opt(hc, "title", ...)
  
}

#' @rdname hc_title
#' @export
hc_subtitle <- function(hc, ...) {
  
  .hc_opt(hc, "subtitle", ...)
  
}

#' Adding legend options to highchart objects
#'
#' Function to modify styles for the box containing the symbol, name and color for
#' each item or point item in the chart.
#' 
#' @examples 
#' 
#' 
#' data(citytemp)
#' 
#' highchart() %>% 
#'   hc_xAxis(categories = citytemp$month) %>% 
#'   hc_add_series(name = "Tokyo", data = citytemp$tokyo) %>% 
#'   hc_add_series(name = "London", data = citytemp$london) %>%
#'   hc_legend(align = "left", verticalAlign = "top",
#'             layout = "vertical", x = 0, y = 100) 
#'             
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param ... Arguments are defined in \url{http://api.highcharts.com/highcharts#legend}. 
#'
#' @export
hc_legend <- function(hc, ...) {
  
  .hc_opt(hc, "legend", ...)
  
}

#' Adding tooltip options to highchart objects
#'
#' Options for the tooltip that appears when the user hovers over a series or point.
#' 
#' @examples 
#' 
#' 
#' data(citytemp)
#' 
#' highchart() %>% 
#'   hc_xAxis(categories = citytemp$month) %>% 
#'   hc_add_series(name = "Tokyo", data = citytemp$tokyo) %>% 
#'   hc_add_series(name = "London", data = citytemp$london) %>% 
#'   hc_tooltip(crosshairs = TRUE, backgroundColor = "gray",
#'              headerFormat = "This is a custom header<br>",
#'              shared = TRUE, borderWidth = 5)
#'              
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param ... Arguments are defined in \url{http://api.highcharts.com/highcharts#tooltip}. 
#'
#' @export
hc_tooltip <- function(hc, ...) {
  
  .hc_opt(hc, "tooltip", ...)
  
}

#' Adding plot options to highchart objects
#'
#' The plotOptions is a wrapper object for config objects for each series type. The config 
#' objects for each series can also be overridden for each series item as given in the series array.
#' 
#' Configuration options for the series are given in three levels. Options for all series in a 
#' chart are given with the \code{hc_plotOptions} function. Then options for all series of a specific
#' type are given in the plotOptions of that type, for example  \code{hc_plotOptions(line = list(...))}.
#' Next, options for one single series are given in the series array.
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param ... Arguments are defined in \url{http://api.highcharts.com/highcharts#plotOptions}.
#' 
#' @examples 
#' 
#' 
#' data(citytemp)
#' 
#' hc <- highchart() %>% 
#'   hc_plotOptions(line = list(color = "blue",
#'                              marker = list(
#'                                fillColor = "white",
#'                                lineWidth = 2,
#'                                lineColor = NULL
#'                                )
#'   )) %>%  
#'   hc_add_series(name = "Tokyo", data = citytemp$tokyo) %>% 
#'   hc_add_series(name = "London", data = citytemp$london,
#'                marker = list(fillColor = "black"))
#' 
#' 
#' hc
#' 
#' # override the `blue` option with the explicit parameter
#' hc %>% 
#'   hc_add_series(name = "London",
#'                data = citytemp$new_york,
#'                color = "red")
#'
#' @export
hc_plotOptions  <- function(hc, ...) {
  
  .hc_opt(hc, "plotOptions", ...)
  
}

#' Adding credits options to highchart objects
#'
#' \code{highcarter} by default don't put credits in the chart.
#' You can add credits using these options.
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param ... Arguments defined in \url{http://api.highcharts.com/highcharts#credits}. 
#' 
#' @examples 
#' 
#' 
#' data("citytemp")
#' 
#' highchart() %>% 
#'   hc_xAxis(categories = citytemp$month) %>% 
#'   hc_add_series(name = "Tokyo", data = citytemp$tokyo, type = "bar") %>% 
#'   hc_credits(enabled = TRUE, text = "htmlwidgets.org",
#'              href = "http://www.htmlwidgets.org/")
#'              
#' @export
hc_credits <- function(hc, ...) {
  
  .hc_opt(hc, "credits", ...)
  
}

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

#' Exporting options for higcharts objects
#'
#' Exporting options for higcharts objects. You can define the file's name
#' or the output format.
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param ... Arguments defined in \url{http://api.highcharts.com/highcharts#exporting}. 
#' 
#' @examples
#' 
#' require("dplyr")
#' 
#' data("citytemp")
#' 
#' highchart() %>% 
#'   hc_xAxis(categories = citytemp$month) %>% 
#'   hc_add_series(name = "Tokyo", data = citytemp$tokyo) %>% 
#'   hc_add_series(name = "London", data = citytemp$london) %>% 
#'   hc_exporting(enabled = TRUE,
#'                filename = "custom-file-name")
#' 
#' @export
hc_exporting  <- function(hc, ...) {
  
  .hc_opt(hc, "exporting", ...)
  
}

#' Adding and removing series from highchart objects
#'
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param ... Arguments defined in \url{http://api.highcharts.com/highcharts#chart}. 
#'
#' @examples
#' 
#' require("dplyr")
#' 
#' data("citytemp")
#' 
#' hc <- highchart() %>% 
#'   hc_xAxis(categories = citytemp$month) %>% 
#'   hc_add_series(name = "Tokyo", data = citytemp$tokyo) %>% 
#'   hc_add_series(name = "New York", data = citytemp$new_york) 
#' 
#' hc 
#' 
#' hc %>% 
#'   hc_add_series(name = "London", data = citytemp$london, type = "area") %>% 
#'   hc_rm_series(name = "New York")
#'
#' @export
hc_add_series <- function(hc, ...) {
  
  hc$x$hc_opts$series <- append(hc$x$hc_opts$series, list(list(...)))
  
  hc
  
}

#' @rdname hc_add_series
#' @export
hc_add_serie <- hc_add_series

#' Removing series to highchart objects
#'
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param name The serie's name to delete.
#' 
#' @export
hc_rm_series <- function(hc, name = NULL) {
  
  stopifnot(!is.null(name))
  
  positions <- hc$x$hc_opts$series %>%
    map("name") %>%
    unlist()
  
  position <- which(positions == name)
  
  hc$x$hc_opts$series[position] <- NULL
  
  hc
  
}

#' @rdname hc_rm_series
#' @export
hc_rm_serie <- hc_rm_series

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

#' Adding mapNavigation options to highstock charts
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



