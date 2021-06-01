context("hc_add_series.data.frame")

test_that("add regular data frame series", {
  on.exit(options("highcharter.boost" = FALSE))
  
  df <- head(cars)
  expect_true(is.data.frame(df))
  hc <- highchart() %>% hc_add_series(data = df)

  options("highcharter.boost" = FALSE)
  expect_true(hasName(hc$x$hc_opts, "series"))
  expect_equal(length(hc$x$hc_opts$series), 1)
  expect_equal(length(hc$x$hc_opts$series[[1]]$data), nrow(df))
  expect_true(all(sapply(hc$x$hc_opts$series[[1]]$data, length) == ncol(df)))

  options("highcharter.boost" = TRUE)
  hc_boost <- highchart() %>% hc_add_series(data = df)
  expect_true(identical(hc_boost$x$hc_opts$series, hc$x$hc_opts$series))
})

test_that("add mapping with group_by data frame series", {
  on.exit(options("highcharter.boost" = FALSE))
  
  data(mpg, package = "ggplot2")
  expect_true(is.data.frame(mpg))
  
  options("highcharter.boost" = FALSE)
  hc <- highchart(type = "chart") %>% 
    hc_add_series(data = mpg,
      hcaes(x = year, y = 1, group = manufacturer)
  )
  expect_true(hasName(hc$x$hc_opts, "series"))
  expect_equal(length(hc$x$hc_opts$series), 1)
  expect_equal(length(hc$x$hc_opts$series[[1]]$data), nrow(mpg))
  expect_true(all(sapply(hc$x$hc_opts$series[[1]]$data, length) == ncol(mpg)))
  
  options("highcharter.boost" = TRUE)
  hc_boost <- highchart() %>% hc_add_series(data = mpg,
    hcaes(x = year, y = 1, group = manufacturer)
  )
  expect_true(identical(hc_boost$x$hc_opts$series, hc$x$hc_opts$series))
})
