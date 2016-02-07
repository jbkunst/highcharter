library("seasonal")
object <- seas(AirPassengers,
               regression.aictest = c("td", "easter"),
               outlier.critical = 3)

plot(object)

#' @importFrom seasonal original final trend outlier
hchart.seas <- function(object, outliers = TRUE, trend = FALSE, ...) {
  
  hc <- highchart() %>% 
    hc_add_serie_ts(original(object), name = "original", zIndex = 3, id = "original") %>% 
    hc_add_serie_ts(final(object), name = "adjusted", zIndex = 2, id = "adjusted") 
  
  if (trend) {
    hc <- hc %>% hc_add_serie_ts(trend(object), name = "trend", zIndex = 1) 
  }
  
  if (outliers) {
    ol.ts <- outlier(object)  
    ixd.nna <- !is.na(ol.ts)
    text <- as.character(ol.ts)[!is.na(ol.ts)]
    dates <- zoo::as.Date(time(ol.ts))[!is.na(ol.ts)]
    hc <- hc %>% hc_add_series_flags(dates, text, text,
                                     name = "outiliers", id = "adjusted") 
  }
  
  hc
  
}
