#' Chart the out-of-bag error of a random forest
#'
#' Classification forests show overall and per-class error rates as percentages.
#' Regression forests show mean squared error. If the fit stores test errors,
#' dashed lines show the corresponding test series.
#' @param object A supervised `randomForest` fit with an error history.
#' @param ... Highcharts line series options.
#' @return A highchart htmlwidget.
#' @examplesIf requireNamespace("randomForest", quietly = TRUE)
#' set.seed(42)
#' forest <- randomForest::randomForest(Species ~ ., iris, ntree = 150)
#' hchart(forest)
#' @export
hchart.randomForest <- function(object, ...) {
  classification <- identical(object$type, "classification")
  key <- if (classification) "err.rate" else "mse"
  if (
    !object$type %in% c("classification", "regression") ||
      !length(object[[key]])
  ) {
    stop(
      "A supervised forest with a stored error history is required.",
      call. = FALSE
    )
  }
  metric <- if (classification) {
    "Misclassification rate (%)"
  } else {
    "Mean squared error"
  }
  hc <- highchart() |>
    hc_xAxis(title = list(text = "Number of trees"), allowDecimals = FALSE) |>
    hc_yAxis(title = list(text = metric), min = 0) |>
    hc_plotOptions(
      line = utils::modifyList(
        list(pointStart = 1, marker = list(enabled = FALSE)),
        list(...)
      )
    )
  for (sample in c("OOB", "Test")) {
    errors <- if (sample == "OOB") object[[key]] else object$test[[key]]
    if (!length(errors)) {
      next
    }
    errors <- as.matrix(errors)
    if (classification) {
      errors <- 100 * errors
    }
    for (j in seq_len(ncol(errors))) {
      label <- if (j == 1L) {
        sample
      } else {
        paste(sample, colnames(errors)[j], sep = " \u00b7 ")
      }
      hc <- hc_add_series(
        hc,
        type = "line",
        data = as.numeric(errors[, j]),
        name = label,
        lineWidth = if (j == 1L) 3 else 1.5,
        dashStyle = if (sample == "Test") "Dash" else "Solid"
      )
    }
  }
  hc_tooltip(
    hc,
    shared = TRUE,
    table = length(hc$x$hc_opts$series) > 1L,
    valueSuffix = if (classification) "%" else "",
    valueDecimals = 2
  )
}

