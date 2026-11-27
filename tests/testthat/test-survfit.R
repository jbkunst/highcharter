test_that("Cox curves and bands match each profile within each stratum", {
  skip_if_not_installed("survival", minimum_version = "3.6-5")
  library(survival)
  model <- coxph(Surv(time, status) ~ age + strata(sex), data = lung)
  profiles <- data.frame(age = c(50, 70), row.names = c("Age 50", "Age 70"))
  fit <- survfit(model, newdata = profiles)
  series <- hchart(fit, ranges = TRUE)$x$hc_opts$series
  strata <- rep(names(fit$strata), fit$strata)
  expect_length(series, 8L)

  for (stratum in names(fit$strata)) {
    rows <- strata == stratum
    for (j in seq_len(ncol(fit$surv))) {
      name <- paste(stratum, colnames(fit$surv)[j], sep = " / ")
      i <- match(name, vapply(series, "[[", character(1), "name"))
      points <- series[[i]]$data[-1L]
      band <- series[[i + 1L]]
      expect_equal(vapply(points, "[[", numeric(1), "x"), fit$time[rows])
      expect_equal(vapply(points, "[[", numeric(1), "y"), fit$surv[rows, j])
      expect_identical(
        vapply(points, function(p) !is.null(p$marker), logical(1)),
        fit$n.censor[rows] > 0
      )
      expect_identical(band$linkedTo, ":previous")
      expect_equal(
        do.call(rbind, lapply(band$data, unlist)),
        unname(cbind(fit$time[rows], fit$lower[rows, j], fit$upper[rows, j]))
      )
    }
  }
})

test_that("survival charts accept absent bands and decreasing transformations", {
  skip_if_not_installed("survival", minimum_version = "3.6-5")
  library(survival)
  model <- coxph(Surv(time, status) ~ age, data = lung)
  profiles <- data.frame(age = c(50, 70))
  fit <- survfit(model, newdata = profiles, se.fit = FALSE)
  series <- hchart(fit, ranges = TRUE, markTimes = FALSE)$x$hc_opts$series
  expect_length(series, 2L)
  expect_false(any(vapply(
    series[[1]]$data,
    function(p) !is.null(p$marker),
    logical(1)
  )))

  fit <- survfit(Surv(time, status) ~ 1, data = lung)
  series <- hchart(fit, fun = "event", ranges = TRUE)$x$hc_opts$series
  expect_identical(series[[1]]$name, "Series 1")
  expect_equal(series[[1]]$data[[1]], list(x = 0, y = 0))
  expect_equal(
    do.call(rbind, lapply(series[[2]]$data, unlist)),
    unname(cbind(fit$time, 1 - fit$upper, 1 - fit$lower))
  )
})

test_that("log survival scales keep valid estimates when their bands have gaps", {
  skip_if_not_installed("survival", minimum_version = "3.6-5")
  library(survival)
  d <- data.frame(
    time = c(0:4, 4, 5, 6),
    status = c(0, 0, 1, 1, 1, 0, 1, 1)
  )
  fit <- survfit(Surv(time, status) ~ 1, d, conf.type = "plain", conf.int = 0.8)
  hc <- hchart(fit, fun = "log", ranges = TRUE)$x$hc_opts
  expect_identical(hc$yAxis$type, "logarithmic")
  expect_null(hc$yAxis$min)
  points <- hc$series[[1]]$data
  expect_equal(vapply(points, "[[", numeric(1), "x"), fit$time)
  expect_equal(vapply(points, "[[", numeric(1), "y"), c(head(fit$surv, -1), NA))
  # At time 5, survival is 0.25 and the lower confidence limit is zero.
  expect_equal(unlist(hc$series[[2]]$data[[6]]), c(5, NA, NA))

  hc <- hchart(fit, fun = "cloglog", ranges = TRUE)$x$hc_opts
  expect_identical(hc$xAxis$type, "logarithmic")
  points <- hc$series[[1]]$data
  expect_equal(vapply(points, "[[", numeric(1), "x"), 1:6)
  expect_equal(
    vapply(points, "[[", numeric(1), "y"),
    c(NA, log(-log(fit$surv[3:6])), NA)
  )
  expect_true(points[[4]]$marker$enabled)
  expect_null(points[[4]]$marker$fillColor)
  band <- hc$series[[2]]$data
  expect_equal(vapply(band, "[[", numeric(1), 1L), 1:6)
  expect_equal(unlist(band[[2]]), c(2, NA, NA))
  expect_equal(
    unlist(band[[3]]),
    c(3, log(-log(fit$upper[4])), log(-log(fit$lower[4])))
  )

  fit <- survfit(Surv(time + 1, status) ~ 1, d)
  series <- hchart(fit, fun = "cloglog")$x$hc_opts$series
  expect_equal(vapply(series[[1]]$data, "[[", numeric(1), "x"), fit$time)
})

test_that("logpct survival scale uses a logarithmic percentage y-axis and masks non-positive values", {
  skip_if_not_installed("survival", minimum_version = "3.6-5")
  library(survival)
  d <- data.frame(
    time = c(0:4, 4, 5, 6),
    status = c(0, 0, 1, 1, 1, 0, 1, 1)
  )
  fit <- survfit(Surv(time, status) ~ 1, d, conf.type = "plain", conf.int = 0.8)

  hc <- hchart(fit, fun = "logpct", ranges = TRUE)$x$hc_opts
  expect_identical(hc$yAxis$type, "logarithmic")
  expect_null(hc$yAxis$min)
  expect_equal(hc$yAxis$max, 100)
  points <- hc$series[[1]]$data
  expect_equal(vapply(points, "[[", numeric(1), "x"), fit$time)
  expect_equal(
    vapply(points, "[[", numeric(1), "y"),
    c(100 * head(fit$surv, -1), NA)
  )
  expect_equal(unlist(hc$series[[2]]$data[[6]]), c(5, NA, NA))
  expect_equal(
    unlist(hc$series[[2]]$data[[3]]),
    c(2, 100 * fit$lower[3], 100 * fit$upper[3])
  )

  pct <- hchart(fit, fun = "pct")$x$hc_opts
  expect_null(pct$yAxis$type)
  expect_equal(c(pct$yAxis$min, pct$yAxis$max), c(0, 100))
  expect_equal(
    vapply(pct$series[[1]]$data, "[[", numeric(1), "y"),
    100 * fit$surv
  )
})
