validate_args <- function(name, lstargs) {
  
  lstargsnn <- lstargs[which(names(lstargs) == "")]
  lenlst <- length(lstargsnn)
  
  if (lenlst != 0) {
    
    chrargs <- lstargsnn %>% 
      unlist() %>% 
      as.character()
    
    chrargs <- paste0("'", chrargs, "'", collapse = ", ")
    
    txt <- ifelse(lenlst == 1, " is ", "s are ")
    
    stop(chrargs, " argument", txt, "not named in ", paste0("hc_", name),
         call. = FALSE)
    
  }
  
}

#' @importFrom rlist list.merge
.hc_opt <- function(hc, name, ...) {
  
  assertthat::assert_that(is.highchart(hc))
  
  validate_args(name, eval(substitute(alist(...))))
  
  if (is.null(hc$x$hc_opts[[name]])) {
    
    hc$x$hc_opts[[name]] <- list(...)
    
  } else {
    
    hc$x$hc_opts[[name]] <- list.merge(hc$x$hc_opts[[name]], list(...))
    
  }
  
  # Setting fonts
  hc$x$fonts <- unique(c(hc$x$fonts, .hc_get_fonts(hc$x$hc_opts)))
  
  hc
}

#' Setting chart options to highchart objects
#' 
#' Options regarding the chart area and plot area as well as general chart options. 
#' @param hc A `highchart` `htmlwidget` object. 
#' @param ... Arguments defined in \url{http://api.highcharts.com/highcharts/chart}. 
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
#'   hc_chart(type = "columnn",
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

#' Setting color options to highchart objects
#' 
#' An array containing the default colors for the chart's series. When all 
#' colors are used, new colors are pulled from the start again. 
#' @param hc A `highchart` `htmlwidget` object. 
#' @param colors A vector of colors. 
#' @examples 
#' 
#' library("viridisLite")
#' 
#' cols <- viridis(3)
#' cols <- substr(cols, 0, 7)
#' 
#' highcharts_demo() %>% 
#'   hc_colors(cols)
#'
#' 
#' @export
hc_colors <- function(hc, colors) {
  
  assertthat::assert_that(is.vector(colors))
  
  if (length(colors) == 1)
    colors <- list(colors)

  hc$x$hc_opts$colors <- colors
  
  hc
  
}

#' Setting credits options to highchart objects
#' 
#' \code{highcarter} by default don't put credits in the chart.
#' You can add credits using these options.
#' @param hc A `highchart` `htmlwidget` object. 
#' @param ... Arguments defined in \url{http://api.highcharts.com/highcharts/credits}. 
#' @examples 
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

#' Setting exporting options for highcharts objects
#' 
#' Exporting options for highcharts objects. You can define the file's name
#' or the output format.
#' @param hc A `highchart` `htmlwidget` object. 
#' @param ... Arguments defined in \url{http://api.highcharts.com/highcharts/exporting}. 
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

#' Setting legend options to highchart objects
#' 
#' Function to modify styles for the box containing the symbol, name and color for
#' each item or point item in the chart.
#' @examples 
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
#' @param hc A `highchart` `htmlwidget` object. 
#' @param ... Arguments are defined in \url{http://api.highcharts.com/highcharts#legend}. 
#'
#' @export
hc_legend <- function(hc, ...) {
  
  .hc_opt(hc, "legend", ...)
  
}

#' Setting plot options to highchart objects
#' 
#' The plotOptions is a wrapper object for config objects for each series type. The configuration 
#' objects for each series can also be overridden for each series item as given in the series array.
#' 
#' Configuration options for the series are given in three levels. Options for all series in a 
#' chart are given with the \code{hc_plotOptions} function. Then options for all series of a specific
#' type are given in the plotOptions of that type, for example  \code{hc_plotOptions(line = list(...))}.
#' Next, options for one single series are given in the series array.
#' @param hc A `highchart` `htmlwidget` object. 
#' @param ... Arguments are defined in \url{http://api.highcharts.com/highcharts#plotOptions}.
#' @examples 
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

