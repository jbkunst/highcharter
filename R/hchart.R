#' Create a highchart object from a particular data type
#'
#' \code{hchart} uses `highchart` to draw a particular plot for an
#' object of a particular class in a single command. This defines the S3
#' generic that other classes and packages can extend.
#'
#' Run \code{methods(hchart)} to see what objects are supported.
#' Numeric matrices use a heatmap by default. Set `type = "tilemap"` for
#' hexagonal tiles or `type = "contour"` for contour lines.
#' Empirical distributions from [stats::ecdf()] use `step = "left"` to show jumps at observations.
#' Pass `step = FALSE` to restore ordinary line interpolation.
#' Matrix heatmaps put row one at the top. Use `hc_yAxis(reversed = FALSE)`
#' to restore the usual axis direction. A matrix with negative values and all
#' entries between -1 and 1 gets a diverging color scale spanning that interval.
#' Use `hc_colorAxis()` to supply different limits and color stops.
#' One-way tables use columns in category order. Two-way tables use the
#' matrix heatmap. Use `margin.table()` to choose dimensions of a larger table.
#'
#' For a GeoJSON FeatureCollection from \pkg{geojsonio}, each geometry
#' family gets its own layer. Supply `type` to select one layer explicitly.
#'
#' @param object  A R object.
#' @param ... Additional arguments for the data series
#'    (\url{https://api.highcharts.com/highcharts/series}).
#'
#' @order 1
#' @seealso [hchart.constparty()] and [hchart.xgb.Booster()] for decision trees,
#'   [hchart.randomForest()] and [hchart.cv.glmnet()] for model diagnostics,
#'   and [hchart.hclust()] for dendrograms and phylogenies.
#' @examples
#' methods(hchart)
#'
#' # Principal component analysis
#' fit <- stats::prcomp(USArrests, scale. = TRUE)
#' hchart(fit)
#'
#' @examplesIf requireNamespace("partykit", quietly = TRUE)
#' # Classification tree: each donut shows the species proportions in a node
#' tree <- partykit::ctree(Species ~ Petal.Length + Petal.Width, data = iris)
#' hchart(tree)
#'
#' @examplesIf requireNamespace("igraph", quietly = TRUE)
#' # An igraph network
#' net <- igraph::make_graph("Zachary")
#' hchart(net, layout = igraph::layout_with_kk)
#' @export
hchart <- function(object, ...) {
  UseMethod("hchart")
}

#' @export
hchart.default <- function(object, ...) {
  stop(
    "Objects of class/type ",
    paste(class(object), collapse = "/"),
    " are not supported by hchart (yet).",
    call. = FALSE
  )
}

#' @export
hchart.list <- function(object, ...) {
  highchart() |>
    hc_add_series(data = object, ...)
}

#' @export
hchart.geo_json <- function(object, ...) {
  highchart(type = "map") |>
    hc_add_series(data = object, ...)
}

#' @export
hchart.geo_list <- hchart.geo_json

#' @export
hchart.data.frame <- function(object, type = NULL, mapping = hcaes(), ...) {
  check_removed_fast(...)
  object <- as.data.frame(object)

  data <- mutate_mapping(object, mapping)

  series <- data_to_series(data, mapping, type = type, ...)

  opts <- data_to_options(data, type)

  hc <- highchart(type = if (identical(type, "gantt")) "gantt" else "chart")

  if (opts$add_colorAxis) {
    hc <- hc_colorAxis(hc, auxpar = NULL)
  }

  hc |>
    hc_add_series_list(series) |>
    hc_xAxis(
      type = opts$xAxis_type,
      title = list(
        text = if (has_name(mapping, "x")) rlang::as_label(mapping$x)
      ),
      categories = opts$xAxis_categories
    ) |>
    hc_yAxis(
      type = opts$yAxis_type,
      title = list(
        text = if (has_name(mapping, "y")) rlang::as_label(mapping$y)
      ),
      categories = opts$yAxis_categories
    ) |>
    hc_plotOptions(scatter = list(marker = list(symbol = "circle")))
}

#' @importFrom graphics hist
#' @export
hchart.numeric <- function(object, breaks = "FD", ...) {
  h <- hist(object, plot = FALSE, breaks = breaks)

  hchart.histogram(h, ...)
}

#' @export
hchart.ecdf <- function(object, type = "line", ..., step = "left") {
  x <- stats::knots(object)
  x <- x[is.finite(x)]
  if (!length(x)) {
    stop(
      "An empirical distribution needs a finite x value to plot.",
      call. = FALSE
    )
  }
  # Extend both tails so the first and last jumps are visible.
  bounds <- range(x)
  pad <- if (length(x) == 1L) max(1, abs(x)) / 20 else diff(bounds / 20)
  x <- c(bounds[1L] - pad, x, bounds[2L] + pad)
  x <- unique(x[is.finite(x)])

  hchart(data.frame(x = x, y = object(x)), type, step = step, ...) |>
    hc_yAxis(min = 0, max = 1, title = list(text = "F(x)"))
}