#' Chart cross-validation for a regularization path
#'
#' Points show the mean cross-validation metric. The whiskers use the
#' stored lower and upper limits (one standard error). Vertical lines mark
#' `lambda.min` and `lambda.1se`. The tooltip includes the untransformed
#' lambda and the number of nonzero coefficients. Applies to standard
#' cross-validation fits (`relax = FALSE`).
#' @param object A `cv.glmnet` fit.
#' @param ... Highcharts scatter series options.
#' @return A highchart htmlwidget.
#' @examplesIf requireNamespace("glmnet", quietly = TRUE)
#' x <- as.matrix(mtcars[c("disp", "hp", "wt", "qsec")])
#' fit <- glmnet::cv.glmnet(x, mtcars$mpg, foldid = rep_len(1:5, nrow(x)))
#' hchart(fit)
#' @export
hchart.cv.glmnet <- function(object, ...) {
  if (inherits(object, "cv.relaxed")) {
    stop(
      "Use a cv.glmnet fit with relax = FALSE; relaxed fits also vary gamma.",
      call. = FALSE
    )
  }
  metric <- unname(object$name)
  rows <- which(is.finite(object$lambda) & object$lambda > 0)
  if (!length(rows)) {
    stop("The log scale needs a positive lambda.", call. = FALSE)
  }
  rows <- rows[order(object$lambda[rows], decreasing = TRUE)]
  points <- data.frame(
    x = -log(object$lambda[rows]),
    y = object$cvm[rows],
    lambda = as.character(signif(object$lambda[rows], 5)),
    nzero = as.integer(object$nzero[rows]),
    low = object$cvlo[rows],
    high = object$cvup[rows]
  )
  chosen <- c(lambda.min = object$lambda.min, lambda.1se = object$lambda.1se)
  chosen <- chosen[chosen %in% object$lambda[rows]]
  lines <- lapply(unique(chosen), function(value) {
    list(
      value = -log(value),
      color = "#777777",
      dashStyle = "ShortDash",
      width = 1,
      label = list(
        text = paste(names(chosen)[chosen == value], collapse = " / ")
      )
    )
  })
  highchart() |>
    hc_xAxis(
      title = list(text = "-log(lambda)"),
      plotLines = lines,
      crosshair = TRUE
    ) |>
    hc_yAxis(title = list(text = metric), crosshair = list(snap = FALSE)) |>
    hc_plotOptions(
      scatter = utils::modifyList(
        list(
          marker = list(enabled = TRUE, radius = 3),
          findNearestPointBy = "x"
        ),
        list(...)
      )
    ) |>
    hc_add_series(
      type = "scatter",
      name = metric,
      data = list_parse(points),
      zIndex = 2,
      tooltip = list(
        headerFormat = "",
        pointFormat = paste0(
          "Lambda: {point.lambda}<br/>",
          htmltools::htmlEscape(metric),
          ": {point.y:.3f}<br/>",
          "\u00b11 SE: {point.low:.3f} \u2013 {point.high:.3f}<br/>",
          "Nonzero coefficients: {point.nzero}"
        )
      )
    ) |>
    hc_add_series(
      type = "errorbar",
      name = "\u00b11 SE",
      linkedTo = ":previous",
      color = "#909090",
      whiskerLength = "55%",
      enableMouseTracking = FALSE,
      data = list_parse2(points[c("x", "low", "high")])
    ) |>
    hc_legend(enabled = FALSE)
}

