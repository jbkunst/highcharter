#' @export
hchart.ts <- function(object, ...) {
  highchart() |>
    hc_xAxis(type = ts_axis_type(object)) |>
    hc_add_series(data = object, ...)
}

#' @rdname hchart
#' @details A `CausalImpact` fit shows the observed response and counterfactual
#' prediction, the pointwise effect and the cumulative effect. Shaded bands show
#' the model's posterior intervals. A vertical line marks the start of the
#' post-intervention period.
#' @export
hchart.CausalImpact <- function(object, ...) {
  series <- as.data.frame(object$series)
  if (all(is.na(series$point.pred))) {
    stop("The CausalImpact fit has no posterior predictions.", call. = FALSE)
  }
  index <- zoo::index(object$series)
  post <- match(object$model$post.period[1], index)
  if (inherits(index, c("yearmon", "yearqtr"))) {
    index <- as.Date(index)
  }
  dated <- inherits(index, c("Date", "POSIXt"))
  x <- if (dated) datetime_to_timestamp(index) else as.numeric(index)

  columns <- c("point.pred", "point.effect", "cum.effect")
  labels <- c("Counterfactual", "Pointwise effect", "Cumulative effect")
  axes <- create_axis(
    3,
    heights = c(1.4, 1, 1),
    sep = 0.04,
    turnopposite = FALSE
  )
  titles <- c("Response", "Effect", "Total effect")
  hc <- highchart() |>
    hc_chart(alignTicks = FALSE) |>
    hc_xAxis(
      type = if (dated) "datetime" else "linear",
      plotLines = list(list(
        value = x[post],
        width = 1,
        dashStyle = "Dash",
        color = "#777777",
        zIndex = 4,
        label = list(text = "Intervention")
      ))
    ) |>
    hc_tooltip(shared = TRUE, table = TRUE) |>
    hc_plotOptions(
      line = utils::modifyList(
        list(zIndex = 1, marker = list(enabled = FALSE)),
        list(...)
      ),
      arearange = list(
        color = "#888888",
        fillOpacity = 0.22,
        lineWidth = 0,
        marker = list(enabled = FALSE),
        enableMouseTracking = FALSE
      )
    ) |>
    hc_add_series(
      data = list_parse2(data.frame(x, series$response)),
      type = "line",
      name = "Observed"
    )

  for (i in seq_along(columns)) {
    axes[[i]]$title <- list(text = titles[i])
    key <- columns[i]
    interval <- series[paste0(key, c(".lower", ".upper"))]
    hc <- hc |>
      hc_add_series(
        data = list_parse2(data.frame(x, series[[key]])),
        type = "line",
        name = labels[i],
        yAxis = i - 1L
      ) |>
      hc_add_series(
        data = list_parse2(data.frame(x, interval)),
        type = "arearange",
        name = paste(labels[i], "interval"),
        linkedTo = ":previous",
        yAxis = i - 1L
      )
  }
  hc_yAxis(hc, axes)
}

#' @export
hchart.seas <- function(object, ...) {
  observed <- seasonal::original(object)
  adjusted <- seasonal::final(object)
  hc <- hchart(observed, name = "Original", ...) |>
    hc_tooltip(table = TRUE)
  if (is.null(adjusted)) {
    return(hc)
  }
  hc <- hc |> hc_add_series(adjusted, name = "Seasonally adjusted", ...)
  outliers <- seasonal::outlier(object)
  i <- which(!is.na(outliers))
  if (length(i)) {
    events <- data.frame(
      x = ts_x_values(adjusted)[i],
      y = as.numeric(adjusted[i]),
      text = as.character(outliers[i])
    )
    hc <- hc_add_annotation(hc, labels = data_to_annotation_labels(events))
  }
  hc
}

#' @export
hchart.xts <- function(object, ...) {
  highchart(type = "stock") |>
    hc_add_series(data = object, ...)
}

#' @export
hchart.forecast <- function(object, addOriginal = TRUE, addLevels = TRUE, ...) {
  highchart() |>
    hc_tooltip(table = TRUE) |>
    hc_plotOptions(
      arearange = list(
        tooltip = list(
          pointFormat = "<tr><td>{series.name}</td><td><b>{point.low} \u2013 {point.high}</b></td></tr>"
        )
      )
    ) |>
    hc_xAxis(type = ts_axis_type(object$mean)) |>
    hc_add_series(
      data = object,
      addOriginal = addOriginal,
      addLevels = addLevels,
      ...
    )
}