#' Setting responsive options to highchart objects
#' 
#' Allows setting a set of rules to apply for different screen or chart sizes.
#' Each rule specifies additional chart options.
#' @param hc A `highchart` `htmlwidget` object. 
#' @param ... Arguments defined in \url{http://api.highcharts.com/highcharts/responsive}. 
#' @examples 
#' 
#' leg_500_opts <- list(enabled = FALSE)
#' leg_900_opts <- list(align = "right", verticalAlign = "middle",  layout = "vertical")
#' 
#' highcharts_demo() %>% 
#'   hc_responsive(
#'     rules = list(
#'       # remove legend if there is no much space
#'       list(
#'         condition = list(maxWidth  = 500),
#'         chartOptions = list(legend = leg_500_opts)
#'       ),
#'       # put legend on the right when there is much space
#'       list(
#'         condition = list(minWidth  = 900),
#'         chartOptions = list(legend = leg_900_opts)
#'       )
#'     )
#'   )
#'              
#' @export
hc_responsive <- function(hc, ...) {
  
  .hc_opt(hc, "responsive", ...)
  
}

#' Setting series/data options from highchart objects
#' @param hc A `highchart` `htmlwidget` object. 
#' @param ... Arguments defined in \url{http://api.highcharts.com/highcharts/series}. 
#' @examples
#' 
#' highchart() %>%  
#'   hc_series(
#'     list(
#'       name = "Tokyo",
#'       data = c(7.0, 6.9, 9.5, 14.5, 18.4, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6)
#'     ),
#'     list(
#'       name = "London",
#'       data = c(3.9, 4.2, 5.7, 8.5, 11.9, 15.2, 17.0, 16.6, 14.2, 10.3, 6.6, 4.8)
#'     )
#'   )
#'
#' @export
hc_series <- function(hc, ...) {
  
  .hc_opt(hc, "series", ...)
  
}

#' Setting title and subtitle options to highchart objects
#' 
#' Function to add and change title and subtitle'a style.
#' @param hc A `highchart` `htmlwidget` object. 
#' @param ... Arguments are defined in \url{http://api.highcharts.com/highcharts#title}. 
#' @examples 
#' 
#' highchart() %>% 
#'   hc_add_series(data = c(7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2,
#'                         26.5, 23.3, 18.3, 13.9, 9.6),
#'                         type = "columnn") %>% 
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

#' Setting tooltip options to highchart objects
#' 
#' Options for the tooltip that appears when the user hovers over a series or point.
#' @examples 
#' 
#' highcharts_demo() %>%
#'   hc_tooltip(crosshairs = TRUE, borderWidth = 5, sort = TRUE, table = TRUE) 
#'              
#' @param hc A `highchart` `htmlwidget` object. 
#' @param ... Arguments are defined in \url{http://api.highcharts.com/highcharts#tooltip}. 
#' @param sort Logical value to implement sort according \code{this.point}
#'   \url{http://stackoverflow.com/a/16954666/829971}.
#' @param table Logical value to implement table in tooltip: 
#'   \url{http://stackoverflow.com/a/22327749/829971}.
#'
#' @export
hc_tooltip <- function(hc, ..., sort = FALSE, table = FALSE) {
  
  if (sort)
    hc <- .hc_tooltip_sort(hc)
  
  if (table)
    hc <- .hc_tooltip_table(hc)
  
  if (length(list(...))) 
    hc <- .hc_opt(hc, "tooltip", ...)
  
  hc  
  
}

#' Setting axis options to highchart objects
#' 
#' Change axis labels or style. Add lines or band to charts.
#' @param hc A `highchart` `htmlwidget` object. 
#' @param ... Arguments defined in \url{http://api.highcharts.com/highcharts/xAxis}. 
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
#'  highchart() %>% 
#'    hc_yAxis_multiples(
#'      list(top = "0%", height = "30%", lineWidth = 3),
#'      list(top = "30%", height = "70%", offset = 0,
#'           showFirstLabel = FALSE, showLastLabel = FALSE)
#'    ) %>% 
#'    hc_add_series(data = rnorm(10)) %>% 
#'    hc_add_series(data = rexp(10), type = "spline", yAxis = 1)
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

