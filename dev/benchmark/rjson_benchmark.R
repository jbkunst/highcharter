library(microbenchmark)
library(quantmod)
library(magrittr)

options(highcharter.verbose = TRUE)
options(highcharter.debug = FALSE)
options(highcharter.rjson = TRUE)

aapl <- quantmod::getSymbols("AAPL",
  src = "yahoo",
  from = "2020-01-01",
  auto.assign = FALSE
)

# Add some NA with SMA.
aapl$SMA <- runMean(aapl$AAPL.Close, 20)

to_benchmark <- function() {
  highcharter::highchart(type = "stock", height = 500) %>%
    highcharter::hc_title(text = "RJSON test") %>%
    highcharter::hc_add_series(aapl, yAxis = 0, showInLegend = FALSE) %>%
    highcharter::hc_add_series(aapl$SMA, yAxis = 0, showInLegend = TRUE)
}

# Create highcharter object and benchmark test JSON conversion.
hc <- to_benchmark()
res <- microbenchmark::microbenchmark(
  rjson::toJSON(hc),
  shiny:::toJSON(hc),
  times = 10
)

print(res)
