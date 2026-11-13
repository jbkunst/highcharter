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
    expect_identical(
      engine[[1]]$script,
      c(
        "highcharter-bundle.js",
        "highcharts/custom/reset.js",
        "highcharts/custom/highcharter-widget.js"
      )
    )
  }
})

test_that("highchartstock adds Stock Tools to the shared Highcharts engine", {
  tools <- highchartstock()
  regular <- highchart()

  expect_true(is.highchart(tools))
  expect_identical(tools$x$type, "stock")

  for (widgets in list(list(regular, tools), list(tools, regular))) {
    deps <- htmltools::renderTags(htmltools::tagList(widgets))$dependencies
    expect_length(Filter(function(dep) dep$name == "highcharts", deps), 1)
    expect_length(Filter(function(dep) dep$name == "highcharts-stock-tools", deps), 1)
  }
})

test_that("third-party plugins stay optional", {
  plain <- highchart()
  motion <- hc_motion(highchart())

  expect_false(any(vapply(plain$dependencies, function(dep) {
    identical(dep$name, "highcharts-motion")
  }, logical(1))))
  expect_true(any(vapply(motion$dependencies, function(dep) {
    identical(dep$name, "highcharts-motion")
  }, logical(1))))
})

test_that("legacy official module dependencies are harmless", {
  chart <- highchart()
  expect_identical(hc_add_dependency(chart, "modules/pattern-fill.js"), chart)
})
