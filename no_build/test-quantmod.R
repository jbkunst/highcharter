rm(list = ls())
require("quantmod")

getSymbols("SPY", src = "google")

time <- time(SPY) %>% 
  zoo::as.Date() %>% 
  as.POSIXct() %>% 
  as.numeric() %>% 
  { 1000 * . }

spy <- SPY[,-5] %>% 
  as.data.frame() %>% 
  {cbind(time, .)} %>% 
  list.parse2()

highchart(highstock = TRUE) %>% 
  hc_add_series(type = "candlestick",
                data = spy,
                name = "SPY",
                dataGrouping = list(
                  units = list(
                    list("week", 1),
                    list("month", c(1,2,3,4,6))
                  )
                )
  )


