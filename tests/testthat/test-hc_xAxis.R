# hc_xAxis ----

test_that("hc_xAxis has dateTimeLabelFormats", {
  hc <- weather %>%
    hchart("line", hcaes(x = date, y = mean_temperaturec)) %>% 
    hc_xAxis(type = "datetime", dateTimeLabelFormats = list(
      day = "%d-%m-%Y",
      month = "%b \'%y",
      year = "%Y"
    ))
  
  expect_equal(length(hc$x$hc_opts$xAxis$dateTimeLabelFormats), 3)
  expect_equal(hc$x$hc_opts$xAxis$dateTimeLabelFormats$day, "%d-%m-%Y")
  expect_equal(hc$x$hc_opts$xAxis$dateTimeLabelFormats$month, "%b \'%y")
  expect_equal(hc$x$hc_opts$xAxis$dateTimeLabelFormats$year, "%Y")
})