#' Plot survival curves using Highcharts
#'
#' @param object A survfit object as returned from the \code{survfit} function
#' @param ... Extra parameters to pass to \code{hc_add_series} function
#' @param fun A function or the name of a survival curve transformation.
#' \code{"log"} shows survival probabilities on a logarithmic y-axis.
#' \code{"cloglog"} plots \code{log(-log(S))} against positive time on a
#' logarithmic x-axis. Both modes leave gaps where a curve or its confidence
#' band falls outside the scale's domain. \code{"event"} plots \code{1 - S}
#' and \code{"cumhaz"} plots \code{-log(S)}.
#' @param markTimes Label curves marked at each censoring time? TRUE by default
#' @param symbol Symbol to use as marker (plus sign by default)
#' @param markerColor Color of the marker ("black" by default); use NULL to use
#' the respective color of each series
#' @param ranges Plot interval ranges? FALSE by default
#' @param rangesOpacity Opacity of the interval ranges (0.3 by default)
#'
#' @return Highcharts object to plot survival curves
#'
#' @examplesIf rlang::is_installed("survival", version = "3.6-5")
#' library(survival)
#'
#' # Plot Kaplan-Meier curves
#' leukemia.surv <- survfit(Surv(time, status) ~ x, data = aml)
#' hchart(leukemia.surv)
#'
#' # Plot the cumulative hazard function
#' lsurv2 <- survfit(Surv(time, status) ~ x, aml, type = "fleming")
#' hchart(lsurv2, fun = "cumhaz")
#'
#' # Plot the fit of a Cox proportional hazards regression model
#' fit <- coxph(Surv(futime, fustat) ~ age, data = ovarian)
#' profiles <- data.frame(age = c(50, 70), row.names = c("Age 50", "Age 70"))
#' ovarian.surv <- survfit(fit, newdata = profiles)
#' hchart(ovarian.surv, ranges = TRUE)
#' @export
hchart.survfit <- function(
  object,
  ...,
  fun = NULL,
  markTimes = TRUE,
  symbol = "plus",
  markerColor = "black",
  ranges = FALSE,
  rangesOpacity = 0.3
) {
  rlang::check_installed(
    "survival",
    version = "3.6-5",
    reason = "to chart survival curves."
  )
  data <- summary(object, censored = TRUE, data.frame = TRUE)
  if (is.null(data$surv)) {
    stop("The fit must contain survival probabilities.", call. = FALSE)
  }

  transform_y <- if (is.character(fun)) {
    switch(
      fun,
      log = function(y) replace(y, y <= 0, NA_real_),
      event = function(y) 1 - y,
      cumhaz = function(y) -log(y),
      cloglog = function(y) {
        y[y <= 0 | y >= 1] <- NA_real_
        log(-log(y))
      },
      pct = ,
      logpct = function(y) 100 * y,
      identity
    )
  } else if (is.function(fun)) {
    fun
  } else {
    identity
  }

  first_y <- transform_y(1)
  data$surv <- transform_y(data$surv)
  ranges <- ranges && !is.null(data$lower) && !is.null(data$upper)
  if (ranges) {
    lower <- transform_y(data$lower)
    upper <- transform_y(data$upper)
    data$lower <- pmin(lower, upper)
    data$upper <- pmax(lower, upper)
  }
  # The summary stacks one block of times per column of the survival matrix.
  if (is.matrix(object$surv)) {
    data$.profile <- rep(seq_len(ncol(object$surv)), each = length(object$time))
  }
  if (is.null(object$strata)) {
    data$strata <- NULL
  }
  curves <- dplyr::group_split(
    data,
    dplyr::across(dplyr::any_of(c("strata", ".profile")))
  )
  profile_names <- colnames(object$surv)
  marker <- list(fillColor = markerColor, symbol = symbol, enabled = TRUE)
  log_time <- identical(fun, "cloglog")
  hc <- highchart() |>
    hc_tooltip(shared = TRUE) |>
    hc_plotOptions(
      line = list(marker = list(enabled = FALSE)),
      series = list(states = list(hover = list(enabled = FALSE)))
    )
  if (log_time) {
    hc <- hc_xAxis(hc, type = "logarithmic")
  } else if (identical(fun, "log")) {
    hc <- hc_yAxis(hc, type = "logarithmic", max = 1)
  } else {
    bounds <- if (ranges) c(data$lower, data$upper)
    limits <- range(0, 1, first_y, data$surv, bounds, finite = TRUE)
    hc <- hc_yAxis(hc, min = limits[1L], max = limits[2L])
  }

  for (i in seq_along(curves)) {
    curve <- curves[[i]]
    profile <- curve[[".profile"]][1L]
    if (!is.null(profile_names)) {
      profile <- profile_names[profile]
    }
    label <- c(as.character(curve[["strata"]][1L]), profile)
    name <- if (length(label)) paste(label, collapse = " / ") else "Series 1"

    if (log_time) {
      curve <- curve[curve$time > 0, ]
    }
    df <- data.frame(
      x = curve$time,
      y = curve$surv,
      group = rep(name, nrow(curve))
    )
    df$low <- curve[["lower"]]
    df$up <- curve[["upper"]]
    points <- purrr::pmap(df, list)
    marked <- markTimes & curve$n.censor > 0
    points[marked] <- lapply(points[marked], c, list(marker = marker))
    if (!log_time && !0 %in% curve$time) {
      points <- c(list(list(x = 0, y = first_y)), points)
    }
    color <- JS(sprintf("Highcharts.getOptions().colors[%s]", i - 1L))
    hc <- hc_add_series(
      hc,
      data = points,
      step = "left",
      name = name,
      zIndex = 1,
      color = color,
      ...
    )
    if (ranges) {
      hc <- hc_add_series(
        hc,
        data = Map(list, curve$time, curve$lower, curve$upper),
        step = "left",
        name = "Ranges",
        type = "arearange",
        zIndex = 0,
        linkedTo = ":previous",
        fillOpacity = rangesOpacity,
        lineWidth = 0,
        color = color,
        ...
      )
    }
  }
  hc
}
