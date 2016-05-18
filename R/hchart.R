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
  
  tbl <- table(object)
  
  highchart() %>% 
    hc_add_series_labels_values(names(tbl), as.vector(tbl), type = type, ...) %>% 
    hc_xAxis(categories = names(tbl))
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
  hc_add_series_ts(highchart(), object, ...)
}

#' @export
hchart.forecast <- function(object, fillOpacity = 0.3, ...){
  
  hc <- highchart() %>% 
    hc_add_series_ts(object$x, name = "Series", zIndex = 3, ...) %>% 
    hc_add_series_ts(object$mean, name = object$method,  zIndex = 2, ...)
  
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
hchart.mforecast <- function(object, fillOpacity = 0.3, ...){
  
  ntss <- ncol(object$x)
  lvls <- object$level
  tmf <- datetime_to_timestamp(zoo::as.Date(time(object$mean[[1]])))

  hc <- hchart.mts2(object$x) %>% 
    hc_plotOptions(
      series = list(
        marker = list(enabled = FALSE)
      )
    )
  
  # hc <- hc %>% hc_add_series(data = NULL, id = "series", name = "Series")
  
  # means
  hc <- hc %>% hc_add_series(data = NULL, id = "f", name = "forecast")
  for (i in seq(ntss))
    hc <- hc %>% hc_add_series_ts(object$mean[[i]], yAxis = i - 1, linkedTo = "f", ...)
  
  # levels
  for (lvl in seq(lvls)) {
    
    idlvl <- paste0("level", lvls[lvl])
    nmlvl <- paste("level", lvls[lvl])
    
    hc <- hc %>% hc_add_series(data = NULL, id = idlvl, name = nmlvl, ...)
    
    for (i in seq(ntss)) {
      
      dsbands <- data_frame(
        t = tmf,
        u = as.vector(object$upper[[i]][, lvl]),
        l = as.vector(object$lower[[i]][, lvl]))
      
      hc <- hc %>%
        hc_add_series(data = list.parse2(dsbands), name = nmlvl, linkedTo = idlvl, yAxis = i - 1,
                         type = "arearange", fillOpacity = fillOpacity,
                         zIndex = 1, lineWidth = 0, ...)
 
    }
    
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
  
  ds <- data_frame(
    x = seq(object$lag[ , , ]),
    y = object$acf[ , , ]) 
  
  hc <- highchart() %>% 
    hc_add_series_df(data = ds, type = "column",
                     name = ytitle, pointRange = 0.01)
  
  if (object$type != "covariance") {
    hc <- hc %>% 
      hc_plotOptions(series = list(marker = list(enabled = FALSE))) %>% 
      hc_add_series(data = list(list(0, sv), list(nrow(ds), sv)), 
                    color = hc_get_colors()[2],
                    showInLegend = FALSE, enableMouseTracking = FALSE) %>% 
      hc_add_series(data = list(list(0,-sv), list(nrow(ds),-sv)),
                    color = hc_get_colors()[2],
                    showInLegend = FALSE, enableMouseTracking = FALSE) 
  }
    
  hc
  
}

#' @export
hchart.mts <- function(object, ..., separate = TRUE, heights =  rep(1, ncol(object))) {
  
  if (separate) {
    hc <- hchart.mts2(object, heights = heights, ...)
  } else {
    hc <- hchart.mts1(object, ...)
  }
  
  hc 
}

hchart.mts1 <- function(object, ...) {
  
  hc <- highchart()
  
  for (i in seq(dim(object)[2])) {
    nm <- attr(object, "dimnames")[[2]][i]
    if ("ts" %in% class(object[, i]))
      hc <- hc %>% hc_add_series_ts(object[, i], name = nm, ...)
    else
      hc <- hc %>% hc_add_series_xts(object[, i], name = nm, ...)  
  }
  
  hc
  
}

hchart.mts2 <- function(object, ..., heights =  rep(1, ncol(object)), sep = 0.01) {
  
  ntss <- ncol(object)
  
  hc <- highchart() %>% 
    hc_tooltip(shared = TRUE) 
  
  hc <- hc %>% 
    hc_yAxis_multiples(
      create_yaxis(ntss, heights = heights, turnopposite = TRUE,
                   title = list(text = NULL), offset = 0, lineWidth = 2,
                   showFirstLabel = FALSE, showLastLabel = FALSE, ...)
    )
  
  namestss <- as.character(attr(object, "dimnames")[[2]])
  
  for (col in seq(ntss))
    hc <-  hc %>%  hc_add_series_ts(object[, col], yAxis = col - 1, name = namestss[col], ...)
  
  hc
 
}

#' @export
hchart.stl <- function(object, ..., heights = c(2, 1, 1, 1), sep = 0.01) {
  
  tss <- object$time.series
  ncomp <- ncol(tss)
  data <- drop(tss %*% rep(1, ncomp))
  tss <- cbind(data = data , tss)
  
  attr(tss, "dimnames")[[2]] <- gsub("tss\\.", "", attr(tss, "dimnames")[[2]])
  
  hchart.mts2(tss)
  
}

#' @export
hchart.ets <- function(object, ...){
  
  names <- c(y = "observed", l = "level", b = "slope", s1 = "season")
  
  data <- cbind(object$x, object$states[, colnames(object$states) %in%  names(names)])
  
  cn <- c("y", c(colnames(object$states)))
  
  colnames(data) <- cn <- names[stats::na.exclude(match(cn, names(names)))]
  
  hc <- hchart.mts2(data)
  
  hc <- hc %>% 
    hc_title(text = paste("Decomposition by", object$method, "method"))
  
  hc
  
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
    hc_add_series(data = list.parse3(dfv),
                 type = type, name = "nodes", zIndex = 3, 
                 tooltip = list(
                   headerFormat = as.character(tags$small("{point.key}")),
                   pointFormat = tltip_fmt
                 ), ...) 
  
  if (!is.null(dfv[["label"]])) {
    hc <- hc %>% 
      hc_add_series(data = list.parse3(dfv %>% select_(.dots = c("x", "y", "label"))),
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

#' @importFrom ape as.igraph.phylo makeNodeLabel
#' @importFrom igraph graph.edgelist V V<-
#' @export
hchart.phylo <- function(object, ...) {
  
  x <- object
  if (is.null(x$node.label))
    x <- makeNodeLabel(x)
  x$edge <- matrix(c(x$tip.label, x$node.label)[x$edge], ncol = 2)
  
  object <- graph.edgelist(x$edge)
  # object <- as.igraph.phylo(object)
  
  V(object)$size <- ifelse(str_detect(V(object)$name, "Node\\d+"), 0, 1)
  
  hchart(object, minSize = 0, ...)
  
}

#' @importFrom ggdendro dendro_data
#' @importFrom purrr by_row
#' @export
hchart.dendrogram <- function(object, ...) {
  
  dddata <- dendro_data(object)  
  
  x <- xend <- NULL
  
  dsseg <- dddata$segments
  dsseg$x <- dsseg$x - 1
  dsseg$xend <- dsseg$xend - 1
  
  dsseg <- dsseg %>% 
    mutate(x = x - 1, xend = xend - 1) %>% 
    by_row(function(x){
      list(list(x = x$x, y = x$y), list(x = x$xend, y = x$yend))
    }, .to = "out") %>% 
    .[["out"]]
  
  hc <- highchart() %>% 
    hc_plotOptions(
      series = list(
        lineWidth = 2,
        showInLegend = FALSE,
        marker = list(radius = 0),
        enableMouseTracking = FALSE
      )
    ) %>% 
    hc_xAxis(categories = dddata$labels$label,
             tickmarkPlacement = "on") %>% 
    hc_colors(list(hex_to_rgba("#606060")))
  
  for (i in seq_along(dsseg)) {
    hc <- hc %>% hc_add_series(data = dsseg[[i]], type = "scatter")
  }
  
  hc
}

#' Plot survival curves using Highcharts
#' 
#' @param object A survfit object as returned from the \code{survfit} function
#' @param ... Extra parameters to pass to \code{hc_add_series} function
#' @param fun Name of function or function used to transform the survival curve:
#' \code{log} will put y axis on log scale, \code{event} plots cumulative events
#' (f(y) = 1-y), \code{cumhaz} plots the cumulative hazard function (f(y) =
#' -log(y)), and \code{cloglog} creates a complimentary log-log survival plot
#' (f(y) = log(-log(y)) along with log scale for the x-axis.
#' @param markTimes Label curves marked at each censoring time? TRUE by default
#' @param symbol Symbol to use as marker (plus sign by default)
#' @param markerColor Color of the marker ("black" by default); use NULL to use
#' the respective color of each series
#' @param ranges Plot interval ranges? FALSE by default
#' @param rangesOpacity Opacity of the interval ranges (0.3 by default)
#' 
#' @return Highcharts object to plot survival curves
#' 
#' @examples
#' 
#' # Plot Kaplan-Meier curves
#' require("survival")
#' leukemia.surv <- survfit(Surv(time, status) ~ x, data = aml) 
#' hchart(leukemia.surv)
#' 
#' # Plot the cumulative hazard function
#' lsurv2 <- survfit(Surv(time, status) ~ x, aml, type='fleming') 
#' hchart(lsurv2, fun="cumhaz")
#' 
#' # Plot the fit of a Cox proportional hazards regression model
#' fit <- coxph(Surv(futime, fustat) ~ age, data = ovarian)
#' ovarian.surv <- survfit(fit, newdata=data.frame(age=60))
#' hchart(ovarian.surv, ranges = TRUE)
#' 
#' @export
hchart.survfit <- function(object, ..., fun = NULL, markTimes = TRUE,
                           symbol = "plus", markerColor = "black", ranges = FALSE,
                           rangesOpacity = 0.3) {
  
  group <- NULL
  
  # Check if there are groups
  if (is.null(object$strata))
    strata <- c("Series 1" = length(object$time))
  else
    strata <- object$strata
  
  # Modify data according to functions (adapted from survival:::plot.survfit)
  if (is.character(fun)) {
    tfun <- switch(fun,
                   log = function(x) x,
                   event = function(x) 1 - x,
                   cumhaz = function(x) -log(x),
                   cloglog = function(x) log(-log(x)),
                   pct = function(x) x * 100,
                   logpct = function(x) 100 * x,
                   identity = function(x) x,
                   function(x) x)
  } else if (is.function(fun)) {
    tfun <- fun
  } else {
    tfun <- function(x) x
  }
  
  firsty <- tfun(1)
  object$surv <- tfun(object$surv)
  if (ranges && !is.null(object$upper)) {
    object$upper <- tfun(object$upper)
    object$lower <- tfun(object$lower)
  }
  
  # Prepare data
  data <- data.frame(x=object$time, y=object$surv,
                     up=object$upper, low=object$lower,
                     group=rep(names(strata), strata), 
                     stringsAsFactors = FALSE)
  
  # Data markers
  marker <- list(list(fillColor=markerColor, symbol=symbol, enabled=TRUE))
  if(markTimes)
    mark <- object$n.censor == 1
  else
    mark <- FALSE
  
  # Adjust Y axis range
  yValues <- object$surv
  ymin <- ifelse(min(yValues) >= 0, 0, min(yValues))
  ymax <- ifelse(max(yValues) <= 1, 1, max(yValues))
  
  hc <- highchart() %>%
    hc_tooltip(shared = TRUE) %>%
    hc_yAxis(min=ymin, max=ymax) %>%
    hc_plotOptions(line = list(marker = list(enabled = FALSE)))
  
  count <- 0
  
  # Process groups by columns (CoxPH-like) or in a single column
  if(!is.null(ncol(object$surv))) {
    groups <- seq(ncol(object$surv))
  } else {
    groups <- names(strata)
  }
  
  for (name in groups) {
    if (!is.null(ncol(object$surv))) {
      df <- df[c("x", paste(c("y", "low", "up"), col, sep="."))]
      names(df) <- c("x", "y", "low", "up")
      submark <- mark
    } else {
      df <- subset(data, group == name)
      submark <- mark[data$group == name]
    }
    
    # Add first value if there is no value for time at 0 in the data
    if (!0 %in% df$x)
      first <- list(list(x=0, y=firsty))
    else
      first <- NULL
    
    # Mark events
    ls <- list.parse3(df)
    if (markTimes)
      ls[submark] <- lapply(ls[submark], c, marker=marker)
    
    hc <- hc %>% hc_add_series(
      data=c(first, ls), step="left", name=name, zIndex=1,
      color=JS("Highcharts.getOptions().colors[", count, "]"),
      ...)
    
    if (ranges && !is.null(object$upper)) {
      # Add interval range
      range <- lapply(ls, function(i) 
        setNames(i[c("x", "low", "up")], NULL))
      hc <- hc %>% hc_add_series(
        data=range, step="left", name="Ranges", type="arearange",
        zIndex=0, linkedTo=':previous', fillOpacity=rangesOpacity, 
        lineWidth=0,
        color=JS("Highcharts.getOptions().colors[", count, "]"),
        ...)
    }
    count <- count + 1
  }
  
  return(hc)
}

# # @export
# hchart.seas <- function(object, ..., outliers = TRUE, trend = FALSE) {
# 
#   hc <- highchart() %>%
#     hc_add_series_ts(seasonal::original(object),
#                     name = "original",
#                     zIndex = 3, id = "original") %>%
#     hc_add_series_ts(seasonal::final(object),
#                     name = "adjusted",
#                     zIndex = 2, id = "adjusted")
# 
#   if (trend) {
#     hc <- hc %>% hc_add_series_ts(seasonal::trend(object), name = "trend", zIndex = 1)
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
