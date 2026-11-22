test_that("ctree nodes preserve training counts, class order and split tests", {
  skip_if_not_installed("partykit")
  fit <- partykit::ctree(Species ~ Petal.Length + Petal.Width, data = iris)
  donut <- hchart(fit, node_size = 50)$x$hc_opts
  tree <- donut$series[[1]]
  nodes <- tree$data
  expect_equal(tree$type, "treegraph")
  expect_equal(unlist(tree$custom$categories), levels(iris$Species))
  expect_equal(nodes[[1]]$custom$n, nrow(iris))
  expect_equal(
    nodes[[1]]$custom$p,
    unname(partykit::info_node(partykit::node_party(fit))$p.value)
  )
  expect_equal(length(donut$series), length(nodes) + 1L)
  for (node in nodes) {
    expect_equal(
      sum(vapply(node$custom$composition, "[[", integer(1), "y")),
      node$custom$n
    )
    expect_equal((node$marker$radius / 25)^2, node$custom$n / nrow(iris))
    if (node$custom$leaf) expect_null(node$custom$p)
  }
  bar <- hchart(fit, node_shape = "bar", link = list(lineWidth = 3))$x$hc_opts
  expect_length(bar$series, 1)
  expect_equal(bar$series[[1]]$link$lineWidth, 3)
  expect_equal(bar$series[[1]]$data[[1]]$marker$symbol, "rect")
})

test_that("rpart regression dispatches through the common tree adapter", {
  skip_if_not_installed("partykit")
  skip_if_not_installed("rpart")
  fit <- rpart::rpart(
    Sepal.Length ~ Petal.Length + Petal.Width,
    data = iris,
    model = TRUE
  )
  chart <- hchart(fit)
  tree <- chart$x$hc_opts$series[[1]]
  expect_equal(tree$type, "treegraph")
  expect_equal(tree$data[[1]]$custom$mean, mean(iris$Sepal.Length))
  expect_equal(tree$data[[1]]$custom$sd, sd(iris$Sepal.Length))
  expect_null(tree$data[[1]]$custom$p)
  expect_null(chart$height)
  expect_null(chart$x$hc_opts$chart$height)
})

test_that("C5.0 accepts a single tree and explains unsupported fits", {
  skip_if_not_installed("C50")
  fit <- C50::C5.0(Species ~ Petal.Length + Petal.Width, data = iris)
  node <- hchart(fit, node_shape = "bar")$x$hc_opts$series[[1]]$data[[1]]
  expect_equal(node$custom$n, nrow(iris))
  expect_equal(
    vapply(node$custom$composition, "[[", integer(1), "y"),
    c(50L, 50L, 50L)
  )
  rules <- C50::C5.0(
    Species ~ Petal.Length + Petal.Width,
    data = iris,
    rules = TRUE
  )
  expect_error(hchart(rules), "single C5.0 tree")
})
