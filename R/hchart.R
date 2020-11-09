#' Create a highchart object from a particular data type
#'
#' \code{hchart} uses `highchart` to draw a particular plot for an
#' object of a particular class in a single command. This defines the S3
#' generic that other classes and packages can extend.
#'
#' Run \code{methods(hchart)} to see what objects are supported.
#'
#' @param object  A R object.
#' @param ... Additional arguments for the data series
#'    (\url{http://api.highcharts.com/highcharts#series}).
#'
#' @importFrom assertthat assert_that
#' @importFrom assertthat is.string
#'
#' @export
hchart <- function(object, ...) {
  UseMethod("hchart")
}

#' @export
hchart.default <- function(object, ...) {
  stop("Objects of class/type ", paste(class(object), collapse = "/"),
    " are not supported by hchart (yet).",
    call. = FALSE
  )
}

#' @export
hchart.list <- function(object, ...) {
  if (getOption("highcharter.verbose")) {
    message("hchart.list")
  }
  
  highchart() %>% 
    hc_add_series(data = object, ...)
  
}

#' @export
hchart.data.frame <- function(object, type = NULL, mapping = hcaes(), ...) {
  if (getOption("highcharter.verbose")) {
    message("hchart.data.frame")
  }
  assert_that(is.string(type), msg = "Chart type must be provided.")
  
  object <- as.data.frame(object)
  
  data <- mutate_mapping(object, mapping)

  series <- data_to_series(data, mapping, type = type, ...)

  opts <- data_to_options(data, type)

  hc <- highchart()

  if (opts$add_colorAxis) {
    hc <- hc_colorAxis(hc, auxpar = NULL)
  }

  hc <- hc %>%
    hc_add_series_list(series) %>%
    hc_xAxis(
      type = opts$xAxis_type,
      title = list(text = as.character(mapping$x)),
      categories = opts$xAxis_categories
    ) %>%
    hc_yAxis(
      type = opts$yAxis_type,
      title = list(text = as.character(mapping$y)),
      categories = opts$yAxis_categories
    ) %>%
    hc_plotOptions(
      series = list(
        showInLegend = opts$series_plotOptions_showInLegend
      ),
      scatter = list(marker = list(symbol = "circle"))
    )

  hc
}

#' @export
hchart.tibble <- hchart.data.frame

#' @importFrom graphics hist
#' @export
hchart.numeric <- function(object, breaks = "FD", ...) {
  h <- hist(object, plot = FALSE, breaks = breaks)

  hchart.histogram(h, ...)
}

#' @export
hchart.histogram <- function(object, ...) {
  d <- diff(object$breaks)[1]

  df <- tibble(
    x = object$mids,
    y = object$counts,
    name = sprintf("(%s, %s]", object$mids - d / 2, object$mids + d / 2)
  )

  highchart() %>%
    hc_chart(zoomType = "x") %>%
    hc_tooltip(formatter = JS("function() { return  this.point.name + '<br/>' + this.y; }")) %>%
    hc_add_series(
      data = list_parse(df),
      type = "column",
      pointRange = d,
      groupPadding = 0,
      pointPadding = 0,
      borderWidth = 0,
      ...
    )
}

#' @export
hchart.character <- function(object, type = "column", ...) {
  highchart() %>%
    hc_xAxis(type = "category") %>%
    hc_add_series(data = object, type = type, ...)
}

#' @export
hchart.factor <- hchart.character

#' @export
hchart.ts <- function(object, ...) {
  highchart() %>%
    hc_xAxis(type = "datetime") %>%
    hc_add_series(data = object, ...)
}

#' @export
hchart.xts <- function(object, ...) {
  highchart(type = "stock") %>%
    hc_add_series(data = object, ...)
}

#' @export
hchart.forecast <- function(object, addOriginal = TRUE, addLevels = TRUE, ...) {
  highchart() %>%
    hc_xAxis(type = "datetime") %>%
    hc_add_series(
      data = object, addOriginal = addOriginal,
      addLevels = addLevels, ...
    )
}

