#' Add a fitted model series (deprecated)
#'
#' Passing an `lm` or `loess` object to [hc_add_series()] is deprecated.
#' Use [stats::predict()] to prepare a data frame, then add the fitted values
#' as a line and the interval bounds as an arearange. See the
#' [worked example](https://jkunst.com/highcharter/articles/first-steps.html#a-more-advanced-example).
#' The model methods use the fitted value plus or minus two standard errors.
#'
#' @param hc A `highchart` `htmlwidget` object.
#' @param data A \code{lm} or \code{loess} object.
#' @param type The type of the series: line, spline.
#' @param color Color of the fitted line.
#' @param fillOpacity Opacity of the interval band.
#' @param ... Arguments defined in
#'   \url{https://api.highcharts.com/highcharts/chart}.
#' @importFrom rlang .data
#' @export
hc_add_series.lm <- function(
  hc,
  data,
  type = "line",
  color = "#5F83EE",
  fillOpacity = 0.1,
  ...
) {
  .Deprecated(
    msg = paste(
      "Passing an lm or loess object to hc_add_series() is deprecated.",
      "Use predict() and pass the predictions to hc_add_series() as a data frame."
    )
  )
  if (inherits(data, "loess")) {
    x <- data$x[, 1L]
    prediction <- stats::predict(data, se = TRUE)
  } else {
    frame <- stats::model.frame(data)
    if (!length(attr(stats::terms(data), "term.labels"))) {
      stop("A model with a predictor is required.", call. = FALSE)
    }
    x <- frame[[2L]]
    prediction <- stats::predict(data, se.fit = TRUE)
    # predict.lm restores excluded rows, while the model frame omits them.
    if (
      inherits(data$na.action, "exclude") && NROW(prediction$fit) != NROW(x)
    ) {
      prediction$fit <- prediction$fit[-data$na.action]
      prediction$se.fit <- prediction$se.fit[-data$na.action]
    }
  }
  if (NCOL(x) > 1L || NCOL(prediction$fit) > 1L) {
    stop(
      "The fitted series requires one response and a one-dimensional x axis.",
      call. = FALSE
    )
  }
  points <- data.frame(
    x = drop(x),
    fit = as.vector(prediction$fit),
    se = as.vector(prediction$se.fit)
  )
  points <- points[order(points$x), , drop = FALSE]

  rid <- basename(tempfile("hc-"))

  hc |>
    hc_add_series(
      points,
      type = type,
      hcaes(x = x, y = .data$fit),
      id = rid,
      color = color,
      ...
    ) |>
    hc_add_series(
      points,
      type = "arearange",
      hcaes(
        x = x,
        low = .data$fit - 2 * .data$se,
        high = .data$fit + 2 * .data$se
      ),
      color = hex_to_rgba(color, fillOpacity),
      linkedTo = rid,
      zIndex = -2,
      ...
    )
}

#' @rdname hc_add_series.lm
#' @export
hc_add_series.loess <- hc_add_series.lm

#' Compatibility alias for multiple y axes
#'
#' @inheritParams hc_yAxis
#' @export
hc_yAxis_multiples <- function(hc, ...) {
  .Deprecated("hc_yAxis")
  hc_yAxis(hc, ...)
}
