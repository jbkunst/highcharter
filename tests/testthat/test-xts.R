test_that("ordinary xts columns retain their names, dates and missing values", {
  skip_if_not_installed("xts")
  dates <- as.POSIXct("2025-01-01 09:00", tz = "UTC") + c(0, 300, 600)
  quotes <- xts::xts(
    cbind(A.Close = c(42, 45, 44), B.Close = c(30, NA, 32)),
    dates
  )
  series <- hchart(quotes, id = c("a", "b"))$x$hc_opts$series
  expect_identical(vapply(series, "[[", "", "type"), c("line", "line"))
  expect_identical(vapply(series, "[[", "", "name"), colnames(quotes))
  expect_identical(vapply(series, "[[", "", "id"), c("a", "b"))
  for (i in seq_along(series)) {
    expect_equal(
      series[[i]]$data,
      Map(list, datetime_to_timestamp(dates), as.vector(quotes[, i]))
    )
  }

  chart <- highchart(type = "stock") |>
    hc_add_series(data = 1:3) |>
    hc_add_series(quotes, type = "column", name = c("First", "Second"))
  expect_length(chart$x$hc_opts$series, 3)
  expect_identical(chart$x$hc_opts$series[[3]]$type, "column")
  expect_identical(chart$x$hc_opts$series[[3]]$name, "Second")
  expect_error(hchart(quotes, id = "shared"), "one distinct series ID")
  expect_error(hchart(quotes, id = c("a", "a")), "one distinct series ID")
})

test_that("one instrument contributes four ordered prices even with extra columns", {
  skip_if_not_installed("xts")
  skip_if_not_installed("quantmod")
  dates <- as.Date("2025-01-01") + 0:2
  prices <- xts::xts(
    cbind(
      Volume = 100:102,
      Close = 5:7,
      High = 6:8,
      Adjusted = 5:7,
      Low = 3:5,
      Open = 4:6
    ),
    dates
  )
  colnames(prices) <- paste("BRK-B", colnames(prices), sep = ".")
  series <- hchart(prices)$x$hc_opts$series
  expect_length(series, 1)
  expect_identical(series[[1]]$type, "candlestick")
  expect_identical(series[[1]]$name, "BRK-B")
  expect_equal(
    series[[1]]$data,
    Map(list, datetime_to_timestamp(dates), 4:6, 6:8, 3:5, 5:7)
  )
  bar <- hc_add_series(
    highchart(),
    prices,
    type = "ohlc",
    id = "price",
    name = "Price"
  )
  expect_identical(bar$x$hc_opts$series[[1]]$type, "ohlc")
  expect_identical(bar$x$hc_opts$series[[1]]$name, "Price")
  expect_identical(bar$x$hc_opts$series[[1]]$id, "price")

  other <- prices
  colnames(other) <- sub("BRK-B", "B", colnames(other), fixed = TRUE)
  expect_error(hchart(cbind(prices, other)), "one instrument")
  expect_error(
    hchart(cbind(prices[, c(6, 3)], other[, c(5, 2)])),
    "one instrument"
  )

  names_only <- prices[, c(6, 3, 5, 2)]
  colnames(names_only) <- c("o", "h", "l", "c")
  for (i in 1:4) {
    attr(names_only, c("Op", "Hi", "Lo", "Cl")[i]) <- i
  }
  expect_equal(hchart(names_only)$x$hc_opts$series[[1]]$data, series[[1]]$data)
})
