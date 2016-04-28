#' ---
#' layout: post
#' ---
#+echo=FALSE
rm(list = ls())
library("highcharter")

#'
#' ## Highstock Examples
#' 
#' <div id ="toc"></div>
#' 
#' Highstock work well with the quantmod package. It's 
#' easy download data and chart it. 
#'
#' ### Candlestick and OHLC charts
#'  

library("quantmod")

x <- getSymbols("AAPL", auto.assign = FALSE)
y <- getSymbols("AMZN", auto.assign = FALSE)

highchart() %>% 
  hc_add_series_ohlc(x) %>% 
  hc_add_series_ohlc(y, type = "ohlc") %>% 
  hc_add_theme(hc_theme_538())


#'
#' ### Time series
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
#' ### A more interesting example
#' 
SPY <- getSymbols("SPY", from="2015-01-01", auto.assign=FALSE)
SPY <- adjustOHLC(SPY)

SPY.SMA.10 <- SMA(Cl(SPY), n=10)
SPY.SMA.200 <- SMA(Cl(SPY), n=200)
SPY.RSI.14 <- RSI(Cl(SPY), n=14)
SPY.RSI.SellLevel <- xts(rep(70, NROW(SPY)), index(SPY))
SPY.RSI.BuyLevel <- xts(rep(30, NROW(SPY)), index(SPY))


highchart() %>% 
  # create axis :)
  hc_yAxis_multiples(
    list(title = list(text = NULL), height = "45%", top = "0%"),
    list(title = list(text = NULL), height = "25%", top = "47.5%", opposite = TRUE),
    list(title = list(text = NULL), height = "25%", top = "75%")
  ) %>% 
  # series :D
  hc_add_series_ohlc(SPY, yAxis = 0, name = "SPY") %>% 
  hc_add_series_xts(SPY.SMA.10, yAxis = 0, name = "Fast MA") %>% 
  hc_add_series_xts(SPY.SMA.200, yAxis = 0, name = "Slow MA") %>% 
  hc_add_series_xts(SPY$SPY.Volume, color = "gray", yAxis = 1, name = "Volume", type = "column") %>% 
  hc_add_series_xts(SPY.RSI.14, yAxis = 2, name = "Osciallator") %>% 
  hc_add_series_xts(SPY.RSI.SellLevel, color = "red", yAxis = 2, name = "Sell level", enableMouseTracking = FALSE) %>% 
  hc_add_series_xts(SPY.RSI.BuyLevel, color = "blue", yAxis = 2, name = "Buy level", enableMouseTracking = FALSE) %>% 
  # I <3 themes
  hc_add_theme(hc_theme_smpl())
