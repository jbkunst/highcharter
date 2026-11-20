test_that("forecast charts distinguish observations, predictions and intervals", {
  skip_if_not_installed("forecast")
  model <- forecast::forecast(
    forecast::ets(AirPassengers),
    h = 6,
    level = c(80, 95)
  )
  seed <- .GlobalEnv$.Random.seed
  chart <- hchart(model)
  expect_identical(.GlobalEnv$.Random.seed, seed)
  series <- chart$x$hc_opts$series
  expect_identical(series[[1]]$name, "Observed")
  expect_match(series[[2]]$name, "^Forecast: ")
  expect_identical(series[[3]]$linkedTo, series[[2]]$id)
  expect_match(series[[3]]$name, "80% interval", fixed = TRUE)
  expect_match(series[[4]]$name, "95% interval", fixed = TRUE)
  named <- hchart(model, name = "Passengers")$x$hc_opts$series
  expect_identical(named[[1]]$name, "Passengers observed")
  expect_identical(named[[2]]$name, "Passengers forecast")
  expect_false(identical(named[[2]]$id, series[[2]]$id))
  forecast_only <- highchart() |> hc_add_series(model, name = "Passengers")
  expect_identical(
    forecast_only$x$hc_opts$series[[1]]$name,
    "Passengers forecast"
  )
})

test_that("forecasts and all prediction intervals use the same time index", {
  skip_if_not_installed("forecast")
  x <- ts(1:35, start = 2020, frequency = 7)
  model <- forecast::naive(x, h = 3, level = c(80, 95))
  expected <- as.numeric(time(model$mean))

  for (levels in c(FALSE, TRUE)) {
    opts <- hchart(model, addOriginal = FALSE, addLevels = levels)$x$hc_opts
    expect_identical(opts$xAxis$type, "linear")
    expect_length(opts$series, if (levels) 3L else 1L)
    for (series in opts$series) {
      expect_equal(vapply(series$data, `[[`, numeric(1), 1L), expected)
    }
  }
})

test_that("multivariate forecasts preserve panels, legend groups and interval bounds", {
  skip_if_not_installed("forecast")
  x <- cbind(mdeaths, fdeaths)
  fit <- forecast::forecast(x, h = 3, level = c(80, 95))
  for (separate in c(TRUE, FALSE)) {
    opts <- hchart(fit, separate = separate)$x$hc_opts
    series <- opts$series
    names(series) <- vapply(series, `[[`, "", "name")
    expect_identical(series[["forecasts"]]$id, "forecasts")
    for (i in seq_along(fit$forecast)) {
      name <- colnames(x)[i]
      f <- fit$forecast[[i]]
      mean <- series[[paste("forecast", name)]]
      expect_identical(mean$linkedTo, "forecasts")
      expect_equal(mean$yAxis, if (separate) i - 1 else NULL)
      for (j in seq_along(f$level)) {
        group <- paste("level", f$level[j])
        band <- series[[paste(group, name)]]
        expect_identical(band$linkedTo, series[[group]]$id)
        expect_identical(band$yAxis, mean$yAxis)
        expect_equal(
          band$data,
          Map(
            list,
            ts_x_values(f$mean),
            as.numeric(f$lower[, j]),
            as.numeric(f$upper[, j])
          )
        )
      }
    }
  }

  legacy <- structure(
    list(
      x = x,
      level = fit$forecast[[1]]$level,
      mean = lapply(fit$forecast, `[[`, "mean"),
      lower = lapply(fit$forecast, `[[`, "lower"),
      upper = lapply(fit$forecast, `[[`, "upper")
    ),
    class = "mforecast"
  )
  expect_equal(hchart(legacy)$x$hc_opts, hchart(fit)$x$hc_opts)
})
