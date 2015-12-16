context("Testing the highchart constructor")

test_that("highchart object is a from highchart and htmlwidget class", {
  
  hc <- highchart()
  
  expect_true(all(class(hc) %in% c("highchart",  "htmlwidget")))
  
})
