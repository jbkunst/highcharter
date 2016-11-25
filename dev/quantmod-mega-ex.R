#+echo=FALSE
knitr::opts_chunk$set(warning = FALSE, message = FALSE)

#' Examples

suppressPackageStartupMessages(library(quantmod))

SPY <- getSymbols("SPY", from="2015-01-01", auto.assign=FALSE)
SPY <- adjustOHLC(SPY)

SPY.SMA.10 <- SMA(Cl(SPY), n=10)
SPY.SMA.200 <- SMA(Cl(SPY), n=200)
SPY.RSI.14 <- RSI(Cl(SPY), n=14)
SPY.RSI.SellLevel <- xts(rep(70, NROW(SPY)), index(SPY))
SPY.RSI.BuyLevel <- xts(rep(30, NROW(SPY)), index(SPY))

# subset <- "2015/"
# chart_Series(SPY, subset=subset)
# add_Vo() # Adds volume pane
# add_TA(SPY.SMA.10, on=-1, col="blue") # Adds fast moving average to base series
# add_TA(SPY.SMA.200, on=-1, col="red") # Adds slow moving average to base series
# add_TA(SPY.RSI.14) # Adds indicator (osciallator) below the chart in separate pane
# add_TA(SPY.RSI.SellLevel, on=3, col="red") # Adds another line to indicator pane
# add_TA(SPY.RSI.BuyLevel, on=3, col="green") # Adds another line to indicator pane

library("highcharter")
spaces <- c(45, 2.5, 25, 2.5, 25) # chart, space, 2nd chart, space, last chart
cumsum(spaces)

hc <- highchart() %>% 
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

hc

# If you want to make the chart more "simple" 
hc %>% 
  hc_chart(zoomType = "x") %>% 
  hc_rangeSelector(enabled = FALSE) %>% 
  hc_navigator(enabled = FALSE) %>% 
  hc_scrollbar(enabled = FALSE)