#' @export
hchart.histogram <- function(object, ..., type = "column") {
  breaks <- object$breaks
  left <- breaks[-length(breaks)]
  right <- breaks[-1L]
  df <- data.frame(
    x = object$mids,
    y = object$counts,
    name = sprintf("%s \u2013 %s", left, right)
  )

  hc <- highchart()
  point_range <- right[1L] - left[1L]
  if (
    identical(type, "variwide") ||
      (identical(type, "column") && !isTRUE(object$equidist))
  ) {
    type <- "variwide"
    df$x <- left
    df$z <- right - left
    point_range <- 0
    hc <- hc_xAxis(hc, softMax = max(right))
  }

  hc |>
    hc_chart(zoomType = "x") |>
    hc_plotOptions(
      column = list(borderRadius = 0),
      variwide = list(borderRadius = 0)
    ) |>
    hc_tooltip(
      formatter = JS(
        "function() { return  this.point.name + '<br/>' + this.y; }"
      )
    ) |>
    hc_add_series(
      data = list_parse(df),
      type = type,
      pointRange = point_range,
      groupPadding = 0,
      pointPadding = 0,
      borderWidth = 0,
      ...
    )
}

#' @export
hchart.character <- function(object, type = "column", ...) {
  highchart() |>
    hc_xAxis(type = "category") |>
    hc_add_series(data = object, type = type, ...)
}

#' @export
hchart.factor <- hchart.character

#' @export
hchart.table <- function(
  object,
  type = if (is.matrix(object)) "heatmap" else "column",
  ...
) {
  if (length(dim(object)) > 2L) {
    stop(
      "Choose one or two dimensions with margin.table() before calling hchart().",
      call. = FALSE
    )
  }
  dimnames(object) <- lapply(dimnames(object), function(x) {
    replace(x, is.na(x), "(NA)")
  })
  titles <- names(dimnames(object))
  hc <- if (is.matrix(object)) {
    hchart.matrix(unclass(object), type = type, ...) |>
      hc_xAxis(title = list(text = titles[2L])) |>
      hc_yAxis(title = list(text = titles[1L]))
  } else {
    highchart() |>
      hc_xAxis(
        categories = dimnames(object)[[1L]],
        title = list(text = titles[1L])
      ) |>
      hc_add_series(data = as.numeric(object), type = type, ...)
  }
  if (all(object == trunc(object), na.rm = TRUE)) {
    hc <- hc_tooltip(hc, valueDecimals = 0)
  }
  hc
}

#' @importFrom rlang .data
#' @export
hchart.matrix <- function(
  object,
  label = FALSE,
  showInLegend = FALSE,
  ...,
  type = c("heatmap", "tilemap", "contour")
) {
  type <- match.arg(type)
  stopifnot(is.numeric(object))

  row_labels <- rownames(object)
  col_labels <- colnames(object)
  has_labels <- !is.null(row_labels) || !is.null(col_labels)
  rows <- seq_len(nrow(object))
  cols <- seq_len(ncol(object))
  if (is.null(row_labels)) {
    row_labels <- as.character(rows)
  }
  if (is.null(col_labels)) {
    col_labels <- as.character(cols)
  }

  # Matrices are stored column by column. Category axes start at zero.
  row_index <- rep(rows, times = ncol(object))
  col_index <- rep(cols, each = nrow(object))
  points <- data.frame(
    x = col_index - has_labels,
    y = row_index - has_labels,
    value = as.vector(object),
    name = paste(col_labels[col_index], row_labels[row_index], sep = " ~ ")
  )

  hc <- highchart() |>
    hc_add_series(data = list_parse(points), type = type, ...) |>
    hc_plotOptions(
      series = list(
        showInLegend = showInLegend,
        dataLabels = list(enabled = label)
      )
    ) |>
    hc_tooltip(
      headerFormat = "",
      pointFormat = "{point.name}: {point.value}",
      valueDecimals = 2
    ) |>
    hc_legend(enabled = TRUE) |>
    hc_colorAxis(visible = TRUE)

  if (!has_labels) {
    axis <- list(
      visible = FALSE,
      minPadding = 0,
      maxPadding = 0,
      startOnTick = FALSE,
      endOnTick = FALSE
    )
    hc <- rlang::exec(hc_xAxis, hc, !!!axis)
    hc <- rlang::exec(hc_yAxis, hc, !!!axis, reversed = TRUE)
  } else {
    hc <- hc |>
      hc_xAxis(
        categories = col_labels,
        title = list(text = ""),
        opposite = TRUE
      ) |>
      hc_yAxis(
        categories = row_labels,
        title = list(text = ""),
        reversed = TRUE
      )
  }

  # correlogram
  if (any(object < 0, na.rm = TRUE) && all(abs(object) <= 1, na.rm = TRUE)) {
    hc <- hc_colorAxis(
      hc,
      stops = color_stops(3, c("#FF5733", "#F8F5F5", "#2E86C1")),
      min = -1,
      max = 1
    )
  }

  hc
}

