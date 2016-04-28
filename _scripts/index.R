#' ---
#' layout: post
#' ---
#' 
#' ## Welcome to the Highcharter homepage
#'

#+echo=FALSE
rm(list = ls())
try(source("_scripts/helpers.R"))
try(source("helpers.R"))
get_demos()

#'
#' Highcharter is a [R](https://cran.r-project.org/) wrapper for **Highcharts** javascript
#' libray and its modules. Highcharts is very mature and flexible javascript charting library and
#'  it has a great and powerful API^[See http://www.highcharts.com/demo].
#' 
#' The main features of this package are:
#' 
#' - The implementation of **Highcharts** API including **Highstocks** and **Highmaps**.
#' You can chart almost every type of chart using the ap. It is a **must** 
#' know how highcharts works to take advantage of this package.
#' - The shortcuts functions to easily add data from R objects to a highchart one
#' like xts, ohlc, treemaps, etc.
#' - The `hchart()` function. This function can chart various R objects on the
#' fly. The resulting chart is a highchart object so you
#' can keep modifying with the implmented API.
#' - Themes. Highcharts is super really flexible to create themes.
#' - Plugin implementations such a motion, font awesome and drag plugins.
#' 
#' 
#' ### Hello World Example 
#' 
#'  This is a simple example.
#' 
library("highcharter")

hc <- highchart() %>% 
  hc_chart(type = "column") %>% 
  hc_title(text = "A highcharter chart") %>% 
  hc_xAxis(categories = 2012:2016) %>% 
  hc_add_series(data = c(3900,  4200,  5700,  8500, 11900),
                name = "Downloads")

hc

#' 
#' ### Generic Function `hchart`
#' 
#' Among its features highcharter can chart various objects 
#' with the generic^[I want to say *magic*] 
#' `hchart` function and add 
#' themes.

data(diamonds, package = "ggplot2")

hchart(diamonds$price, color = "#B71C1C", name = "Price") %>% 
  hc_title(text = "You can zoom me")

hchart(diamonds$cut, colorByPoint = TRUE, name = "Cut")

#' 
#' One of the nicest class which `hchart` can plot is the `forecast`
#' class from the forecast package.
#' 

library("forecast")

airforecast <- forecast(auto.arima(AirPassengers), level = 95)

hchart(airforecast) %>%
  hc_title(text = "Charting Example using hchart") %>% 
  hc_add_theme(hc_theme_smpl())


#' 
#' ### Highstock
#' 
#' With highcharter you can use the highstock library which 
#' include sophisticated navigation options like a small navigator 
#' series, preset date ranges, date picker, scrolling and panning.
#' With highcarter it's easy make candlesticks or ohlc charts using
#' time series data. For example data from [quantmod](http://www.quantmod.com/)
#' package.
#' 
library("quantmod")

usdjpy <- getSymbols("USD/JPY", src = "oanda", auto.assign = FALSE)
eurkpw <- getSymbols("EUR/KPW", src = "oanda", auto.assign = FALSE)

dates <- as.Date(c("2015-05-08", "2015-09-12"), format = "%Y-%m-%d")

highchart(type = "stock") %>% 
  hc_title(text = "Charting some Symbols") %>% 
  hc_subtitle(text = "Data extracted using quantmod package") %>% 
  hc_add_series_xts(usdjpy, id = "usdjpy") %>% 
  hc_add_series_xts(eurkpw, id = "eurkpw") %>% 
  hc_add_series_flags(dates,
                      title = c("E1", "E2"), 
                      text = c("Event 1", "Event 2"),
                      id = "usdjpy") %>% 
  hc_add_theme(hc_theme_flat()) 

#' 
#' ### Highmaps
#' 
#' You can chart maps and choropleth using the highmaps module.

library("viridisLite")
library("dplyr")

data(unemployment)
data(uscountygeojson)

dclass <- data_frame(from = seq(0, 10, by = 2),
                     to = c(seq(2, 10, by = 2), 50),
                     color = substring(viridis(length(from), option = "C"), 0, 7))
dclass <- list.parse3(dclass)

highchart() %>% 
  hc_title(text = "US Counties unemployment rates, April 2015") %>% 
  hc_add_series_map(uscountygeojson, unemployment,
                    value = "value", joinBy = "code") %>% 
  hc_colorAxis(dataClasses = dclass) %>% 
  hc_legend(layout = "vertical", align = "right",
            floating = TRUE, valueDecimals = 0,
            valueSuffix = "%") %>% 
  hc_mapNavigation(enabled = TRUE) 
