hc_motion <- function(hc, ...) {
  
  highcharter:::.hc_opt(hc, "motion", ...)
  
}

highchart() %>% 
  hc_chart(type = "spline") %>% 
  hc_yAxis(max = 7, min = 0) %>% 
  hc_add_series(name = "JJ", data = c(2,3,4), zIndex = -10) %>% 
  hc_add_series(name = "J",
                data = list(
                  list(sequence = c(1,2,3,4)),
                  list(sequence = c(3,2,1,3)),
                  list(sequence = c(2,2,4,3))
                )) %>% 
  hc_motion(enabled = TRUE,
            labels = 2000:2003,
            series = 1)
  
