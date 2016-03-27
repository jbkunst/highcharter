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
  stop("Objects of class/type ", paste(class(object), collapse = "/"),
       " are not supported by hchart (yet).", call. = FALSE)
}

#' @importFrom graphics hist
#' @export
hchart.numeric <- function(object, breaks = "FD", ...) {
  
  h <- hist(object, plot = FALSE, breaks = breaks)
  
  hchart.histogram(h, ...)

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

#' @importFrom stats qnorm
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

#' @export
hchart.stl <- function(object, ..., widths = c(2, 1, 1, 1), sep = 0.01) {
  
  tss <- object$time.series
  ncomp <- ncol(tss)
  data <- drop(tss %*% rep(1, ncomp))
  tss <- cbind(data = data , tss)
  
  pcnt <- function(x) paste0(x * 100, "%")
  
  p <- widths/sum(widths)
  p <- c(p[1], sep, p[2], sep, p[3], sep, p[4])
  
  p <- round(p/sum(p), 2)
  csp <- cumsum(p)
  
  cspp <- pcnt(csp)
  pp <- pcnt(p)
  
  yxs <- list(title = list(text = NULL),
              offset = 0, lineWidth = 2,
              showFirstLabel = FALSE, showLastLabel = FALSE)
  
  highchart() %>% 
    hc_tooltip(shared = TRUE) %>% 
    hc_yAxis(
      list.merge(yxs, list(height = pp[1], top = "0%")),
      list.merge(yxs, list(height = pp[3], top = cspp[2], opposite = TRUE)),
      list.merge(yxs, list(height = pp[5], top = cspp[4])),
      list.merge(yxs, list(height = pp[7], top = cspp[6], opposite = TRUE))
    ) %>% 
    hc_add_serie_ts(tss[, 1], yAxis = 0, name = "data") %>% 
    hc_add_serie_ts(tss[, 2], yAxis = 1, name = "seasonal") %>% 
    hc_add_serie_ts(tss[, 3], yAxis = 2, name = "trend") %>% 
    hc_add_serie_ts(tss[, 4], yAxis = 3, name = "remainder")
  
}

#' @importFrom tidyr gather
#' @importFrom dplyr count_ left_join select_
#' @export
hchart.dist <- function(object, ...) {
  
  df <- as.data.frame(as.matrix(object), stringsAsFactors = FALSE)
  
  dist <- NULL
  
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

#' @importFrom igraph get.vertex.attribute get.edge.attribute get.edgelist layout_nicely
#' @importFrom stringr str_to_title
#' @importFrom stats setNames
#' @export
hchart.igraph <- function(object, ..., layout = layout_nicely, digits = 2) {
  
  lst_to_tbl <- function(x) {
    x %>% 
      data.frame(stringsAsFactors = FALSE) %>% 
      tbl_df() 
  }
  
  # data
  dfv <- layout(object) %>%
    round(digits) %>% 
    lst_to_tbl() %>% 
    setNames(c("x", "y"))
  
  dfvex <- object %>% 
    get.vertex.attribute() %>% 
    lst_to_tbl()

  if (nrow(dfvex) > 0) 
    dfv <- tbl_df(cbind(dfv, dfvex))
  
  if (is.null(dfv[["name"]]))
    dfv <- dfv %>%  mutate(name = seq(nrow(dfv)))
  
  names(dfv) <- str_replace_all(names(dfv), "\\.", "_")
  
  dfe <-  object %>%
    get.edgelist() %>% 
    lst_to_tbl() %>% 
    setNames(c("from", "to")) %>% 
    left_join(dfv %>%
                select_(.dots = c("name", "x", "y")) %>%
                setNames(c("from", "xf", "yf")), by = "from") %>% 
    left_join(dfv %>% 
                select_(.dots = c("name", "x", "y")) %>% 
                setNames(c("to", "xt", "yt")), by = "to") %>% 
    mutate(linkedTo  = "e")
  
  dfex <- object %>% 
    get.edge.attribute() %>% 
    lst_to_tbl()
  
  if (nrow(dfex) > 0)
    dfe <- tbl_df(cbind(dfe, dfex))
  
  # Checking opts
  type <- "scatter"
  
  if (!is.null(dfv[["size"]])) {
    dfv <- dfv %>% rename_("z" = "size")
    type <- "bubble"
  }
  
  
  if (!is.null(dfv[["group"]])) 
    dfv <- dfv %>% rename_("groupvar" = "group")
  
  if (!is.null(dfe[["width"]])) 
    dfe <- dfe %>% rename_("lineWidth" = "width")
  
  if (is.null(dfe[["color"]])) 
    dfe <- dfe %>% mutate("color" = hex_to_rgba("#d3d3d3", 0.5))
  
  dse <- dfe %>%
    list.parse3() %>% 
    map(function(x) {
      # x <- sample( dfe %>% list.parse3(), 1)[[1]]
      x$data <- list(
        list(x = x$xf, y = x$yf),
        list(x = x$xt, y = x$yt)
      )
      x[c("xf", "yf", "xt", "yt")] <- NULL
      x
      
    })
  
  vattrs <- setdiff(names(dfv), c("x", "y", "z", "color", "label" , "name"))
  tltip_fmt <- tooltip_table(
    str_to_title(str_replace(vattrs, "_", " ")),
    sprintf("{point.%s}", vattrs))
  
  hc <- highchart() %>% 
    hc_chart(zoomType = "xy", type = "line") %>% 
    hc_tooltip(
      useHTML = TRUE
    ) %>% 
    hc_plotOptions(
      line = list(enableMouseTracking = FALSE),
      bubble = list(
        marker = list(fillOpacity = 0.65),
        minSize = 5, maxSize = 20)
    ) %>% 
    hc_add_theme(
      hc_theme_null(legend = list(enabled = TRUE))
    )
  
  hc <- hc %>% 
    hc_add_serie(data = list.parse3(dfv),
                 type = type, name = "nodes", zIndex = 3, 
                 tooltip = list(
                   headerFormat = as.character(tags$small("{point.key}")),
                   pointFormat = tltip_fmt
                 ), ...) 
  
  if (!is.null(dfv[["label"]])) {
    hc <- hc %>% 
      hc_add_serie(data = list.parse3(dfv %>% select_(.dots = c("x", "y", "label"))),
                   type = "scatter", name = "labels", zIndex = 4,
                   marker = list(radius = 0), enableMouseTracking = FALSE,
                   dataLabels = list(enabled = TRUE, format = "{point.label}"))
  }
  
  hc <- hc %>% hc_add_series(data = NULL, name = "edges", id = "e")
 
  hc$x$hc_opts$series <- append(
    hc$x$hc_opts$series,
    dse
  )
  
  hc 
    
}

# # @export
# hchart.seas <- function(object, ..., outliers = TRUE, trend = FALSE) {
# 
#   hc <- highchart() %>%
#     hc_add_serie_ts(seasonal::original(object),
#                     name = "original",
#                     zIndex = 3, id = "original") %>%
#     hc_add_serie_ts(seasonal::final(object),
#                     name = "adjusted",
#                     zIndex = 2, id = "adjusted")
# 
#   if (trend) {
#     hc <- hc %>% hc_add_serie_ts(seasonal::trend(object), name = "trend", zIndex = 1)
#   }
# 
#   if (outliers) {
#     ol.ts <- seasonal::outlier(object)
#     ixd.nna <- !is.na(ol.ts)
#     text <- as.character(ol.ts)[!is.na(ol.ts)]
#     dates <- zoo::as.Date(time(ol.ts))[!is.na(ol.ts)]
#     hc <- hc %>% hc_add_series_flags(dates, text, text, zIndex = 4,
#                                      name = "outiliers", id = "adjusted")
#   }
# 
#   hc
# }
