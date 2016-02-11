#' ---
#' layout: post
#' ---

#'
#' ## Welcome to the Highcharter homepage
#'
#' This website is under construcction. *Shhh* see the old one here 
#' http://jkunst.com/highcharter/oldindex.html
#'

library("highcharter")

hc <- highchart() %>% 
  hc_title(text = "A nice chart") %>% 
  hc_add_series(data = c(7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2,
                         26.5, 23.3, 18.3, 13.9, 9.6))

hc


#' 
#' Lorem lorem pondunorem
#' 

library("quantmod")

x <- getSymbols("AAPL", auto.assign = FALSE)
y <- getSymbols("AMZN", auto.assign = FALSE)

highchart() %>% 
  hc_add_series_ohlc(x) %>% 
  hc_add_series_ohlc(y, type = "ohlc") 

#'
#' Lorem lorem pondunorem
#' 

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