#' @rdname hc_xAxis
#' @export
hc_yAxis_multiples <- function(hc, ...) {
  
  # print(length(list(...)));  print(length(list(...)[[1]]));
  # print(class(list(...)));  print(class(list(...)[[1]]))
  
  if (length(list(...)) == 1 & class(list(...)[[1]]) == "hc_yaxis_list") {
    hc$x$hc_opts$yAxis <- list(...)[[1]]
  } else {
    hc$x$hc_opts$yAxis <- list(...)
  }
    
  hc
  
}

#' @rdname hc_xAxis
#' @export
hc_zAxis  <- function(hc, ...) {
  
  .hc_opt(hc, "zAxis", ...)
  
}

#' Creating multiples yAxis t use with highcharts
#' @param naxis Number of axis an integer.
#' @param heights A numeric vector. This values will be normalized.
#' @param sep A numeric value for the separation (in percentage) for the panes.
#' @param offset A numeric value (in percentage).
#' @param turnopposite A logical value to turn the side of each axis or not.
#' @param ... Arguments defined in \url{http://api.highcharts.com/highcharts/yAxis}. 
#' @examples 
#' 
#' highchart() %>% 
#'    hc_yAxis_multiples(create_yaxis(naxis = 2, heights = c(2, 1))) %>% 
#'    hc_add_series(data = c(1,3,2), yAxis = 0) %>% 
#'    hc_add_series(data = c(20, 40, 10), yAxis = 1)
#'    
#' highchart() %>% 
#'   hc_yAxis_multiples(create_yaxis(naxis = 3, lineWidth = 2, title = list(text = NULL))) %>% 
#'   hc_add_series(data = c(1,3,2)) %>% 
#'   hc_add_series(data = c(20, 40, 10), yAxis = 1) %>% 
#'   hc_add_series(data = c(200, 400, 500), type = "columnn", yAxis = 2) %>% 
#'   hc_add_series(data = c(500, 300, 400), type = "columnn", yAxis = 2)  
#'    
#' @importFrom dplyr bind_cols
#' @export
create_yaxis <- function(naxis = 2, heights = 1, sep = 0.01,
                         offset = 0, turnopposite = TRUE, ...) {
  
  pcnt <- function(x) paste0(x * 100, "%")
  
  heights <- rep(heights, length = naxis)
  
  heights <- (heights / sum(heights)) %>% 
    map(function(x) c(x, sep)) %>% 
    unlist() %>% 
    head(-1) %>%
    { . / sum(.) } %>% 
    round(5) 
  
  tops <- cumsum(c(0, head(heights, -1)))
  
  tops <- pcnt(tops)
  heights <- pcnt(heights)
  
  dfaxis <- data_frame(height = heights, top = tops, offset = offset)

  dfaxis <- dfaxis %>% dplyr::filter(seq_len(nrow(dfaxis)) %% 2 != 0)
  
  if (turnopposite) {
    ops <- rep_len(c(FALSE, TRUE), length.out = nrow(dfaxis))
    dfaxis <- dfaxis %>%
      mutate(opposite = ops)
  }

  dfaxis <- bind_cols(dfaxis, data_frame(nid = seq(naxis), ...))

  yaxis <- list_parse(dfaxis)
  
  # yaxis <- map(yaxis, function(x) c(x, ...))
  
  class(yaxis) <- "hc_yaxis_list"
  
  yaxis
  
}

#' Setting patterns to be used in highcharts series
#' 
#' Helper function to use the fill patter plugin \url{http://www.highcharts.com/plugin-registry/single/9/Pattern-Fill}.
#' @param hc A \code{highchart} \code{htmlwidget} object.
#' @param ... Arguments defined in \url{http://www.highcharts.com/plugin-registry/single/9/Pattern-Fill}.
#' @export
hc_defs <- function(hc, ...){
  
  .hc_opt(hc, "defs", ...)
  
}

