# hchart ----

test_that("renderHighchart returns a function", {
  expect_true(is.function(renderHighchart(highchart())))
})

test_that("hchart has a valid class after valid data input", {
  data(mpg, package = "ggplot2")
  h <- hchart(mpg, "scatter", hcaes(x = displ, y = hwy, group = class))
  expect_true(all(class(h) %in% c("highchart", "htmlwidget")))
})

test_that("hchart returns a valid scatter plot after valid data input", {
  data(mpg, package = "ggplot2")
  h <- hchart(mpg, "scatter", hcaes(x = displ, y = hwy, group = class))
  expect_true(all(class(h) %in% c("highchart", "htmlwidget")))
})

test_that("hchart returns a valid area plot after valid data input", {
  data(mpg, package = "ggplot2")
  x <- mpg$hwy
  h <- hchart(density(x), type = "area", color = "#B71C1C", name = "hwy")
  expect_true(all(class(h) %in% c("highchart", "htmlwidget")))
})

test_that("hchart returns a valid column plot after valid data input", {
  data(mpg, package = "ggplot2")
  x <- mpg$hwy
  h <- hchart(x, type = "column", color = "#B71C1C", name = "hwy")
  expect_true(all(class(h) %in% c("highchart", "htmlwidget")))
})

test_that("hchart returns a valid time series plot after valid data input", {
  h <- hchart(LakeHuron)
  expect_true(all(class(h) %in% c("highchart", "htmlwidget")))
})

test_that("hchart returns a valid time series decomposition plot after valid data input", {
  x <- stl(log(AirPassengers), "per")
  h <- hchart(x)
  expect_true(all(class(h) %in% c("highchart", "htmlwidget")))
})

test_that("hchart returns a valid graph after valid data input", {
  require(igraph)
  N <- 40

  net <- sample_gnp(N, p = 2 / N)
  wc <- cluster_walktrap(net)

  V(net)$label <- seq(N)
  V(net)$name <- paste("I'm #", seq(N))
  V(net)$page_rank <- round(page_rank(net)$vector, 2)
  V(net)$betweenness <- round(betweenness(net), 2)
  V(net)$degree <- degree(net)
  V(net)$size <- V(net)$degree
  V(net)$comm <- as.vector(membership(wc))
  V(net)$color <- colorize(membership(wc))

  h <- hchart(net, layout = layout_with_fr)
  expect_true(all(class(h) %in% c("highchart", "htmlwidget")))
})

test_that("hchart returns a valid model plot after valid data input", {
  library(survival)

  lung <- dplyr::mutate(
    survival::lung,
    sex = ifelse(sex == 1, "Male", "Female")
  )
  fit <- survfit(Surv(time, status) ~ sex, data = lung)

  h <- hchart(fit, ranges = TRUE)
  expect_true(all(class(h) %in% c("highchart", "htmlwidget")))
})

test_that("hchart returns a valid stocks plot after valid data input", {
  skip_if_not_installed("xts")
  dates <- as.Date("2025-01-01") + 0:2
  x <- xts::xts(c(42, NA, 44), dates)
  h <- hchart(x, name = "Price")
  series <- h$x$hc_opts$series[[1L]]
  expect_identical(h$x$type, "stock")
  expect_identical(series$name, "Price")
  expect_equal(
    series$data,
    Map(list, datetime_to_timestamp(dates), c(42, NA, 44))
  )
})

test_that("hchart returns a valid multivariate time series plot after valid data input", {
  x <- cbind(mdeaths, fdeaths)
  h <- hchart(x)
  expect_true(all(class(h) %in% c("highchart", "htmlwidget")))
})

test_that("hchart returns a valid autocovariance plot after valid data input", {
  x <- acf(diff(AirPassengers), plot = FALSE)
  h <- hchart(x)
  expect_true(all(class(h) %in% c("highchart", "htmlwidget")))
})

test_that("hchart returns a valid pca plot after valid data input", {
  h <- hchart(princomp(USArrests, cor = TRUE))
  expect_true(all(class(h) %in% c("highchart", "htmlwidget")))
})

test_that("hchart returns a valid matrix plot after valid data input", {
  data(volcano)
  h <- hchart(volcano)
  expect_true(all(class(h) %in% c("highchart", "htmlwidget")))
})