#' @export
hchart.mforecast <- function(object, separate = TRUE, fillOpacity = 0.3, ...) {
  ntss <- ncol(object$x)
  lvls <- object$level
  tmf <- datetime_to_timestamp(zoo::as.Date(time(object$mean[[1]])))
  nms <- attr(object$x, "dimnames")[[2]]

  hc <- hchart.mts2(object$x) %>%
    hc_plotOptions(
      series = list(
        marker = list(enabled = FALSE)
      )
    )

  # means
  hc <- hc %>% hc_add_series(data = NULL, id = "forecasts", name = "forecasts")

  for (i in seq(ntss)) {
    nm <- nms[i]
    hc <- hc %>%
      hc_add_series(object$mean[[nm]],
        name = paste("forecast", nm),
        yAxis = i - 1, linkedTo = "forecasts", ...
      )
  }


  # levels
  for (lvl in seq_along(lvls)) {
    idlvl <- paste0("level", lvls[lvl])
    nmlvl <- paste("level", lvls[lvl])

    hc <- hc %>% hc_add_series(data = NULL, id = idlvl, name = nmlvl, ...)

    for (i in seq(ntss)) {
      nm <- nms[i]

      dfbands <- tibble(
        t = tmf,
        u = as.vector(object$upper[[i]][, lvl]),
        l = as.vector(object$lower[[i]][, lvl])
      )

      hc <- hc %>%
        hc_add_series(
          data = list_parse2(dfbands),
          name = paste(nmlvl, nm),
          linkedTo = idlvl,
          yAxis = i - 1,
          type = "arearange", fillOpacity = fillOpacity,
          zIndex = 1, lineWidth = 0, ...
        )
    }
  }

  if (!separate) {
    hc$x$hc_opts$yAxis <- NULL
    hc$x$hc_opts$series <- map(hc$x$hc_opts$series, function(x) {
      x$yAxis <- NULL
      x
    })
  }

  hc
}

#' @importFrom stats qnorm
#' @export
hchart.acf <- function(object, ...) {
  ytitle <- switch(
    object$type,
    partial = "Partial ACF",
    covariance = "ACF (cov)",
    correlation = "ACF"
  )

  sv <- qnorm(1 - 0.05 / 2) / sqrt(object$n.used)

  ds <- tibble(
    x = seq(object$lag[, , ]),
    y = object$acf[, , ]
  )

  hc <- highchart() %>%
    hc_add_series(
      data = list_parse(ds),
      type = "column",
      groupPadding = 1,
      name = ytitle
    )

  if (object$type != "covariance") {
    hc <- hc %>%
      hc_yAxis(
        plotLines = list(
          list(width = 1, value = sv, color = "gray"),
          list(width = 1, value = -sv, color = "gray")
        )
      )
  }

  hc
}

#' @export
hchart.mts <- function(object, ..., separate = TRUE,
                       heights = rep(1, ncol(object))) {
  if (separate) {
    hc <- hchart.mts2(object, heights = heights, ...)
  } else {
    hc <- hchart.mts1(object, ...)
  }

  hc
}

hchart.mts1 <- function(object, ...) {
  hc <- highchart() %>%
    hc_xAxis(type = "datetime")

  for (i in seq(dim(object)[2])) {
    nm <- attr(object, "dimnames")[[2]][i]
    if ("ts" %in% class(object[, i])) {
      hc <- hc %>% hc_add_series(object[, i], name = nm, id = nm, ...)
    } else {
      hc <- hc %>% hc_add_series(object[, i], name = nm, id = nm, ...)
    }
  }

  hc
}

hchart.mts2 <- function(object, ..., heights = rep(1, ncol(object)), sep = 0.01) {
  ntss <- ncol(object)

  hc <- highchart() %>%
    hc_xAxis(type = "datetime") %>%
    hc_tooltip(shared = TRUE)

  hc <- hc %>%
    hc_yAxis_multiples(
      create_yaxis(ntss,
        heights = heights, turnopposite = TRUE,
        title = list(text = NULL), offset = 0, lineWidth = 2,
        showFirstLabel = FALSE, showLastLabel = FALSE, ...
      )
    )

  namestss <- as.character(attr(object, "dimnames")[[2]])

  for (col in seq(ntss)) {
    nm <- namestss[col]
    hc <- hc %>% hc_add_series(object[, col], yAxis = col - 1, name = nm, id = nm, ...)
  }


  hc
}

#' @export
hchart.stl <- function(object, ..., heights = c(2, 1, 1, 1), sep = 0.01) {
  tss <- object$time.series
  ncomp <- ncol(tss)
  data <- drop(tss %*% rep(1, ncomp))
  tss <- cbind(data = data, tss)

  attr(tss, "dimnames")[[2]] <- gsub("tss\\.", "", attr(tss, "dimnames")[[2]])

  hchart.mts2(tss)
}