#' Setting drilldown options for highcharts objects
#' 
#' Options for drill down, the concept of inspecting increasingly high
#' resolution data through clicking on chart items like columns or pie slices.
#' @param hc A \code{highchart} \code{htmlwidget} object.
#' @param ... Arguments defined in \url{http://api.highcharts.com/highcharts/drilldown}. 
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
#' ds <- list_parse(df)
#' names(ds) <- NULL
#' str(ds)
#'
#' hc <- highchart() %>%
#'   hc_chart(type = "columnn") %>%
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
#' dsan <- second_el_to_numeric(list_parse2(dfan))
#'
#' dsfru <- second_el_to_numeric(list_parse2(dffru))
#'
#' dscar <- second_el_to_numeric(list_parse2(dfcar))
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
hc_drilldown <- function(hc, ...){
  
  .hc_opt(hc, "drilldown", ...)
  
}

#' Setting panes options to highchart objects
#' 
#' Applies only to polar charts and angular gauges. This configuration object
#' holds general options for the combined X and Y axes set. Each xAxis or
#' yAxis can reference the pane by index.
#' @param hc A \code{highchart} \code{htmlwidget} object.
#' @param ... Arguments defined in \url{http://api.highcharts.com/highcharts/pane}.
#' @export
hc_pane <- function(hc, ...){
  
  .hc_opt(hc, "pane", ...)
  
}

#' Setting color Axis options to highchart objects
#' Function to set the axis color to highcharts objects.
#' @param hc A \code{highchart} \code{htmlwidget} object.
#' @param ... Arguments are defined in \url{http://api.highcharts.com/highmaps/colorAxis}.
#' @examples
#'
#' nyears <- 5
#'
#' df <- expand.grid(seq(12) - 1, seq(nyears) - 1)
#' df$value <- abs(seq(nrow(df)) + 10 * rnorm(nrow(df))) + 10
#' df$value <- round(df$value, 2)
#' ds <- list_parse2(df)
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
#' stops <- list_parse2(stops)
#'
#' hc_colorAxis(hc, stops = stops, max = 75)
#'
#' @export
hc_colorAxis  <- function(hc, ...){
  
  .hc_opt(hc, "colorAxis", ...)
  
}

#' Setting scrollbar options to highstock objects
#' 
#' Options regarding the scrollbar which is a means of panning
#' over the X axis of a chart.
#' @param hc A \code{highchart} \code{htmlwidget} object.
#' @param ... Arguments defined in \url{http://api.highcharts.com/highstock#scrollbar}.
#' @export
hc_scrollbar <- function(hc, ...){
  
  .hc_opt(hc, "scrollbar", ...)
  
}

#' Setting navigator options to highstock charts
#' Options regarding the navigator: The miniseries below chart
#' in a highstock chart.
#' @param hc A \code{highchart} \code{htmlwidget} object.
#' @param ... Arguments defined in \url{http://api.highcharts.com/highstock#navigator}.
#' @export
hc_navigator <- function(hc, ...){
  
  .hc_opt(hc, "navigator", ...)
  
}

#' Setting scrollbar options to highstock charts
#' 
#' Options to edit the range selector which is The range selector is a tool
#' for selecting ranges to display within the chart. It provides buttons
#' to select preconfigured ranges in the chart, like 1 day, 1 week, 1 month
#' etc. It also provides input boxes where min and max dates can be manually
#' input.
#' @param hc A \code{highchart} \code{htmlwidget} object.
#' @param ... Arguments defined in \url{http://api.highcharts.com/highstock#rangeSelector}.
#'
#' @export
hc_rangeSelector <- function(hc, ...){
  
  .hc_opt(hc, "rangeSelector", ...)
  
}

