# highchart ----

test_that("highchart object is a from highchart and htmlwidget class", {
  hc <- highchart()

  expect_true(all(class(hc) %in% c("highchart", "htmlwidget")))
})

# highchartOutput ----

test_that("highchartOutput returns a function", {
  expect_true(
    all(class(highchartOutput("outputid")) %in% c("shiny.tag.list", "list"))
  )
})

test_that("mixed widgets resolve one Highcharts bundle in either order", {
  stock <- highchart(type = "stock")
  zero <- highchartzero()

  for (widgets in list(list(stock, zero), list(zero, stock))) {
    deps <- htmltools::renderTags(htmltools::tagList(widgets))$dependencies
    engine <- Filter(function(dep) dep$name == "highcharts", deps)
    expect_length(engine, 1)
    expect_identical(engine[[1]]$script, c("highcharter-bundle.js", "highcharts/custom/reset.js"))
  }
})
