# yAxis test-case
library(quantmod)
library(magrittr)

options(highcharter.debug = TRUE)

aapl <- quantmod::getSymbols("AAPL", 
  src = "yahoo",
  from = "2020-01-01",
  auto.assign = FALSE
)

with_height <- function() {
  hc <- highcharter::highchart(type = "stock", height = 500) %>%
    #highcharter::hc_size(height = 400) %>%
    highcharter::hc_title(text = "yAxis test") %>%
    highcharter::hc_add_series(aapl, yAxis = 0, showInLegend = FALSE)
  return(hc)
}
