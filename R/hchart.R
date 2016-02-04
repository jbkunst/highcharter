#' Create a highchart object from a particular data type
#' 
#' \code{hchart} uses \code{highchart} to draw a particular plot for an 
#' object of a particular class in a single command. This defines the S3 
#' generic that other classes and packages can extend.
#' 
#' Run \code{methods(hchart)} to see what objects are supported.
#' 
#' @param object  A R object.
#' @param ... Aditional arguments for the data series 
#'    (\url{http://api.highcharts.com/highcharts#series}).
#'    
#' @export
hchart <- function(object, ...){
  
  UseMethod("hchart")

}

#' @export
hchart.default <- function(object, ...) {
  stop("Objects of type ", paste(class(object), collapse = "/"),
       " not supported by hchart (yet).", call. = FALSE)
}

#' @export
hchart.numeric <- function(object, breaks = "FD", ...) {
  
  h <- hist(object, plot = FALSE, breaks = breaks)
  
  hchart.histogram(h)

}

#' @export
hchart.histogram <- function(object, ...) {

  d <- diff(object$breaks)[1]
  
  ds <- data_frame(x = object$mids,
                   y = object$counts, 
                   name = sprintf("(%s, %s]",object$mids - d/2, object$mids + d/2)) %>% 
    list.parse3()
  
  highchart() %>%
    hc_chart(zoomType = "x") %>% 
    hc_tooltip(formatter = JS("function() { return  this.point.name + '<br/>' + this.y; }")) %>% 
    hc_add_series(data = ds, type = "column",
                  pointRange = d, groupPadding = 0,
                  pointPadding =  0, borderWidth = 0, ...)
  
}

#' @export
hchart.character <- function(object, type = "column", ...) {
  
  cnts <- count_(data_frame(variable = object), "variable")
  
  highchart() %>% 
    hc_add_series_labels_values(cnts[["variable"]], 
                                cnts[["n"]],
                                type = type, ...) %>% 
    hc_xAxis(categories = cnts[["variable"]])
}

#' @export
hchart.factor <- hchart.character

#' @export
hchart.xts <- function(object, ...) {
  
  if (is.OHLC(object))
    hc_add_series_ohlc(highchart(type = "stock"), object, ...)
  else
    hc_add_series_xts(highchart(type = "stock"), object, ...)
}

#' @export
hchart.ts <- function(object, ...) {
  hc_add_series_ts(highchart(type = "stock"), object, ...)
}

#' @export
hchart.forecast <- function(object, fillOpacity = 0.3, ...){
  
  hc <- highchart() %>% 
    hc_add_serie_ts(object$x, name = "Series", zIndex = 3, ...) %>% 
    hc_add_serie_ts(object$mean, name = object$method,  zIndex = 2, ...)
  
  # time, names (forecast)
  tmf <- datetime_to_timestamp(zoo::as.Date(time(object$mean)))
  nmf <- paste("level", object$level)
  
  for (m in seq(ncol(object$upper))) {
    
    dsbands <- data_frame(t = tmf,
                          u = as.vector(object$upper[, m]),
                          l = as.vector(object$lower[, m])) %>% 
      list.parse2()
    hc <- hc %>% hc_add_series(data = dsbands,
                               name = nmf[m],
                               type = "arearange",
                               fillOpacity = fillOpacity,
                               zIndex = 1,
                               lineWidth = 0, ...)
  }
  
  hc
  
}

#' @export
hchart.acf <- function(object, ...){
  
  ytitle <- switch(object$type,
                   partial = "Partial ACF",
                   covariance = "ACF (cov)",
                   correlation = "ACF"
                   )
  
  maxlag <- max(object$lag[ , , ])
  sv <- qnorm(1 - 0.05/2) / sqrt(object$n.used)
  
  ds <- data_frame(x = object$lag[ , , ],
                   y = object$acf[ , , ]) %>% 
    list.parse2()
  
  hc <- highchart() %>% 
    hc_add_series(data = ds, type = "column",
                  name = ytitle, pointRange = 0.01)
  
  if (object$type != "covariance") {
    hc <- hc %>% 
      hc_plotOptions(series = list(marker = list(enabled = FALSE))) %>% 
      hc_add_series(data = list(list(0, sv), list(maxlag, sv)), 
                    color = hc_get_colors()[2],
                    showInLegend = FALSE, enableMouseTracking = FALSE) %>% 
      hc_add_series(data = list(list(0,-sv), list(maxlag,-sv)),
                    color = hc_get_colors()[2],
                    showInLegend = FALSE, enableMouseTracking = FALSE) 
  }
    
  hc
  
}

#' @export
hchart.mts <- function(object, ...) {
  
  hc <- highchart(type = "stock")
  
  for (i in seq(dim(object)[2])) {
    nm <- attr(object, "dimnames")[[2]][i]
    if (class(object[, i]) == "ts") 
      hc <- hc %>% hc_add_series_ts(object[, i], name = nm, ...)  
    else
      hc <- hc %>% hc_add_series_xts(object[, i], name = nm, ...)  
  }
  
  hc
}

#' @importFrom seasonal original final trend outlier
#' @export
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
    hc <- hc %>% hc_add_series_flags(dates, text, text, zIndex = 4,
                                     name = "outiliers", id = "adjusted") 
  }
  
  hc
  
}

#' @importFrom tidyr gather
#' @importFrom dplyr count_ left_join select_
#' @export
hchart.dist <- function(object, ...) {
  
  df <- as.data.frame(as.matrix(object), stringsAsFactors = FALSE)
  
  x <- y <- names(df)
  
  df <- tbl_df(cbind(x = y, df)) %>% 
    gather(y, dist, -x) %>% 
    mutate(x = as.character(x),
           y = as.character(y)) %>% 
    left_join(data_frame(x = y,
                         xid = seq(length(y)) - 1), by = "x") %>% 
    left_join(data_frame(y = y,
                         yid = seq(length(y)) - 1), by = "y")
  
  ds <- df %>% 
    select_("xid", "yid", "dist") %>% 
    list.parse2()
  
  fntltp <- JS("function(){
                  return this.series.xAxis.categories[this.point.x] + '<br>' +
                         this.series.yAxis.categories[this.point.y] + '<br>' +
                         Highcharts.numberFormat(this.point.value, 2);
               ; }")
  
  highchart() %>% 
    hc_chart(type = "heatmap") %>% 
    hc_xAxis(categories = y, title = NULL) %>% 
    hc_yAxis(categories = y, title = NULL) %>% 
    hc_add_series(data = ds) %>% 
    hc_tooltip(formatter = fntltp) %>% 
    hc_legend(align = "right", layout = "vertical",
              margin = 0, verticalAlign = "top",
              y = 25, symbolHeight = 280) %>% 
    hc_colorAxis(arg  = "")
}