#' @export
hchart.mforecast <- function(
  object,
  separate = TRUE,
  fillOpacity = 0.3,
  ...,
  addLevels = TRUE,
  addOriginal = TRUE
) {
  forecasts <- object$forecast
  x <- object$x
  if (is.null(forecasts)) {
    # Older mforecast objects store the results in parallel lists.
    means <- object$mean
    if (!is.null(names(means)) && !is.null(colnames(x))) {
      means <- means[colnames(x)]
    }
    forecasts <- lapply(seq_along(means), function(i) {
      list(
        x = x[, i],
        mean = means[[i]],
        level = object$level,
        lower = object$lower[[i]],
        upper = object$upper[[i]]
      )
    })
  } else {
    x <- do.call(cbind, unname(lapply(forecasts, `[[`, "x")))
    if (is.null(dim(x))) {
      dim(x) <- c(length(x), 1L)
    }
    colnames(x) <- names(forecasts)
  }
  if (is.null(colnames(x))) {
    colnames(x) <- paste("Series", seq_along(forecasts))
  }
  labels <- colnames(x)
  hc <- hchart.mts(x, separate = separate) |>
    hc_plotOptions(series = list(marker = list(enabled = FALSE)))
  observed <- if (addOriginal) hc$x$hc_opts$series
  hc$x$hc_opts$series <- list()

  # Each legend entry controls the same layer across all panels.
  groups <- list()
  for (i in seq_along(forecasts)) {
    f <- forecasts[[i]]
    chart <- hc_add_series.forecast(
      hc,
      f,
      name = labels[i],
      addLevels = addLevels,
      fillOpacity = fillOpacity,
      ...
    )
    layers <- chart$x$hc_opts$series
    titles <- c("forecasts", sprintf("level %s", f$level))
    for (j in seq_along(layers)) {
      title <- titles[j]
      id <- sub(" ", "", title, fixed = TRUE)
      if (is.null(groups[[id]])) {
        key <- list(data = NULL, id = id, name = title)
        if (j > 1L) {
          key <- c(key, list(...))
        }
        groups[[id]] <- list(key)
      }
      layer <- layers[[j]]
      if (separate) {
        layer$yAxis <- i - 1
      }
      layer$id <- NULL
      layer$linkedTo <- id
      layer$name <- paste(if (j == 1L) "forecast" else title, labels[i])
      groups[[id]] <- append(groups[[id]], list(layer))
    }
  }
  hc_add_series_list(
    hc,
    c(observed, unlist(groups, recursive = FALSE, use.names = FALSE))
  )
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

  options <- validate_args("hchart", list(...))
  add_acf <- function(hc, x, y, name, ...) {
    defaults <- list(
      type = "lollipop",
      marker = list(enabled = TRUE),
      pointRange = 0,
      name = name,
      ...
    )
    rlang::exec(
      hc_add_series,
      hc,
      data = list_parse(tibble(x = x, y = y)),
      !!!.merge_options(defaults, options)
    )
  }

  y_axis <- list()
  if (object$type != "covariance") {
    sv <- qnorm(1 - 0.05 / 2) / sqrt(object$n.used)
    y_axis <- list(
      startOnTick = FALSE,
      endOnTick = FALSE,
      minPadding = 0.06,
      maxPadding = 0.06,
      tickPositioner = JS(
        "function () {
          return this.tickPositions.filter(function (tick) { return Math.abs(tick) <= 1; });
        }"
      ),
      plotLines = list(
        list(width = 1, value = sv, color = "gray"),
        list(width = 1, value = -sv, color = "gray")
      )
    )
  }

  n <- NCOL(object$acf)
  if (n == 1L) {
    hc <- rlang::exec(hc_yAxis, highchart(), !!!y_axis)
    return(add_acf(hc, as.vector(object$lag), as.vector(object$acf), ytitle))
  }

  pairs <- expand.grid(column = seq_len(n), row = seq_len(n))
  vars <- object$snames
  if (length(vars) != n) {
    vars <- paste("Series", seq_len(n))
  }
  labels <- ifelse(
    pairs$row == pairs$column,
    vars[pairs$row],
    paste(vars[pairs$row], vars[pairs$column], sep = " / ")
  )
  limits <- if (object$type == "covariance") {
    range(0, object$acf, finite = TRUE)
  } else {
    c(-1, 1)
  }
  limits <- grDevices::extendrange(limits, f = 0.03)
  y_axis$min <- limits[1L]
  y_axis$max <- limits[2L]
  x_axes <- lapply(labels, function(label) list(title = list(text = label)))
  hc <- highchart() |>
    hc_gridAxis(n, n, xAxis = x_axes, yAxis = y_axis) |>
    hc_legend(enabled = FALSE)

  for (k in seq_along(labels)) {
    i <- pairs$row[k]
    j <- pairs$column[k]
    x <- object$lag[, i, j]
    y <- object$acf[, i, j]
    order_x <- order(x)
    hc <- add_acf(
      hc,
      x[order_x],
      y[order_x],
      labels[k],
      xAxis = k - 1L,
      yAxis = k - 1L
    )
  }
  hc
}

#' @export
hchart.mts <- function(object, ..., separate = TRUE, heights = 1, sep = 0.01) {
  n <- ncol(object)
  labels <- colnames(object)
  hc <- highchart() |>
    hc_xAxis(type = ts_axis_type(object)) |>
    hc_tooltip(table = TRUE)

  if (separate) {
    labels <- as.character(labels)
    hc <- hc_yAxis(
      hc,
      create_axis(
        n,
        heights = heights,
        sep = sep,
        title = list(text = NULL),
        lineWidth = 2,
        showFirstLabel = FALSE,
        showLastLabel = FALSE
      )
    )
  }

  for (i in seq_len(n)) {
    axis <- if (separate) list(yAxis = i - 1) else list()
    hc <- rlang::exec(
      hc_add_series,
      hc,
      object[, i],
      !!!axis,
      name = labels[i],
      id = labels[i],
      ...
    )
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

  hchart(tss, heights = heights, sep = sep, ...)
}

#' @rdname hchart
#' @export
hchart.decomposed.ts <- function(object, ...) {
  if (NCOL(object$x) != 1L) {
    stop(
      "Decompose each time series separately before plotting.",
      call. = FALSE
    )
  }
  components <- cbind(
    observed = drop(object$x),
    seasonal = drop(object$seasonal),
    trend = drop(object$trend),
    remainder = drop(object$random)
  )
  hchart(components, ...)
}

#' @export
hchart.ets <- function(object, ...) {
  names <- c(y = "observed", l = "level", b = "slope", s1 = "season")

  data <- cbind(
    object$x,
    object$states[, colnames(object$states) %in% names(names)]
  )

  cn <- c("y", c(colnames(object$states)))

  colnames(data) <- cn <- names[stats::na.exclude(match(cn, names(names)))]

  hchart(data, ...) |>
    hc_title(text = paste("Decomposition by", object$method, "method"))
}
