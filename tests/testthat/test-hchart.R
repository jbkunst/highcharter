# hchart ----

test_that("renderHighchart returns a function", {
  expect_true(is.function(renderHighchart(highchart())))
})

test_that("hchart has a valid class after valid data input", {
  data(mpg, package = "ggplot2")
  h <- hchart(mpg, "scatter", hcaes(x = displ, y = hwy, group = class))
  expect_true(all(class(h) %in% c("highchart","htmlwidget")))
})

test_that("hchart returns a valid scatter plot after valid data input", {
  data(mpg, package = "ggplot2")
  h <- hchart(mpg, "scatter", hcaes(x = displ, y = hwy, group = class))
  expect_true(all(class(h) %in% c("highchart","htmlwidget")))
})

test_that("hchart returns a valid area plot after valid data input", {
  data(mpg, package = "ggplot2")
  x <- mpg$hwy
  h <- hchart(density(x), type = "area", color = "#B71C1C", name = "hwy")
  expect_true(all(class(h) %in% c("highchart","htmlwidget")))
})

test_that("hchart returns a valid column plot after valid data input", {
  data(mpg, package = "ggplot2")
  x <- mpg$hwy
  h <- hchart(x, type = "column", color = "#B71C1C", name = "hwy")
  expect_true(all(class(h) %in% c("highchart","htmlwidget")))
})

test_that("hchart returns a valid time series plot after valid data input", {
  h <- hchart(LakeHuron)
  expect_true(all(class(h) %in% c("highchart","htmlwidget")))
})

test_that("hchart returns a valid time series decomposition plot after valid data input", {
  x <- stl(log(AirPassengers), "per")
  h <- hchart(x)
  expect_true(all(class(h) %in% c("highchart","htmlwidget")))
})

test_that("hchart returns a valid time series forecast plot after valid data input", {
  x <- forecast::forecast(forecast::ets(USAccDeaths), h = 48, level = 95)
  h <- hchart(x)
  expect_true(all(class(h) %in% c("highchart","htmlwidget")))
})

test_that("hchart returns a valid graph after valid data input", {
  require(igraph)
  N <- 40
  
  net <- sample_gnp(N, p = 2 / N)
  wc <- cluster_walktrap(net)
  
  V(net)$label <- seq(N)
  V(net)$name <- paste("I'm #", seq(N))
  V(net)$page_rank <- round(page.rank(net)$vector, 2)
  V(net)$betweenness <- round(betweenness(net), 2)
  V(net)$degree <- degree(net)
  V(net)$size <- V(net)$degree
  V(net)$comm <- membership(wc)
  V(net)$color <- colorize(membership(wc))
  
  h <- hchart(net, layout = layout_with_fr)
  expect_true(all(class(h) %in% c("highchart","htmlwidget")))
})

test_that("hchart returns a valid model plot after valid data input", {
  library(survival)
  
  data(lung)
  lung <- dplyr::mutate(lung, sex = ifelse(sex == 1, "Male", "Female"))
  fit <- survfit(Surv(time, status) ~ sex, data = lung)
  
  h <- hchart(fit, ranges = TRUE)
  expect_true(all(class(h) %in% c("highchart","htmlwidget")))
})

test_that("hchart returns a valid stocks plot after valid data input", {
  x <- quantmod::getFX("USD/JPY", auto.assign = FALSE)
  h <- hchart(x)
  expect_true(all(class(h) %in% c("highchart","htmlwidget")))
})

test_that("hchart returns a valid multivariate time series plot after valid data input", {
  x <- cbind(mdeaths, fdeaths)
  h <- hchart(x)
  expect_true(all(class(h) %in% c("highchart","htmlwidget")))
})

test_that("hchart returns a valid autocovariance plot after valid data input", {
  x <- acf(diff(AirPassengers), plot = FALSE)
  h <- hchart(x)
  expect_true(all(class(h) %in% c("highchart","htmlwidget")))
})

test_that("hchart returns a valid pca plot after valid data input", {
  h <- hchart(princomp(USArrests, cor = TRUE))
  expect_true(all(class(h) %in% c("highchart","htmlwidget")))
})

test_that("hchart returns a valid matrix plot after valid data input", {
  data(volcano)
  h <- hchart(volcano)
  expect_true(all(class(h) %in% c("highchart","htmlwidget")))
})

test_that("hchart returns a valid distance matrix plot after valid data input", {
  mtcars2 <- mtcars[1:20, ]
  x <- dist(mtcars2)
  h <- hchart(x)
  expect_true(all(class(h) %in% c("highchart","htmlwidget")))
})

test_that("hchart returns a valid correlation matrix plot after valid data input", {
  h <- hchart(cor(mtcars))
  expect_true(all(class(h) %in% c("highchart","htmlwidget")))
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
