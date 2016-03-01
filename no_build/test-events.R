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

hc <- hc_demo() %>%
  hc_chart(type = "scatter") %>% 
  hc_plotOptions(
    point = list(
      events = list(
        click = JS("function(){ console.log(this)}")
        )
      )
    )

hc

hc2 <- hc_demo() %>% 
  hc_chart(type = "scatter") %>% 
  hc_add_event_serie(event = "click")

hc2


hc$x$hc_opts$plotOptions$series
hc2$x$hc_opts$plotOptions$series
