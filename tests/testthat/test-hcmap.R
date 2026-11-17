test_that("hcmap uses a loaded map without downloads or remote dependencies", {
  chart <- hcmap(worldgeojson, showInLegend = FALSE)
  expect_identical(chart$x$type, "map")
  expect_identical(chart$x$hc_opts$series[[1]]$mapData, worldgeojson)
  expect_null(chart$dependencies)
  values <- data.frame(iso3 = "CHL", income = 12345)
  joined <- hcmap(
    worldgeojson,
    data = values,
    value = "income",
    joinBy = "iso3"
  )
  expect_identical(joined$x$hc_opts$series[[1]]$data[[1]]$value, 12345)
  expect_identical(joined$x$hc_opts$series[[1]]$joinBy, "iso3")
})
