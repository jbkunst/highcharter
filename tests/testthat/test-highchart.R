context("Testing the highchart constructor")

test_that("highchart object is a from highchart and htmlwidget class", {
  
  hc <- highchart()
  
  expect_true(all(class(hc) %in% c("highchart",  "htmlwidget")))
  
})

test_that("highchartOutput  return a function", {
  
  expect_true(
    all(class(highchartOutput("outputid")) %in% c("shiny.tag.list", "list"))
    )
  
})

test_that("renderHighchart return a function", {
  
  expect_true(is.function(renderHighchart(highchart())))
  
})
