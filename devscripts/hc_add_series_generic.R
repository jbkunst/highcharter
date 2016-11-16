library(highcharter)
options(highcharter.verbose = TRUE)
options(highcharter.theme = hc_theme_smpl())

#' work with length(data) == 1
highchart() %>%
  hc_add_series(data = 1) %>% 
  hc_add_theme(hc_theme_538())

highchart() %>%
  hc_add_series(data = list(1)) %>% 
  hc_add_theme(hc_theme_538())

# data.frame --------------------------------------------------------------
data <- mtcars %>% mutate(x = hp, y = disp)

highchart() %>% 
  hc_add_series(data = data, type = "scatter")

# numeric and lists -------------------------------------------------------
highchart() %>%
  hc_add_series(data = abs(rnorm(5)), type = "column", name = "asd") %>% 
  hc_add_series(data = abs(rnorm(5))) %>%
  hc_add_series(data = purrr::map(0:4, function(x) list(x, x)), type = "scatter", color = "blue", name = "dsa")



# time series -------------------------------------------------------------
hc <- highchart() %>%
  hc_xAxis(type = "datetime") %>% # important
  hc_add_series(data = mdeaths, lineWidth = 5) %>%
  hc_add_series(data = fdeaths, name = "Other Series") %>% 
  hc_add_series(data = ldeaths)

hchart(ldeaths)


# xts ---------------------------------------------------------------------
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
  hc_add_series(y, type = "ohlc") %>% 
  hc_add_series(eurkpw, id = "eurkpw")
  
hchart(x, type = "ohlc")
hchart(y, type = "candlestick")

# 
library(forecast)

# forecast ----------------------------------------------------------------
x <- log(AirPassengers)
object1 <- forecast(auto.arima(x), level = 90)
object2 <- forecast(stl(x, s.window = 12), level = 90)
object3 <- forecast(ets(x), level = 90)

hchart(object2)
hchart(object2, addOriginal = FALSE)
hchart(object2, addLevels = FALSE)
hchart(object2, addOriginal = FALSE, addLevels = FALSE)

highchart() %>% 
  hc_xAxis(type = "datetime") %>% 
  hc_tooltip(table = TRUE, shared = TRUE) %>% 
  hc_add_series(data = x, name = "Air Passengers") %>%
  hc_add_series(data = object1, addLevels = TRUE, color = "#FF0000") %>% 
  hc_add_series(data = object2, addLevels = TRUE, color = "#00FF00") %>% 
  hc_add_series(data = object3, addLevels = TRUE, color = "#0000FF") 


# density -----------------------------------------------------------------
highchart() %>% 
  hc_add_series(data = density(rbeta(1000, 5, 5)), type = "line") %>% 
  hc_add_series(data = density(rbeta(1000, 5,  1)), type = "area") %>% 
  hc_add_series(data = density(rbeta(1000, 1, 5)), type = "areaspline")

hchart(density(rnorm(200), bw = 2), type = "area")

hcdensity(density(rexp(500, 1)))
hcdensity(rexp(500, 1))

# character ---------------------------------------------------------------
library(dplyr)
data <- sample(LETTERS[1:6], 50, replace = T)
data2 <- sample(LETTERS[4:10], 50, replace = T)
data3 <- sample(LETTERS[3:7], 50, replace = T)

as_data_frame(table(data)) %>% 
  full_join(as_data_frame(table(data2)), by = c("data" = "data2")) %>% 
  full_join(as_data_frame(table(data3)), by = c("data" = "data3"))

hc <- highchart() %>% 
  hc_xAxis(type = "category") %>% # important
  hc_add_series(data) %>% 
  hc_add_series(data2) %>% 
  hc_add_series(data3)

hc

hc %>%
  hc_chart(type = "column") %>% 
  hc_plotOptions(column = list(stacking = "normal"))

hchart(data)

hcpie(data)
