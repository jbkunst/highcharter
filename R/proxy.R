#' @export
checkProxy <- function(proxy) {
  if (!"higchartProxy" %in% class(proxy)) 
    stop("This function must be used with a highchart proxy object")
}

#' @export
highchartProxy <- function(shinyId, session = shiny::getDefaultReactiveDomain()){
  
  proxy        <- list(id = shinyId, session = session)
  class(proxy) <- c("higchartProxy")
  
  return(proxy)
  
}

#' @export
hcpxy_add_series <- function(proxy, data = NULL, ...) {
  
  message("proxy")
  
  stopifnot(!is.null(data))
  
  hcaux <- highchart() %>% 
    hc_add_series(data = data, ...)
  
  series <- hcaux[["x"]][["hc_opts"]][["series"]]
  
  for(i in 1:length(series)){
    
    message("proxy$session$sendCustomMessage")
    
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
  