#' @export
hchart.dist <- function(object, ...) {
  hchart.matrix(as.matrix(object), ...)
}

#' @importFrom rlang .data
#' @export
hchart.density <- function(object, type = "area", ...) {
  hc_add_series(highchart(), data = object, type = type, ...)
}

hchart_pca <- function(
  scores,
  vectors,
  sdev,
  choices,
  scale,
  loadings,
  label,
  ...
) {
  if (is.null(scores)) {
    stop("Fit the PCA with observation scores to plot it.", call. = FALSE)
  }
  if (
    !is.numeric(choices) ||
      length(choices) != 2L ||
      anyDuplicated(choices) ||
      !all(choices %in% seq_len(ncol(scores)))
  ) {
    stop(
      "Select two distinct component numbers present in the PCA.",
      call. = FALSE
    )
  }
  if (
    !is.numeric(scale) ||
      length(scale) != 1L ||
      !is.finite(scale) ||
      scale < 0 ||
      scale > 1
  ) {
    stop("Use a scale between 0 and 1.", call. = FALSE)
  }

  xy <- scores[, choices, drop = FALSE]
  axes <- colnames(xy)
  factors <- (sdev[choices] * sqrt(nrow(xy)))^scale
  factors[factors == 0] <- 1
  xy <- sweep(xy, 2L, factors, "/")
  if (sum(sdev^2) > 0) {
    percent <- round(100 * sdev[choices]^2 / sum(sdev^2), 2)
    axes <- paste0(axes, " (", percent, "%)")
  }
  observations <- rownames(xy)
  if (is.null(observations)) {
    observations <- as.character(seq_len(nrow(xy)))
  }
  points <- data.frame(
    name = observations,
    x = xy[, 1L],
    y = xy[, 2L],
    row.names = NULL
  )

  hc <- highchart() |>
    hc_xAxis(title = list(text = axes[1L])) |>
    hc_yAxis(title = list(text = axes[2L])) |>
    hc_plotOptions(
      scatter = list(tooltip = list(headerFormat = "<b>{point.name}</b><br/>"))
    ) |>
    hc_add_series(
      data = list_parse(points),
      type = "scatter",
      name = "Observations",
      dataLabels = list(enabled = label, format = "{point.name}"),
      ...
    )
  if (!loadings) {
    return(hc)
  }

  # One common multiplier keeps the directions of the loading vectors.
  ends <- vectors[, choices, drop = FALSE]
  max_loading <- apply(abs(ends), 2L, max)
  used <- max_loading > 0
  if (!any(used)) {
    return(hc)
  }
  extent <- apply(abs(xy), 2L, max)
  ends <- ends * (0.8 * min(extent[used] / max_loading[used]))
  origin <- list(xAxis = 0L, yAxis = 0L, x = 0, y = 0)
  tips <- data.frame(x = ends[, 1L], y = ends[, 2L], row.names = NULL)
  points <- list_parse(transform(tips, xAxis = 0, yAxis = 0))
  shapes <- lapply(points, function(point) {
    list(type = "path", markerEnd = "arrow", points = list(origin, point))
  })
  labels <- list()
  if (!is.null(rownames(ends))) {
    tips$text <- rownames(ends)
    labels <- data_to_annotation_labels(tips)
  }
  hc_add_annotation(hc, draggable = "", shapes = shapes, labels = labels)
}

#' @rdname hchart
#' @param choices Two component numbers to plot on the x and y axes.
#' @param scale PCA score scaling exponent between 0 and 1. Zero plots raw scores.
#' @param loadings Draw and name the variable loading vectors on the PCA plot.
#' @param label Display observation names on PCA points.
#' @export
hchart.prcomp <- function(
  object,
  ...,
  choices = 1:2,
  scale = 1,
  loadings = FALSE,
  label = FALSE
) {
  hchart_pca(
    object$x,
    object$rotation,
    object$sdev,
    choices,
    scale,
    loadings,
    label,
    ...
  )
}

#' @rdname hchart
#' @export
hchart.princomp <- function(
  object,
  ...,
  choices = 1:2,
  scale = 1,
  loadings = FALSE,
  label = FALSE
) {
  hchart_pca(
    object$scores,
    object$loadings,
    object$sdev,
    choices,
    scale,
    loadings,
    label,
    ...
  )
}
