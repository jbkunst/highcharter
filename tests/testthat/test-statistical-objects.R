test_that("PCA scales each selected component and keeps the variable directions", {
  for (fit in list(
    prcomp(USArrests, scale. = TRUE),
    princomp(USArrests, cor = TRUE)
  )) {
    scores <- if (inherits(fit, "prcomp")) fit$x else fit$scores
    vectors <- if (inherits(fit, "prcomp")) fit$rotation else fit$loadings
    choices <- c(3L, 1L)
    options <- hchart(fit, choices = choices)$x$hc_opts
    observed <- options$series[[1]]$data

    for (j in 1:2) {
      column <- choices[j]
      expected <- scores[, column] / (fit$sdev[column] * sqrt(nrow(scores)))
      values <- vapply(observed, "[[", numeric(1), c("x", "y")[j])
      expect_equal(values, unname(expected))
    }
    expect_identical(observed[[1]]$name, "Alabama")
    expect_match(options$xAxis$title$text, "8.91%", fixed = TRUE)
    expect_match(options$yAxis$title$text, "62.01%", fixed = TRUE)
    expect_false(options$series[[1]]$dataLabels$enabled)
    expect_length(options$annotations, 0)

    raw <- hchart(
      fit,
      choices = choices,
      scale = 0,
      label = TRUE,
      loadings = TRUE
    )$x$hc_opts
    expect_equal(raw$series[[1]]$data[[1]]$x, unname(scores[1, 3]))
    expect_true(raw$series[[1]]$dataLabels$enabled)
    annotation <- raw$annotations[[1]]
    expect_identical(
      lapply(annotation$labels, `[[`, "point"),
      lapply(annotation$shapes, function(shape) shape$points[[2]])
    )
    tips <- t(vapply(
      annotation$shapes,
      function(s) unlist(s$points[[2]][c("x", "y")]),
      numeric(2)
    ))
    expected <- vectors[, choices] *
      (0.8 *
        min(
          apply(abs(scores[, choices]), 2, max) /
            apply(abs(vectors[, choices]), 2, max)
        ))
    expect_equal(unname(tips), unname(expected))
    expect_identical(
      vapply(annotation$labels, "[[", "", "text"),
      rownames(vectors)
    )
  }

  unnamed <- prcomp(unname(as.matrix(USArrests)))
  annotation <- hchart(unnamed, loadings = TRUE)$x$hc_opts$annotations[[1]]
  expect_length(annotation$shapes, ncol(USArrests))
  expect_length(annotation$labels, 0)

  expect_error(hchart(prcomp(USArrests, retx = FALSE)), "observation scores")
  expect_error(hchart(prcomp(USArrests, rank. = 1)), "two distinct")
})

test_that("classical decomposition retains the time index and gaps in each panel", {
  for (type in c("additive", "multiplicative")) {
    fit <- stats::decompose(AirPassengers, type = type)
    opts <- hchart(fit)$x$hc_opts
    expect_identical(
      vapply(opts$series, "[[", "", "name"),
      c("observed", "seasonal", "trend", "remainder")
    )
    expect_equal(vapply(opts$series, "[[", numeric(1), "yAxis"), 0:3)
    expect_length(opts$yAxis, 4L)
    expect_identical(opts$xAxis$type, "datetime")
    for (j in 1:4) {
      series <- opts$series[[j]]$data
      expected <- fit[[c("x", "seasonal", "trend", "random")[j]]]
      expect_equal(vapply(series, "[[", numeric(1), 2), as.numeric(expected))
      expect_equal(
        vapply(series, "[[", numeric(1), 1),
        datetime_to_timestamp(zoo::as.Date(expected))
      )
    }
  }
  cycle <- ts(seq_len(35), frequency = 7)
  opts <- hchart(stats::decompose(cycle))$x$hc_opts
  expect_identical(opts$xAxis$type, "linear")
  expect_equal(
    vapply(opts$series[[1]]$data, "[[", numeric(1), 1),
    as.numeric(time(cycle))
  )
})

test_that("causal impact keeps the model index and puts each interval on its effect axis", {
  values <- cbind(
    response = c(8, 12, 19),
    point.pred = c(8, 11, 14),
    point.effect = c(0, 1, 5),
    cum.effect = c(NA, 1, 6)
  )
  estimates <- values[, -1, drop = FALSE]
  bounds <- cbind(estimates - 1, estimates + 2)
  colnames(bounds) <- c(
    paste0(colnames(estimates), ".lower"),
    paste0(colnames(estimates), ".upper")
  )
  for (index in list(c(1, 3, 7), as.Date("2025-01-01") + c(0, 2, 6))) {
    fit <- structure(
      list(
        series = zoo::zoo(cbind(values, bounds), index),
        model = list(post.period = index[2:3])
      ),
      class = "CausalImpact"
    )
    opts <- hchart(fit)$x$hc_opts
    x <- if (inherits(index, "Date")) datetime_to_timestamp(index) else index
    expect_equal(opts$xAxis$plotLines[[1]]$value, x[2])
    expect_length(opts$yAxis, 3)
    expect_length(opts$series, 7)
    for (i in seq_len(ncol(estimates))) {
      line <- opts$series[[2 * i]]
      band <- opts$series[[2 * i + 1]]
      expect_equal(line$yAxis, i - 1L)
      expect_equal(band$yAxis, line$yAxis)
      expect_identical(band$type, "arearange")
      expect_equal(vapply(line$data, "[[", numeric(1), 2), estimates[, i])
      expect_equal(band$data, list_parse2(data.frame(x, bounds[, c(i, i + 3)])))
    }
  }
})
