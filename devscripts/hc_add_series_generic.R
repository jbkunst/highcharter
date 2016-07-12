hc_add_series <- function(hc, x, ...){
  
  clssx <- class(x)
  
  if(clssx %in% "list")
    
    hc <- hc %>% hc_add_series_list(data = x, ...)
  
  else if (clssx %in% c("data.frame", "tbl_df"))
    
    hc <- hc %>% hc_add_series(data = list_parse(x), ...)
  
  else if (clssx %in% "ts")
    
    hc <- hc %>% hc_add_series_ts(x, ...)
  
  else {
    # stop("xs of class/type ", paste(class(x), collapse = "/"),
    #      " are not supported by hchart (yet).", call. = FALSE)
    validate_args("add_series", eval(substitute(alist(...))))
    hc$x$hc_opts$series <- append(hc$x$hc_opts$series, list(list(...)))
    hc
  }
  
  hc
    
}

library("highcharter")

hc <- highchart()

class(AirPassengers)

hc %>%  hc_add_seriesg(AirPassengers)


library("dplyr")
data <- data_frame(x = rnorm(100),
                   y = x*2 + 3 + rnorm(100)*2,
                   color = colorize(x))

hc %>%
  hc_add_seriesg(data, type = "scatter")

hc_add_series
