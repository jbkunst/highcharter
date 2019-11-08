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

# hchart ----

test_that("renderHighchart returns a function", {
  expect_true(is.function(renderHighchart(highchart())))
})

test_that("hchart returns a valid plot after valid data input", {
  data(mpg, package = "ggplot2")
  h <- hchart(mpg, "scatter", hcaes(x = displ, y = hwy, group = class))
  expect_true(all(class(h) %in% c("highchart","htmlwidget")))
})

test_that("hchart returns a valid scatter plot after valid data input", {
  data(mpg, package = "ggplot2")
  h <- hchart(mpg, "scatter", hcaes(x = displ, y = hwy, group = class))
})

test_that("hchart returns a valid area plot after valid data input", {
  data(mpg, package = "ggplot2")
  x <- mpg$hwy
  h <- hchart(density(x), type = "area", color = "#B71C1C", name = "hwy")
})

test_that("hchart fails after non-existing data", {
  # mgp = mpg mispelled
  expect_error(hchart(mgp, "scatter", hcaes(x = displ, y = hwy, group = class)))
})

test_that("hchart fails after mispelled hcaes", {
  data(mpg, package = "ggplot2")
  # dipsl = displ mispelled
  expect_error(hchart(mpg, "scatter", hcaes(x = dipsl, y = hwy, group = class)))
})

test_that("hchart fails after mispelled chart type", {
  # sactter = scatter mispelled
  expect_error(hchart(mgp, "sactter", hcaes(x = displ, y = hwy, group = class)))
})
