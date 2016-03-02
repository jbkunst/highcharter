rm(list = ls())
library("highcharter")


hc_add_event <- function(hc, typeseries = "scatter", event = "click", inputname = "inputname") {
  
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

fn <- "function(){
  alert('Category: ' + this.category + ', value: ' + this.y + ', series: ' + this.series.name);
  window.ds = this.series.data.map(function(e){ return {x: e.x, y: e.y  }  } );  
}"

hc <- hc_demo() %>%
  hc_chart(type = "scatter") %>%  
  hc_plotOptions(
    series = list(
      cursor = "pointer",
      point = list(
        events = list(
          click = JS(fn)
          )
        )
      )
    ) 

hc
