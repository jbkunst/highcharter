library(microbenchmark)
library(quantmod)
library(magrittr)

options(highcharter.debug = FALSE)
options(highcharter.rjson = TRUE)

aapl <- quantmod::getSymbols("AAPL",
  src = "yahoo",
  from = "2020-01-01",
  auto.assign = FALSE
)

to_benchmark <- function() {
  hc <- highcharter::highchart(type = "stock", height = 500) %>%
    highcharter::hc_title(text = "RJSON test") %>%
    highcharter::hc_add_series(aapl, yAxis = 0, showInLegend = FALSE)
  return(hc)
}

hc <- to_benchmark()

res <- microbenchmark(
  rjson::toJSON(hc),
  shiny:::toJSON(hc),
  times = 10
)

print(res)
