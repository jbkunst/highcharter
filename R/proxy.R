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

#' Show or hide loading text for a higchartProxy object
#' 
#' @param proxy A `higchartProxy` object.
#' @param id A character vector indicating the `id` (or `id`s) of the series to update.
#' @param ... Arguments defined in \url{https://api.highcharts.com/highcharts/plotOptions.series}.
#'   The argumnes will be the same for each series. So if you want update data it
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



