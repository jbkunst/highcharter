checkProxy <- function(proxy) {
  if (!"higchartProxy" %in% class(proxy)) 
    stop("This function must be used with a highchart proxy object")
}

#' Send commands to a Highcharts instance in a Shiny app
#' 
#' @param shinyId Single-element character vector indicating the output ID of
#'   the chart to modify
#' @param session The Shiny session object to which the map belongs; usually 
#' the default value will suffice.
#' @export
highchartProxy <- function(shinyId, session = shiny::getDefaultReactiveDomain()){
  
  proxy        <- list(id = shinyId, session = session)
  class(proxy) <- c("higchartProxy")
  
  return(proxy)
  
}

#' Add data to higchartProxy element
#' 
#' @param proxy A `higchartProxy` object.
#' @param data An R object supported by `hc_add_series` like data frame, ts, etc. 
#' @param ... Arguments defined in \url{https://api.highcharts.com/highcharts/plotOptions.series}.
#' @export
hcpxy_add_series <- function(proxy, data = NULL, ...) {
  
  checkProxy(proxy)
  
  stopifnot(!is.null(data))
  
  hcaux <- highchart() %>% 
    hc_add_series(data = data, ...)
  
  series <- hcaux[["x"]][["hc_opts"]][["series"]]
  
  for(i in 1:length(series)){
    
    if (getOption("highcharter.verbose")) {
      message("hcpxy_add_series")
    }
    
    proxy$session$sendCustomMessage(
      type = "addSeries",
      message = list(
        id = proxy$id,
        series = series[[i]]
        )
      )
  
  }
   
  proxy
  
}

#' Remove series to higchartProxy element
#' 
#' @param proxy A `higchartProxy` object.
#' @param id A character vector indicating the `id` (or `id`s) of the series to remove.
#' @param all A logical value to indicate to remove or not all series. The values
#'   is used only when the value is `TRUE`.
#' @export
hcpxy_remove_series <- function(proxy, id = NULL, all = FALSE) {
  
  checkProxy(proxy)
  
  # stopifnot(
  #   !is.null(id),
  #   is.character(id),
  #   is.logical(all)
  #   )
  
  if(all) {
    
    proxy$session$sendCustomMessage(
      type = "removeAllSeries",
      message = list(
        id = proxy$id
      )
    )
    
    return(proxy)
    
  }
  
  
  for(i in 1:length(id)){
    
    if (getOption("highcharter.verbose")) {
      message("hcpxy_remove_series")
    }
    
    proxy$session$sendCustomMessage(
      type = "removeSeries",
      message = list(
        id = proxy$id,
        idSeries = id[[i]]
      )
    )
    
  }
  
  proxy
  
}
  
#' Show or hide loading text for a higchartProxy object
#' 
#' @param proxy A `higchartProxy` object.
#' @param action Single-element character vector indicating to `"show"` or
#'   `"hide"` the loading text defined in `lang` options.
#' @export
hcpxy_loading <- function(proxy, action = "show") {
  
  checkProxy(proxy)
  
  stopifnot(
    is.character(action),
    action %in% c("show", "hide")
  )
  
  value <- action == "show"
  
  proxy$session$sendCustomMessage(
    type = "showLoading",
    message = list(
      id = proxy$id,
      showLoading = value
    )
  )
  
  proxy
  
}

#' Update options for a higchartProxy object
#' 
#' @param proxy A `higchartProxy` object.
#' @param ... Named options. 
#' @export
hcpxy_update <- function(proxy, ...) {
  
  checkProxy(proxy)
  
  proxy$session$sendCustomMessage(
    type = "updateChart",
    message = list(
      id = proxy$id,
      options = list(...)
    )
  )
  
  proxy
  
}

#' Update options series in a higchartProxy object
#' 
#' @param proxy A `higchartProxy` object.
#' @param id A character vector indicating the `id` (or `id`s) of the series to update.
#' @param ... Arguments defined in \url{https://api.highcharts.com/highcharts/plotOptions.series}.
#'   The arguments will be the same for each series. So if you want update data it
#'   is used this function sequentially for each series.
#' 
#' @export
hcpxy_update_series <- function(proxy, id = NULL, ...){
  
  checkProxy(proxy)
  
  for(i in 1:length(id)){
    
    if (getOption("highcharter.verbose")) {
      message("hcpxy_update_series")
    }
    
    proxy$session$sendCustomMessage(
      type = "updateSeries",
      message = list(
        id = proxy$id,
        idSeries = id[[i]],
        options = list(...)
      )
    )
    
  }
  
  proxy
  
}