#' @export
hchart.ets <- function(object, ...) {
  names <- c(y = "observed", l = "level", b = "slope", s1 = "season")

  data <- cbind(object$x, object$states[, colnames(object$states) %in% names(names)])

  cn <- c("y", c(colnames(object$states)))

  colnames(data) <- cn <- names[stats::na.exclude(match(cn, names(names)))]

  hc <- hchart.mts2(data)

  hc <- hc_title(hc, text = paste("Decomposition by", object$method, "method"))

  hc
}

#' @importFrom tidyr gather
#' @importFrom dplyr count_ left_join select
#' @importFrom rlang .data
#' @export
hchart.matrix <- function(object, label = FALSE, showInLegend = FALSE, ...) {
  if (getOption("highcharter.verbose")) {
    message("hchart.maxtrix")
  }

  stopifnot(is.numeric(object))

  df <- as.data.frame(object)

  ismatrix <- is.null(colnames(object)) & is.null(rownames(object))
  pos <- ifelse(ismatrix, 0, 1)

  xnm <- if (is.null(colnames(object))) seq_len(ncol(object)) else colnames(object)
  xnm <- as.character(xnm)
  xid <- seq(length(xnm)) - pos

  ynm <- if (is.null(rownames(object))) seq_len(nrow(object)) else rownames(object)
  ynm <- as.character(ynm)
  yid <- seq(length(ynm)) - pos

  ds <- as.data.frame(df) %>%
    tibble::as_tibble() %>%
    bind_cols(tibble(ynm), .) %>%
    gather("key", "value", -ynm) %>%
    rename(xnm = .data$key) %>%
    mutate(xnm = as.character(.data$xnm),
           ynm = as.character(.data$ynm))

  ds$xnm <- if (is.null(colnames(object))) str_replace(ds$xnm, "V", "") else ds$xnm

  ds <- ds %>%
    left_join(tibble(xnm, xid), by = "xnm") %>%
    left_join(tibble(ynm, yid), by = "ynm") %>%
    mutate(name = paste(.data$xnm, .data$ynm, sep = ' ~ ')) %>%
    select(x = .data$xid, y = .data$yid, .data$value, .data$name)

  fntltp <- JS("function(){
                 return this.point.name + ': ' +
                   Highcharts.numberFormat(this.point.value, 2)
               }")

  hc <- highchart() %>%
    hc_add_series(data = list_parse(ds), type = "heatmap") %>%
    hc_plotOptions(
      series = list(
        showInLegend = showInLegend,
        boderWidth = 0,
        dataLabels = list(enabled = label)
      )
    ) %>%
    hc_tooltip(formatter = fntltp) %>%
    hc_legend(enabled = TRUE) %>%
    hc_colorAxis(auxarg = TRUE)

  if (ismatrix) {
    hc <- hc %>%
      hc_xAxis(visible = FALSE) %>%
      hc_yAxis(visible = FALSE, reversed = TRUE)
  } else {
    hc <- hc %>%
      hc_xAxis(categories = xnm, title = list(text = ""), opposite = TRUE) %>%
      hc_yAxis(categories = ynm, title = list(text = ""), reversed = TRUE)
  }

  # correlogram
  if (-1 <= min(object) & min(object) < 0 & max(object) <= 1) {
    hc <- hc_colorAxis(hc,
      stops = color_stops(3, c("#FF5733", "#F8F5F5", "#2E86C1")),
      min = -1, max = 1
    )
  } else {
    hc <- hc_colorAxis(hc, nullpar = NULL)
  }

  hc
}

#' @importFrom tidyr gather
#' @importFrom dplyr count_ left_join select_
#' @export
hchart.dist <- function(object, ...) {
  hchart.matrix(as.matrix(object))
}

