rm(list = ls())
require("quantmod")


x <- getSymbols("AAPL", auto.assign = FALSE)
y <- getSymbols("SPY", auto.assign = FALSE)

highchart() %>% 
  hc_add_series_ohlc(x) %>% 
  hc_add_series_ohlc(y)


usdjpy <- getSymbols("USD/JPY", src="oanda", auto.assign = FALSE)
eurkpw <- getSymbols("EUR/KPW", src="oanda", auto.assign = FALSE)


hc <- highchart(highstock = TRUE) %>% 
  hc_add_series_xts(usdjpy, id = "usdjpy") %>% 
  hc_add_series_xts(eurkpw, id = "eurkpw")

hc

dates <- as.Date(c("2015-05-08", "2015-09-12"),
                 format = "%Y-%m-%d")

hc %>% 
  hc_add_series_flags(dates,
                      title = c("E1", "E2"), 
                      text = c("This is event 1", "This is the event 2"),
                      id = "usdjpy") %>% 
  hc_add_theme(hc_theme_gridlight())
