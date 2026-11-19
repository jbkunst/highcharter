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
