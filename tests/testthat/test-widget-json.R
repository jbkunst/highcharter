test_that("widgets preserve missing points, optional fields and singleton arrays", {
  data <- data.frame(x = 1:3, y = c(4, NA, 8))
  data$custom <- list(list(id = "NA"), NULL, list(id = NA_character_))
  for (chart in list(highchart(), highchartstock())) {
    chart <- chart |>
      hc_add_series(data, type = "line", mapping = hcaes(x, y)) |>
      hc_add_series(data = 7) |>
      hc_tooltip(formatter = JS("function () { return this.y; }"))
    payload <- getFromNamespace("createPayload", "htmlwidgets")(chart)
    expect_identical(attr(payload$x, "TOJSON_FUNC"), widget_json)
    encode <- getFromNamespace("toJSON", "htmlwidgets")
    actual <- jsonlite::fromJSON(encode(payload), simplifyVector = FALSE)
    series <- actual$x$hc_opts$series
    expect_length(series[[1]]$data, 3)
    expect_identical(series[[1]]$data[[1]]$custom$id, "NA")
    expect_null(series[[1]]$data[[2]]$y)
    expect_true("custom" %in% names(series[[1]]$data[[2]]))
    expect_null(series[[1]]$data[[2]]$custom)
    expect_null(series[[1]]$data[[3]]$custom$id)
    expect_equal(series[[2]]$data, list(7))
    expect_equal(actual$evals, list("hc_opts.tooltip.formatter"))
  }
})

test_that("custom widget options retain their property names and UTC timestamps", {
  metadata <- list(
    range = c(low = 2, high = 8),
    observed = as.POSIXct("2026-11-19 09:00:00", tz = "America/Santiago"),
    recorded = data.frame(value = 4),
    gaps = c(NA_real_, Inf, -Inf, NaN),
    label = I("Ñandú")
  )
  widget <- highchart() |> hc_add_series(data = 1, custom = metadata)
  payload <- getFromNamespace("createPayload", "htmlwidgets")(widget)
  payload_json <- getFromNamespace("toJSON", "htmlwidgets")(payload)
  actual <- jsonlite::fromJSON(payload_json, simplifyVector = FALSE)
  custom <- actual$x$hc_opts$series[[1]]$custom
  expect_equal(custom$range, list(low = 2, high = 8))
  expect_equal(custom$observed, "2026-11-19T12:00:00Z")
  expect_equal(custom$recorded$value, list(4))
  expect_identical(custom$gaps, rep(list(NULL), 4))
  expect_identical(custom$label, list("Ñandú"))
})
