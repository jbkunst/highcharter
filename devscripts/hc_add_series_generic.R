options(highcharter.verbose = TRUE)

#' work with length(data) == 1
highchart() %>%
  hc_add_series(data = 1)

highchart() %>%
  hc_add_series(data = list(1))

# numeric and lists  
highchart() %>%
  hc_add_series(data = abs(rnorm(5))) %>%
  hc_add_series(data = abs(rnorm(5)), type = "column", color = "red", name = "asd") %>% 
  hc_add_series(data = purrr::map(0:4, function(x) list(x, x)), type = "scatter", color = "blue", name = "dsa")


# time series
highchart() %>%
  hc_xAxis(type = "datetime") %>% 
  hc_add_series(data = AirPassengers) %>%
  hc_add_series(data = AirPassengers + 3000, color = "red", name = "asd")


# xts
library("quantmod")
usdjpy <- getSymbols("USD/JPY", src="oanda", auto.assign = FALSE)
eurkpw <- getSymbols("EUR/KPW", src="oanda", auto.assign = FALSE)

highchart(type = "stock") %>%
  hc_add_series(usdjpy, id = "usdjpy") %>%
  hc_add_series(data = eurkpw, id = "eurkpw")

# ohlc
library("quantmod")
x <- getSymbols("GOOG", auto.assign = FALSE)
y <- getSymbols("SPY", auto.assign = FALSE)

highchart(type = "stock") %>%
  hc_add_series(x) %>%
  hc_add_series(y) %>% 
  hc_add_series(data = eurkpw, id = "eurkpw")
  
highchart(type = "stock") %>%
  hc_add_series_ohlc(x) %>% 
  hc_add_series_ohlc(y)

