test_that("forecast charts distinguish observations, predictions and intervals", {
  skip_if_not_installed("forecast")
  model <- forecast::forecast(
    forecast::ets(AirPassengers),
    h = 6,
    level = c(80, 95)
  )
  chart <- hchart(model)
  series <- chart$x$hc_opts$series
  expect_identical(series[[1]]$name, "Observed")
  expect_match(series[[2]]$name, "^Forecast: ")
  expect_identical(series[[3]]$linkedTo, series[[2]]$id)
  expect_match(series[[3]]$name, "80% interval", fixed = TRUE)
  expect_match(series[[4]]$name, "95% interval", fixed = TRUE)
  named <- hchart(model, name = "Passengers")$x$hc_opts$series
  expect_identical(named[[1]]$name, "Passengers observed")
  expect_identical(named[[2]]$name, "Passengers forecast")
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
