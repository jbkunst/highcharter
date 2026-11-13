local_proxy_session <- function() {
  messages <- list()
  session <- list(
    sendCustomMessage = function(type, message) {
      messages[[length(messages) + 1]] <<- list(type = type, message = message)
    }
  )
  list(
    session = session,
    messages = function() messages
  )
}

test_that("hcpxy_set_data can target a series by ID", {
  capture <- local_proxy_session()
  proxy <- highchartProxy("stock", capture$session)

  result <- suppressWarnings(
    hcpxy_set_data(
      proxy,
      type = "line",
      data = data.frame(x = 1:2, y = 3:4),
      mapping = hcaes(x, y),
      id = "price"
    )
  )

  expect_identical(result, proxy)
  messages <- capture$messages()
  expect_length(messages, 1)
  expect_identical(messages[[1]]$type, "setData")
  expect_identical(messages[[1]]$message$idSeries, "price")
  expect_identical(messages[[1]]$message$serie, 0)
})

test_that("hcpxy_set_data keeps position fallback", {
  capture <- local_proxy_session()
  proxy <- highchartProxy("chart", capture$session)

  suppressWarnings(
    hcpxy_set_data(
      proxy,
      type = "line",
      data = data.frame(x = 1:2, y = 3:4),
      mapping = hcaes(x, y)
    )
  )

  expect_null(capture$messages()[[1]]$message$idSeries)
  expect_error(
    suppressWarnings(
      hcpxy_set_data(
        proxy,
        type = "line",
        data = data.frame(x = 1:2, y = 3:4),
        mapping = hcaes(x, y),
        id = c("one", "two")
      )
    )
  )
})

test_that("hcpxy_set_extremes sends numeric and date ranges", {
  capture <- local_proxy_session()
  proxy <- highchartProxy("stock", capture$session)
  from <- as.Date("2026-01-01")
  to <- as.Date("2026-02-01")

  result <- hcpxy_set_extremes(proxy, from, to, axis = "dates", animation = FALSE)

  expect_identical(result, proxy)
  message <- capture$messages()[[1]]
  expect_identical(message$type, "setExtremes")
  expect_identical(message$message$axis, "dates")
  expect_identical(message$message$min, datetime_to_timestamp(from))
  expect_identical(message$message$max, datetime_to_timestamp(to))
  expect_false(message$message$animation)
})

test_that("hcpxy_set_extremes can reset the first x axis", {
  capture <- local_proxy_session()
  proxy <- highchartProxy("chart", capture$session)

  hcpxy_set_extremes(proxy)

  message <- capture$messages()[[1]]$message
  expect_identical(message$axis, 0)
  expect_null(message$min)
  expect_null(message$max)
  expect_error(hcpxy_set_extremes(proxy, axis = -1))
})