#' @importFrom igraph vertex_attr edge_attr get.edgelist layout_nicely
#' @importFrom stats setNames
#' @importFrom rlang .data
#' @export
hchart.igraph <- function(object, ..., layout = layout_nicely, digits = 2) {

  # data
  dfv <- layout(object) %>%
    round(digits) %>%
    data.frame() %>%
    tibble::as_tibble() %>%
    setNames(c("x", "y"))

  dfvex <- object %>%
    vertex_attr() %>%
    data.frame(stringsAsFactors = FALSE) %>%
    tibble::as_tibble()

  if (nrow(dfvex) > 0) {
    dfv <- tibble::as_tibble(cbind(dfv, dfvex))
  }

  if (is.null(dfv[["name"]])) {
    dfv <- dfv %>% mutate(name = seq(nrow(dfv)))
  }

  names(dfv) <- str_replace_all(names(dfv), "\\.", "_")

  dfe <- object %>%
    get.edgelist() %>%
    data.frame(stringsAsFactors = FALSE) %>%
    tibble::as_tibble() %>%
    setNames(c("from", "to")) %>%
    left_join(dfv %>%
      select(.data$name, .data$x, .data$y) %>%
      setNames(c("from", "xf", "yf")), by = "from") %>%
    left_join(dfv %>%
      select(.data$name, .data$x, .data$y) %>%
      setNames(c("to", "xt", "yt")), by = "to") %>%
    mutate(linkedTo = "e")

  dfex <- object %>%
    edge_attr() %>%
    data.frame(stringsAsFactors = FALSE) %>%
    tibble::as_tibble()

  if (nrow(dfex) > 0) {
    dfe <- tibble::as_tibble(cbind(dfe, dfex))
  }

  # Checking opts
  type <- "scatter"

  if ("size" %in% names(dfv)) {
    dfv <- dfv %>% rename(z = .data$size)
    type <- "bubble"
  }

  if ("group" %in% names(dfv)) {
    dfv <- dfv %>% rename(groupvar = .data$group)
  }

  if ("width" %in% names(dfe)) {
    dfe <- dfe %>% rename(lineWidth = .data$width)
  }

  if (!"color" %in% names(dfe)) {
    dfe <- dfe %>% mutate("color" = hex_to_rgba("#d3d3d3", 0.5))
  }

  dse <- list_parse(dfe) %>%
    map(function(x) {
      x$data <- list(
        list(x = x$xf, y = x$yf),
        list(x = x$xt, y = x$yt)
      )
      x[c("xf", "yf", "xt", "yt")] <- NULL
      x
    })

  vattrs <- setdiff(names(dfv), c("x", "y", "z", "color", "label", "name"))

  tltip_fmt <- tooltip_table(
    str_to_title(str_replace_all(vattrs, "_", " ")),
    sprintf("{point.%s}", vattrs)
  )

  hc <- highchart() %>%
    hc_chart(zoomType = "xy", type = "line") %>%
    hc_tooltip(
      useHTML = TRUE
    ) %>%
    hc_plotOptions(
      line = list(enableMouseTracking = FALSE),
      bubble = list(
        marker = list(fillOpacity = 0.65),
        minSize = 5, maxSize = 20
      )
    ) %>%
    hc_add_theme(
      hc_theme_null(legend = list(enabled = TRUE))
    )

  hc <- hc %>%
    hc_add_series(
      data = list_parse(dfv),
      type = type, name = "nodes", zIndex = 3,
      tooltip = list(
        headerFormat = as.character(tags$small("{point.key}")),
        pointFormat = tltip_fmt
      ), ...
    )

  if ("label" %in% names(dfv)) {
    hc <- hc %>%
      hc_add_series(
        data = list_parse(dfv %>% select(.data$x, .data$y, .data$label)),
        type = "scatter", name = "labels", zIndex = 4,
        marker = list(radius = 0), enableMouseTracking = FALSE,
        dataLabels = list(enabled = TRUE, format = "{point.label}")
      )
  }

  hc <- hc %>%
    hc_add_series(data = NULL, name = "edges", id = "e") %>%
    hc_add_series_list(dse)

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
#' lsurv2 <- survfit(Surv(time, status) ~ x, aml, type = "fleming")
#' hchart(lsurv2, fun = "cumhaz")
#'
#' # Plot the fit of a Cox proportional hazards regression model
#' fit <- coxph(Surv(futime, fustat) ~ age, data = ovarian)
#' ovarian.surv <- survfit(fit, newdata = data.frame(age = 60))
#' hchart(ovarian.surv, ranges = TRUE)
#' @export
hchart.survfit <- function(object, ..., fun = NULL, markTimes = TRUE,
                           symbol = "plus", markerColor = "black",
                           ranges = FALSE, rangesOpacity = 0.3) {
  group <- NULL

  # Check if there are groups
  if (is.null(object$strata)) {
    strata <- c("Series 1" = length(object$time))
  } else {
    strata <- object$strata
  }

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
      function(x) x
    )
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
  data <- data.frame(
    x = object$time, y = object$surv,
    up = object$upper, low = object$lower,
    group = rep(names(strata), strata),
    stringsAsFactors = FALSE
  )

  # Data markers
  marker <- list(list(fillColor = markerColor, symbol = symbol, enabled = TRUE))

  if (markTimes) {
    mark <- object$n.censor == 1
  } else {
    mark <- FALSE
  }

  # Adjust Y axis range
  yValues <- object$surv
  ymin <- ifelse(min(yValues) >= 0, 0, min(yValues))
  ymax <- ifelse(max(yValues) <= 1, 1, max(yValues))

  hc <- highchart() %>%
    hc_tooltip(shared = TRUE) %>%
    hc_yAxis(min = ymin, max = ymax) %>%
    hc_plotOptions(line = list(marker = list(enabled = FALSE)))

  count <- 0

  # Process groups by columns (CoxPH-like) or in a single column
  if (!is.null(ncol(object$surv))) {
    groups <- seq(ncol(object$surv))
  } else {
    groups <- names(strata)
  }

  for (name in groups) {
    if (!is.null(ncol(object$surv))) {
      df <- df[c("x", paste(c("y", "low", "up"), col, sep = "."))]
      names(df) <- c("x", "y", "low", "up")
      submark <- mark
    } else {
      df <- subset(data, group == name)
      submark <- mark[data$group == name]
    }

    # Add first value if there is no value for time at 0 in the data
    if (!0 %in% df$x) {
      first <- list(list(x = 0, y = firsty))
    } else {
      first <- NULL
    }

    # Mark events
    ls <- list_parse(df)
    if (markTimes) {
      ls[submark] <- lapply(ls[submark], c, marker = marker)
    }


    hc <- hc %>%
      hc_add_series(
        data = c(first, ls), step = "left", name = name, zIndex = 1,
        color = JS(sprintf("Highcharts.getOptions().colors[%s]", count)),
        ...
      )

    if (ranges && !is.null(object$upper)) {
      # Add interval range
      range <- lapply(ls, function(i)
        setNames(i[c("x", "low", "up")], NULL))

      hc <- hc %>%
        hc_add_series(
          data = range, step = "left", name = "Ranges",
          type = "arearange", zIndex = 0, linkedTo = ":previous",
          fillOpacity = rangesOpacity, lineWidth = 0,
          color = JS(sprintf("Highcharts.getOptions().colors[%s]", count)),
          ...
        )
    }
    count <- count + 1
  }

  hc <- hc %>%
    hc_plotOptions(
      series = list(
        states = list(hover = list(enabled = FALSE))
      )
    )

  return(hc)
}

