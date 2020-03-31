# yAxis test-case
library(quantmod)
library(magrittr)

options(highcharter.debug = TRUE)

aapl <- quantmod::getSymbols("AAPL", 
  src = "yahoo",
  from = "2020-01-01",
  auto.assign = FALSE
)

# Plain stock chart (failed without preset "yAxis$title" option).
plain <- function() { 
  hc <- highcharter::highchart(type = "stock") %>%
    highcharter::hc_title(text = "yAxis test") %>%
    highcharter::hc_add_series(aapl, yAxis = 0, showInLegend = FALSE)
  message("yAxis title: ", hc$x$hc_opts$yAxis)
  return(hc)
}

# Add yAxis title.
with_yaxis <- function() {
  hc <- highcharter::highchart(type = "stock") %>%
    highcharter::hc_title(text = "yAxis test") %>%
    highcharter::hc_add_series(aapl, yAxis = 0, showInLegend = FALSE) %>%
    highcharter::hc_yAxis(title = list(text = "Prices"))
  message("yAxis title: ", hc$x$hc_opts$yAxis)
  return(hc)
}

# Add yAxis title and add another yAxis.
with_both <- function() {
  hc <- try(highcharter::highchart(type = "stock") %>%
    highcharter::hc_title(text = "yAxis test") %>%
      highcharter::hc_add_series(aapl, yAxis = 0, showInLegend = FALSE) %>%
      highcharter::hc_yAxis(title = list(text = "Prices")) %>%
      highcharter::hc_add_yAxis(title = list(text = "Should stop"))
  )
  message("yAxis 2: ", hc$x$hc_opts$yAxis)
  return(hc)
}

with_add_yaxis <- function() {
  hc <- highcharter::highchart(type = "stock") %>%
    highcharter::hc_title(text = "yAxis test") %>%
    highcharter::hc_add_series(aapl, yAxis = 0, showInLegend = FALSE) %>%
    highcharter::hc_add_yAxis(title = list(text = "Prices"))
  message("yAxis one: ", hc$x$hc_opts$yAxis)
  return(hc)
}

with_plotline <- function() {
  hc <- highcharter::highchart(type = "stock") %>%
    highcharter::hc_title(text = "yAxis test") %>%
    highcharter::hc_add_series(aapl, yAxis = 0, showInLegend = FALSE) %>%
    highcharter::hc_add_yAxis(title = list(text = "Prices"),
      plotLines = list(list(color = '#FF0000', value = 300, width = 2))
    )
  message("yAxis one: ", hc$x$hc_opts$yAxis)
  return(hc)
}

with_create_yaxis <- function() {
  hc <- highcharter::highchart(type = "stock") %>%
    highcharter::hc_title(text = "yAxis test") %>%
    highcharter::hc_add_series(aapl, yAxis = 0, showInLegend = FALSE) %>%
    highcharter::hc_add_series(aapl[, "AAPL.Volume"], yAxis = 1, type = "column", showInLegend = FALSE) %>%
    highcharter::hc_yAxis_multiples(create_yaxis(naxis = 2, lineWidth = 2, title = list(text = NULL), heights = c(2, 1)))
  message("yAxis one: ", hc$x$hc_opts$yAxis)
  return(hc)
}

with_vol_relative <- function() {
  hc <- highcharter::highchart(type = "stock") %>%
    highcharter::hc_title(text = "yAxis test") %>%
    highcharter::hc_add_series(aapl, yAxis = 0, showInLegend = FALSE) %>%
    highcharter::hc_add_series(aapl[, "AAPL.Volume"], yAxis = 1, type = "column", showInLegend = FALSE) %>%
    highcharter::hc_add_yAxis(nid = 1L, title = list(text = "Prices"), relative = 2,
      plotLines = list(list(color = '#FF0000', value = 300, width = 2))
    ) %>%
    highcharter::hc_add_yAxis(nid = 2L, title = list(text = "Volume"), relative = 1)
  message("yAxis one: ", hc$x$hc_opts$yAxis)
  return(hc)
}