test_that("distance heatmaps accept matrix display options", {
  d <- stats::dist(head(mtcars, 3))
  opts <- hchart(d, label = TRUE, showInLegend = TRUE)$x$hc_opts
  expect_identical(
    opts,
    hchart(as.matrix(d), label = TRUE, showInLegend = TRUE)$x$hc_opts
  )
  expect_true(opts$plotOptions$series$dataLabels$enabled)
  expect_true(opts$plotOptions$series$showInLegend)
})

test_that("hchart returns a valid correlation matrix plot after valid data input", {
  h <- hchart(cor(mtcars))
  expect_true(all(class(h) %in% c("highchart", "htmlwidget")))
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

test_that("model series keep fitted values and standard errors aligned with x", {
  observations <- cars[50:1, ]
  observations$speed[2] <- NA
  for (model in list(
    lm(dist ~ speed, observations, na.action = na.exclude),
    loess(dist ~ speed, observations, na.action = na.exclude)
  )) {
    if (inherits(model, "loess")) {
      prediction <- predict(model, se = TRUE)
    } else {
      prediction <- predict(model, se.fit = TRUE)
      prediction$fit <- prediction$fit[-2]
      prediction$se.fit <- prediction$se.fit[-2]
    }
    series <- hc_add_series(highchart(), model)$x$hc_opts$series
    order_x <- order(observations$speed[-2])
    fit <- unname(prediction$fit[order_x])
    se <- unname(prediction$se.fit[order_x])
    expect_equal(
      vapply(series[[1]]$data, "[[", numeric(1), "x"),
      sort(observations$speed[-2])
    )
    expect_equal(vapply(series[[1]]$data, "[[", numeric(1), "y"), fit)
    expect_equal(
      vapply(series[[2]]$data, "[[", numeric(1), "low"),
      fit - 2 * se
    )
    expect_equal(
      vapply(series[[2]]$data, "[[", numeric(1), "high"),
      fit + 2 * se
    )
    expect_identical(series[[2]]$linkedTo, series[[1]]$id)
  }
})

test_that("matrix heatmaps use positions even when labels repeat", {
  m <- matrix(
    c(-0.5, NA_real_, 0, 0.5, 1, 0.25),
    nrow = 2,
    dimnames = list(c("north", "north"), c("V", "V", "x"))
  )
  opts <- hchart(m, label = TRUE)$x$hc_opts
  points <- opts$series[[1]]$data
  expect_identical(vapply(points, "[[", integer(1), "x"), rep(0:2, each = 2))
  expect_identical(vapply(points, "[[", integer(1), "y"), rep(0:1, 3))
  expect_equal(vapply(points, "[[", numeric(1), "value"), as.vector(m))
  expect_identical(points[[3]]$name, "V ~ north")
  expect_identical(opts$xAxis$categories, colnames(m))
  expect_identical(opts$yAxis$categories, rownames(m))
  expect_true(opts$yAxis$reversed)
  expect_true(opts$plotOptions$series$dataLabels$enabled)
  expect_equal(c(opts$colorAxis$min, opts$colorAxis$max), c(-1, 1))

  plain <- hchart(unname(m))$x$hc_opts
  expect_false(plain$xAxis$visible)
  expect_identical(plain$series[[1]]$data[[1]]$x, 1L)
  expect_identical(plain$series[[1]]$data[[1]]$y, 1L)
  expect_null(hchart(matrix(NA_real_))$x$hc_opts$colorAxis$min)
  expect_length(hchart(matrix(numeric(), 0, 2))$x$hc_opts$series[[1]]$data, 0)
})

test_that("data-frame charts reject the removed fast option", {
  points <- data.frame(x = 1:2, y = c(3, NA_real_))
  mapping <- hcaes(x, y)
  expect_error(hchart(points, "line", mapping, fast = TRUE), "fast.*removed")
  expect_error(
    hc_add_series(highchart(), points, "line", mapping, fast = FALSE),
    "fast.*removed"
  )
  expect_error(hc_add_series(highchart(), points, fast = TRUE), "fast.*removed")

  expected <- list(list(x = 1L, y = 3), list(x = 2L, y = NA_real_))
  expect_identical(
    hchart(points, "line", mapping)$x$hc_opts$series[[1]]$data,
    expected
  )
  expect_identical(
    hc_add_series(highchart(), points)$x$hc_opts$series[[1]]$data,
    expected
  )
})