#' @importFrom tibble rownames_to_column
#' @importFrom rlang .data
#' @export
hchart.density <- function(object, type = "area", ...) {
  hc_add_series(highchart(), data = object, type = type, ...)
}

#' @importFrom dplyr as_tibble
hchart.pca <- function(sdev, n.obs, scores, loadings, ...,
                       choices = 1L:2L, scale = 1) {
  stopifnot(length(choices) == 2L)
  stopifnot(0 <= scale | scale <= 1)

  lam <- sdev[choices]
  lam <- lam * sqrt(n.obs)

  if (scale != 0) {
    lam <- lam^scale
  } else {
    lam <- 1
  }

  dfobs <- (scores[, choices] / lam) %>%
    as.data.frame() %>%
    setNames(c("x", "y")) %>%
    rownames_to_column("name")

  dfcomp <- loadings[, choices] * lam

  mx <- max(abs(dfobs[, 2:3]))
  mc <- max(abs(dfcomp))

  dfcomp <- dfcomp %>%
    {
      . / mc * mx
    } %>%
    as.data.frame() %>%
    setNames(c("x", "y")) %>%
    rownames_to_column("name") %>%
    as_tibble() %>%
    group_by(.data$name) %>%
    do(data = list(c(0, 0), c(.$x, .$y))) %>%
    list_parse()

  highchart() %>%
    hc_plotOptions(
      line = list(
        marker = list(enabled = FALSE)
      )
    ) %>%
    hc_add_series(
      data = list_parse(dfobs), name = "observations", type = "scatter",
      dataLabels = list(enabled = TRUE, format = "{point.name}"), ...
    ) %>%
    hc_add_series_list(dfcomp)
}

#' @export
hchart.princomp <- function(object, ..., choices = 1L:2L, scale = 1) {
  hchart.pca(object$sdev, object$n.obs, object$scores, object$loadings,
    choices = choices, scale = scale, ...
  )
}

#' @importFrom dplyr as_tibble
#' @export
hchart.prcomp <- function(object, ..., choices = 1L:2L, scale = 1) {
  hchart.pca(object$sdev, nrow(object$x), object$x, object$rotation,
    choices = choices, scale = scale, ...
  )
}
