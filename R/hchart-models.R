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
    hc_tooltip(
      shared = TRUE,
      valueSuffix = if (classification) "%" else "",
      valueDecimals = 2
    ) |>
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
  hc
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
    hc_xAxis(title = list(text = "-log(lambda)"), plotLines = lines) |>
    hc_yAxis(title = list(text = metric)) |>
    hc_plotOptions(
      scatter = utils::modifyList(
        list(marker = list(enabled = TRUE, radius = 3)),
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

#' Explore one boosted tree
#'
#' Select one tree by its one-based index. Marker area represents cover,
#' with a minimum radius for interaction. Internal nodes report split gain
#' and the branch for missing values. Leaves report their contribution to
#' the prediction margin. Supports tree boosters with numeric splits.
#' @param object An `xgb.Booster` fit.
#' @param tree A positive tree index, starting at one.
#' @param ... Highcharts treegraph series options.
#' @return A highchart htmlwidget.
#' @examplesIf rlang::is_installed("xgboost", version = "3.1.0")
#' d <- xgboost::xgb.DMatrix(as.matrix(iris[1:4]), label = iris$Petal.Width)
#' fit <- xgboost::xgb.train(
#'   list(objective = "reg:squarederror", max_depth = 2L, nthread = 1L),
#'   d, nrounds = 3L, verbose = 0
#' )
#' hchart(fit, tree = 2)
#' @export
hchart.xgb.Booster <- function(object, ..., tree = 1L) {
  rlang::check_installed(
    "xgboost",
    version = "3.1.0",
    reason = "to extract a tree."
  )
  if (
    !is.numeric(tree) ||
      length(tree) != 1L ||
      !is.finite(tree) ||
      tree < 1 ||
      tree != trunc(tree)
  ) {
    stop("Choose one positive integer tree index.", call. = FALSE)
  }
  nodes <- xgboost::xgb.model.dt.tree(model = object, trees = tree)
  if (!nrow(nodes)) {
    stop("Tree index exceeds the number of fitted trees.", call. = FALSE)
  }
  yes <- match(nodes$ID, nodes$Yes)
  no <- match(nodes$ID, nodes$No)
  parent <- ifelse(is.na(yes), no, yes)
  leaf <- is.na(nodes$Yes)
  feature <- htmltools::htmlEscape(nodes$Feature)
  threshold <- as.character(signif(nodes$Split[parent], 6))
  rule <- ifelse(
    is.na(parent),
    "",
    paste(ifelse(is.na(yes), "\u2265", "&lt;"), threshold)
  )
  score <- as.character(signif(nodes$Gain, 5))
  info <- ifelse(
    leaf,
    paste("Leaf contribution:", score),
    paste0(
      feature,
      " &lt; ",
      signif(nodes$Split, 6),
      "<br/>Gain: ",
      score,
      "<br/>Missing follows: ",
      ifelse(nodes$Missing == nodes$Yes, "Yes", "No")
    )
  )
  radius <- pmax(
    4,
    16 * sqrt(nodes$Cover / max(nodes$Cover, .Machine$double.eps))
  )
  data <- lapply(seq_len(nrow(nodes)), function(i) {
    point <- list(
      id = nodes$ID[i],
      name = if (leaf[i]) score[i] else feature[i],
      marker = list(radius = radius[i]),
      custom = list(
        label = if (leaf[i]) score[i] else "",
        rule = rule[i],
        cover = nodes$Cover[i],
        detail = info[i]
      )
    )
    if (!is.na(parent[i])) {
      point$parent <- nodes$ID[parent[i]]
    }
    point
  })
  highchart() |>
    hc_chart(inverted = TRUE, spacingLeft = 26, spacingRight = 26) |>
    hc_plotOptions(
      treegraph = utils::modifyList(
        list(
          link = list(type = "straight", color = "#8C8C8C"),
          marker = list(
            fillColor = "#D4E7E5",
            lineColor = "#4E7778",
            lineWidth = 1
          ),
          dataLabels = list(
            enabled = TRUE,
            allowOverlap = TRUE,
            crop = FALSE,
            overflow = "allow",
            pointFormat = "{point.custom.label}",
            linkFormat = "{point.fromNode.name}<br/>{point.toNode.custom.rule}",
            linkTextPath = list(enabled = FALSE),
            style = list(
              color = "#333333",
              fontWeight = "normal",
              textOutline = "2px #FFFFFF"
            )
          ),
          tooltip = list(
            headerFormat = "",
            pointFormat = "{point.custom.detail}<br/>Cover: {point.custom.cover:.2f}",
            linkFormat = "{point.toNode.custom.detail}<br/>Cover: {point.toNode.custom.cover:.2f}"
          )
        ),
        list(...)
      )
    ) |>
    hc_add_series(type = "treegraph", name = paste("Tree", tree), data = data)
}
