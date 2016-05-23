rn <- function(n = 10) round(rexp(n), 2)
s <- function(ms = 1) ms*1000 

highchart() %>% 
  hc_add_series(data = rn(), animation = list(delay = s(2), duration = s(8)), type = "column") %>% 
  hc_add_series(data = rn(), animation = list(delay = s(3), duration = s(7)), type = "column") %>% 
  hc_add_series(data = rn(), animation = list(delay = s(5), duration = s(5)), type = "column") 

highchart() %>% 
  hc_plotOptions(series = list(marker = list(enabled = FALSE))) %>% 
  hc_add_series(data = rn(), animation = list(delay = s(2), duration = s(1)), type = "spline") %>% 
  hc_add_series(data = rn(), animation = list(delay = s(3), duration = s(7 + 3)), type = "spline") %>% 
  hc_add_series(data = rn(), animation = list(delay = s(5), duration = s(5 + 5)), type = "spline") 
