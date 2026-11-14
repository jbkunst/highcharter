test_that("PCA scales each selected component and keeps the variable directions", {
  for (fit in list(prcomp(USArrests, scale. = TRUE), princomp(USArrests, cor = TRUE))) {
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

    raw <- hchart(fit, choices = choices, scale = 0, label = TRUE, loadings = TRUE)$x$hc_opts
    expect_equal(raw$series[[1]]$data[[1]]$x, unname(scores[1, 3]))
    expect_true(raw$series[[1]]$dataLabels$enabled)
    annotation <- raw$annotations[[1]]
    tips <- t(vapply(annotation$shapes, function(s) unlist(s$points[[2]][c("x","y")]), numeric(2)))
    expected <- vectors[, choices] * (0.8 * min(apply(abs(scores[, choices]), 2, max) /
                                                  apply(abs(vectors[, choices]), 2, max)))
    expect_equal(unname(tips), unname(expected))
    expect_identical(vapply(annotation$labels, "[[", "", "text"), rownames(vectors))
  }

  expect_error(hchart(prcomp(USArrests, retx = FALSE)), "observation scores")
  expect_error(hchart(prcomp(USArrests, rank. = 1)), "two distinct")
})

test_that("classical decomposition retains the time index and gaps in each panel", {
  for (type in c("additive", "multiplicative")) {
    fit <- stats::decompose(AirPassengers, type = type)
    opts <- hchart(fit)$x$hc_opts
    expect_identical(vapply(opts$series, "[[", "", "name"), c("observed", "seasonal", "trend", "remainder"))
    expect_equal(vapply(opts$series, "[[", numeric(1), "yAxis"), 0:3)
    expect_length(opts$yAxis, 4L)
    expect_identical(opts$xAxis$type, "datetime")
    for (j in 1:4) {
      series <- opts$series[[j]]$data
      expected <- fit[[c("x", "seasonal", "trend", "random")[j]]]
      expect_equal(vapply(series, "[[", numeric(1), 2), as.numeric(expected))
      expect_equal(vapply(series, "[[", numeric(1), 1), datetime_to_timestamp(zoo::as.Date(expected)))
    }
  }
  cycle <- ts(seq_len(35), frequency = 7)
  opts <- hchart(stats::decompose(cycle))$x$hc_opts
  expect_identical(opts$xAxis$type, "linear")
  expect_equal(vapply(opts$series[[1]]$data, "[[", numeric(1), 1), as.numeric(time(cycle)))
})