#' Setting mapNavigation options to highmaps charts
#' 
#' Options regarding the mapNavigation: A collection of options for zooming
#' and panning in a map.
#' @param hc A \code{highchart} \code{htmlwidget} object.
#' @param ... Arguments defined in \url{http://api.highcharts.com/highmaps#mapNavigation}.
#'
#' @export
hc_mapNavigation <- function(hc, ...){
  
  .hc_opt(hc, "mapNavigation", ...)
  
}

#' Setting Motion options to highcharts objects
#'
#' The Motion Highcharts Plugin adds an interactive HTML5 player
#' to any Highcharts chart (Highcharts, Highmaps and Highstock).
#'
#' @param hc A \code{highchart} \code{htmlwidget} object.
#' @param enabled Enable the motion plugin.
#' @param startIndex start index, default to 0.
#' @param ... Arguments defined in \url{https://github.com/larsac07/Motion-Highcharts-Plugin/wiki}.
#'
#' @export
hc_motion <- function(hc, enabled = TRUE, startIndex = 0, ...) {
  
  hc <- .hc_opt(hc, "motion", enabled = enabled, startIndex = startIndex, ...)
  
  hc <- hc_add_dependency_fa(hc)
  
  hc
  
}

#' Setting annotations to highcharts objects
#' 
#' Helper function to add annotations to highcharts library.
#' @param hc A \code{highchart} \code{htmlwidget} object.
#' @param ... Arguments defined in \url{https://api.highcharts.com/highcharts/annotations}.
#'
#' @export
hc_annotations <- function(hc, ...){
  
  .hc_opt(hc, "annotations", ...)
  
}

#' @rdname hc_annotations
#' @export
hc_add_annotation <- function(hc, ...){
  
  assertthat::assert_that(is.highchart(hc))
  
  hc$x$hc_opts[["annotations"]] <- append(hc$x$hc_opts[["annotations"]],
                                          list(list(...)))
  
  hc
  
}

#' @rdname hc_annotations
#' @param x A \code{list} or a \code{data.frame} of annotations.
#' @details The \code{x} elements must have \code{xValue} and \code{yValue}
#'   elements
#' @export
hc_add_annotations <- function(hc, x){
  
  assertthat::assert_that(is.highchart(hc), (is.list(x) | is.data.frame(x)))
  
  if (is.data.frame(x))
    x <- list_parse(x)
  
  hc$x$hc_opts[["annotations"]] <- append(hc$x$hc_opts[["annotations"]], x)
  
  hc
  
}

#' Setting annotations options to highcharts objects
#' @param hc A \code{highchart} \code{htmlwidget} object.
#' @param ... Options defined in \url{https://www.highcharts.com/products/plugin-registry/single/17/Annotations}.
#' @export
hc_annotationsOptions <- function(hc, ...){
  
  .Deprecated("hc_add_series", msg = "Now highcharts use annotation module instead of the pluging")
  
  .hc_opt(hc, "annotationsOptions", ...)
  
}

#' Setting accessibility options to highcharts objects
#' 
#' Options for configuring accessibility for the chart. Requires the accessibility module to be loaded.
#' @param hc A \code{highchart} \code{htmlwidget} object.
#' @param ... Options defined in \url{http://api.highcharts.com/highcharts/accessibility}.
#' @export
hc_accessibility <- function(hc, ...){
  
  .hc_opt(hc, "accessibility", ...)
  
}

#' Setting boost module options to highcharts objects
#' 
#' Options for the Boost module. The Boost module allows certain series types to
#' be rendered by WebGL instead of the default SVG. This allows hundreds of 
#' thousands of data points to be rendered in milliseconds. In addition to the
#' WebGL rendering it saves time by skipping processing and inspection of the 
#' data wherever possible.
#' @param hc A \code{highchart} \code{htmlwidget} object.
#' @param ... Options defined in \url{https://api.highcharts.com/highcharts/boost}.
#' @export
hc_boost <- function(hc, ...){
  
  .hc_opt(hc, "boost", ...)
  
}

