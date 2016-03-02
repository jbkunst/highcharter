rm(list = ls())
library("highcharter")


hc_add_event <- function(hc, typeseries = "scatter", event = "click", inputname = "hcput") {
  
  funtmp <- "function(){ alert(this.series.category)}"
  fun <- JS(sprintf(funtmp, inputname))
  
  eventobj <- structure(
    list(structure(
      list(structure(
        list(fun),
        .Names = event)
      ),
      .Names = "events")
    ),
    .Names = typeseries
  )
  
  
  hc$x$hc_opts$plotOptions <- rlist::list.merge(
    hc$x$hc_opts$plotOptions,
    eventobj
  )
  
 hc
  

}