#' Add point to a series of a higchartProxy object
#' 
#' @param proxy A `higchartProxy` object.
#' @param id A character vector indicating the `id` of the series to update.
#' @param point The point options. If options is a single number, a point with 
#'   that y value is appended to the series. If it is an list, it will be 
#'   interpreted as x and y values respectively. If it is an object, 
#'   advanced options as outlined under series.data are applied
#' @param redraw Whether to redraw the chart after the point is added. When 
#'   adding more than one point, it is highly recommended that the redraw option
#'   be set to false, and instead Highcharts.Chart#redraw is explicitly called 
#'   after the adding of points is finished. Otherwise, the chart will redraw 
#'   after adding each point.
#' @param shift If `TRUE`, a point is shifted off the start of the series as 
#'   one is appended to the end.
#' @param animation Whether to apply animation, and optionally animation configuration.
#' @export
hcpxy_add_point <- function(proxy, id = NULL, point, redraw = TRUE, shift = FALSE, animation = TRUE){
  
  checkProxy(proxy)
  
  proxy$session$sendCustomMessage(
    type = "addPoint",
    message = list(
      id = proxy$id,
      idSeries = id,
      point = point,
      redraw = redraw,
      shift = shift,
      animation = animation
      )
    )
    
  proxy
  
}

#' Remove point to a series of a higchartProxy object
#' 
#' @param proxy A `higchartProxy` object.
#' @param id A character vector indicating the `id` of the series to update.
#' @param i The index of the point in the data array. Remember js is 0 based index.
#' @param redraw Whether to redraw the chart after the point is added. When 
#'   adding more than one point, it is highly recommended that the redraw option
#'   be set to false, and instead Highcharts.Chart#redraw is explicitly called 
#'   after the adding of points is finished. Otherwise, the chart will redraw 
#'   after adding each point.
#' @export
hcpxy_remove_point <- function(proxy, id = NULL, i = NULL, redraw = TRUE){
  
  checkProxy(proxy)
  
  proxy$session$sendCustomMessage(
    type = "removePoint",
    message = list(
      id = proxy$id,
      idSeries = id,
      i = i,
      redraw = redraw
    )
  )
  
  proxy
  
}

#' Update data for a higchartProxy object
#' 
#' @param proxy A `higchartProxy` object.
#' @param type series type (column, bar, line, etc)
#' @param data dataframe of new data to send to chart
#' @param mapping how data should be mapped using `hcaes()`
#' @param redraw boolean Whether to redraw the chart after the series is altered. 
#'   If doing more operations on the chart, it is a good idea to set redraw to false and call hcpxy_redraw after.
#' @param animation boolean When the updated data is the same length as the existing data, points will be updated by default, 
#'   and animation visualizes how the points are changed. Set false to disable animation, or a configuration object to set duration or easing.
#' @param updatePoints boolean When this is TRUE, points will be updated instead of replaced whenever possible. 
#'   This occurs a) when the updated data is the same length as the existing data, b) when points are matched by their id's, or c) when points can be matched by X values. 
#'   This allows updating with animation and performs better. In this case, the original array is not passed by reference. Set FALSE to prevent.
#' 
#' @export
hcpxy_set_data <- function(proxy, type, data, mapping = hcaes(), redraw = FALSE, animation = NULL, updatePoints = TRUE) {
  checkProxy(proxy)
  
  data <- mutate_mapping(data, mapping)
  
  series <- data_to_series(data, mapping, type = type)
  
  for(i in 1:length(series))
    proxy$session$sendCustomMessage(
      type = 'setData',
      message = list(
        id = proxy$id,
        serie = i-1,
        data = series[[i]]$data,
        redraw = redraw,
        animation = animation,
        updatePoints = updatePoints
      )
    )
  
  proxy
  
}

#' Redraw a higchartProxy object
#' 
#' @param proxy A `higchartProxy` object.
#' 
#' @export
hcpxy_redraw <- function(proxy) {
  checkProxy(proxy)
  
  proxy$session$sendCustomMessage(
    type = 'redraw',
    message = list(id = proxy$id)
  )
  
  proxy
  
}
