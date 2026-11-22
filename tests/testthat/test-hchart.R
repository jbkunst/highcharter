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

test_that("Gantt data frames preserve tasks and use the Gantt constructor", {
  tasks <- data.frame(
    start = c(1000, 3000),
    end = c(3000, 7000),
    name = c("Design", "Build"),
    id = c("design", "build")
  )
  tasks$dependency <- list(NA, "design")
  for (data in list(tasks, tibble::as_tibble(tasks))) {
    chart <- hchart(data, type = "gantt", name = "Program")
    series <- chart$x$hc_opts$series[[1]]
    expect_identical(chart$x$type, "gantt")
    expect_identical(series$type, "gantt")
    expect_identical(series$name, "Program")
    expect_equal(vapply(series$data, `[[`, numeric(1), "start"), tasks$start)
    expect_equal(vapply(series$data, `[[`, numeric(1), "end"), tasks$end)
    expect_identical(series$data[[2]]$id, "build")
    expect_identical(series$data[[2]]$dependency, "design")
  }
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

test_that("histogram columns follow the computed bin boundaries", {
  values <- c(0, 0.8, 2, 2.7, 5, 6)
  h <- hist(values, breaks = c(0, 1, 3, 6), plot = FALSE)
  series <- hchart(h)$x$hc_opts$series[[1]]
  expect_identical(series$type, "variwide")
  expect_identical(
    vapply(series$data, `[[`, "", "name"),
    c("0 \u2013 1", "1 \u2013 3", "3 \u2013 6")
  )
  expect_equal(vapply(series$data, `[[`, numeric(1), "x"), c(0, 1, 3))
  expect_equal(vapply(series$data, `[[`, numeric(1), "z"), c(1, 2, 3))
  expect_equal(vapply(series$data, `[[`, numeric(1), "y"), h$counts)
  expect_identical(
    hchart(values, breaks = h$breaks, type = "column")$x$hc_opts$series[[1]],
    series
  )
  equal <- hchart(values, breaks = seq(0, 6, 2))$x$hc_opts$series[[1]]
  expect_identical(equal$type, "column")
  expect_equal(equal$pointRange, 2)
})

test_that("hchart returns a valid time series decomposition plot after valid data input", {
  x <- stl(log(AirPassengers), "per")
  h <- hchart(x)
  expect_true(all(class(h) %in% c("highchart", "htmlwidget")))
})

test_that("hchart returns a valid graph after valid data input", {
  old_theme <- hc_set_theme("hcrt")
  on.exit(options(old_theme))
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
  expect_identical(h$x$theme$chart$style$fontFamily, "IBM Plex Sans")
  expect_false(h$x$theme$xAxis$visible)
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

test_that("multivariate layouts preserve series identities and shared HTML tooltips", {
  x <- cbind(mdeaths, fdeaths)
  for (separate in c(TRUE, FALSE)) {
    opts <- hchart(
      x,
      separate = separate,
      heights = c(2, 1),
      sep = 0.02
    )$x$hc_opts
    expect_identical(vapply(opts$series, `[[`, "", "id"), colnames(x))
    if (separate) {
      expect_equal(vapply(opts$series, `[[`, numeric(1), "yAxis"), c(0, 1))
      axes <- create_axis(2, heights = c(2, 1), sep = 0.02)
      expect_identical(
        lapply(opts$yAxis, `[[`, "height"),
        lapply(axes, `[[`, "height")
      )
    } else {
      expect_null(opts$series[[1]]$yAxis)
      expect_null(opts$series[[2]]$yAxis)
    }
    tooltip <- opts$tooltip
    expect_true(tooltip$shared)
    expect_true(tooltip$useHTML)
  }
})

test_that("ACF and PACF lollipops use the reported lags and correlations", {
  changes <- diff(AirPassengers)
  for (x in list(
    acf(changes, plot = FALSE),
    pacf(changes, plot = FALSE),
    ccf(mdeaths, fdeaths, plot = FALSE)
  )) {
    all_series <- hchart(x)$x$hc_opts$series
    expect_length(all_series, 1L)
    series <- all_series[[1]]
    expect_identical(series$type, "lollipop")
    expect_equal(vapply(series$data, `[[`, numeric(1), "x"), as.vector(x$lag))
    expect_equal(vapply(series$data, `[[`, numeric(1), "y"), as.vector(x$acf))
  }

  a <- acf(changes, plot = FALSE)
  styled <- hchart(
    a,
    name = "Changes",
    color = "steelblue",
    marker = list(radius = 5)
  )
  series <- styled$x$hc_opts$series[[1]]
  expect_identical(series$name, "Changes")
  expect_identical(series$color, "steelblue")
  expect_identical(series$marker, list(enabled = TRUE, radius = 5))
})

test_that("multivariate ACF panels retain each pair's signed lags and scale", {
  x <- cbind(mdeaths, fdeaths)
  for (type in c("correlation", "partial", "covariance")) {
    a <- acf(x, lag.max = 3L, type = type, plot = FALSE)
    opts <- hchart(a, color = "steelblue")$x$hc_opts
    expect_length(opts$series, 4L)
    for (i in 1:2) {
      for (j in 1:2) {
        k <- (i - 1L) * 2L + j
        series <- opts$series[[k]]
        label <- if (i == j) {
          colnames(x)[i]
        } else {
          paste(colnames(x)[c(i, j)], collapse = " / ")
        }
        expect_identical(opts$xAxis[[k]]$title$text, label)
        expect_identical(series$name, label)
        expect_identical(series$color, "steelblue")
        expect_identical(series$xAxis, k - 1L)
        expect_identical(series$yAxis, k - 1L)
        ord <- order(a$lag[, i, j])
        expect_equal(vapply(series$data, `[[`, 0, "x"), a$lag[ord, i, j])
        expect_equal(
          vapply(series$data, `[[`, 0, "y"),
          unname(a$acf[ord, i, j])
        )
        axis <- opts$yAxis[[k]]
        expect_identical(
          axis[c("min", "max")],
          opts$yAxis[[1]][c("min", "max")]
        )
        expect_length(axis$plotLines, if (type == "covariance") 0L else 2L)
      }
    }
  }
})

test_that("seasonal charts label the fitted outliers at adjusted values", {
  skip_if_not_installed("seasonal")
  skip_if_not_installed("x13binary")
  fit <- seasonal::seas(AirPassengers, regression.variables = "ls1956.Jan")
  opts <- hchart(fit)$x$hc_opts
  adjusted <- seasonal::final(fit)
  outliers <- seasonal::outlier(fit)
  i <- which(!is.na(outliers))
  expect_equal(
    opts$series[[1]]$data,
    hchart(seasonal::original(fit))$x$hc_opts$series[[1]]$data
  )
  expect_equal(
    opts$series[[2]]$data,
    hchart(adjusted)$x$hc_opts$series[[1]]$data
  )
  labels <- opts$annotations[[1]]$labels
  expect_equal(
    vapply(labels, `[[`, character(1), "text"),
    as.character(outliers[i])
  )
  expect_equal(
    vapply(labels, function(l) l$point$x, numeric(1)),
    ts_x_values(adjusted)[i]
  )
  expect_equal(
    vapply(labels, function(l) l$point$y, numeric(1)),
    as.numeric(adjusted[i])
  )
  fit <- seasonal::seas(AirPassengers, outlier = NULL)
  expect_null(hchart(fit)$x$hc_opts$annotations)
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

test_that("one-way tables keep their category order, zeros and supplied values", {
  counts <- table(Cylinders = factor(c(8, 8, 4), levels = c(4, 6, 8)))
  counts <- sort(counts, decreasing = TRUE)
  opts <- hchart(counts, name = "Cars")$x$hc_opts
  expect_identical(opts$xAxis$categories, c("8", "4", "6"))
  expect_identical(opts$xAxis$title$text, "Cylinders")
  expect_identical(opts$series[[1]]$type, "column")
  expect_identical(opts$series[[1]]$name, "Cars")
  expect_equal(opts$series[[1]]$data, c(2, 1, 0))
  proportions <- hchart(prop.table(counts), "bar")$x$hc_opts$series[[1]]
  expect_identical(proportions$type, "bar")
  expect_equal(proportions$data, c(2 / 3, 1 / 3, 0))
  missing <- hchart(table(c("A", NA), useNA = "ifany"))$x$hc_opts
  expect_identical(missing$xAxis$categories, c("A", "(NA)"))
  expect_equal(missing$series[[1]]$data, c(1, 1))
})

test_that("empirical distributions jump at the observed values", {
  fn <- ecdf(c(4, 1, 2, NA, 2))
  opts <- hchart(fn, color = "navy", name = "Sample", lineWidth = 3)$x$hc_opts
  series <- opts$series[[1]]
  expect_identical(series$type, "line")
  expect_identical(series$step, "left")
  expect_identical(series$name, "Sample")
  expect_identical(series$color, "navy")
  expect_equal(series$lineWidth, 3)
  x <- vapply(series$data, "[[", numeric(1), "x")
  y <- vapply(series$data, "[[", numeric(1), "y")
  expect_equal(x[2:4], c(1, 2, 4))
  expect_equal(y, c(0, 0.25, 0.75, 1, 1))
  expect_equal(y, fn(x))

  for (sample in list(c(0, 0), c(-Inf, 0, Inf))) {
    fn <- ecdf(sample)
    points <- hchart(fn)$x$hc_opts$series[[1]]$data
    x <- vapply(points, "[[", numeric(1), "x")
    expect_true(all(is.finite(x)) && x[1] < 0 && x[3] > 0)
    expect_equal(vapply(points, "[[", numeric(1), "y"), fn(x))
  }
  expect_error(hchart(ecdf(Inf)), "finite x")
})

test_that("two-way tables use the matrix grid and larger tables require a margin", {
  tab <- xtabs(~ cyl + gear, data = mtcars)
  hc <- hchart(tab, type = "tilemap", name = "Cars")
  opts <- hc$x$hc_opts
  expect_identical(opts$xAxis$categories, colnames(tab))
  expect_identical(opts$yAxis$categories, rownames(tab))
  expect_identical(opts$xAxis$title$text, "gear")
  expect_identical(opts$yAxis$title$text, "cyl")
  expect_identical(
    opts$series,
    hchart(unclass(tab), type = "tilemap", name = "Cars")$x$hc_opts$series
  )
  expect_error(hchart(Titanic), "margin.table", fixed = TRUE)
  expect_identical(
    hchart(margin.table(Titanic, c(1, 4)))$x$hc_opts$series[[1]]$type,
    "heatmap"
  )
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

test_that("matrix chart types share the same grid", {
  m <- matrix(1:6, 2, 3, dimnames = list(c("A", "B"), letters[1:3]))
  heat <- hchart(m, TRUE, TRUE)$x$hc_opts
  expect_identical(heat$series[[1]]$type, "heatmap")
  for (type in c("heatmap", "tilemap", "contour")) {
    opts <- hchart(m, label = TRUE, showInLegend = TRUE, type = type)$x$hc_opts
    expect_identical(opts$series[[1]]$type, type)
    expect_identical(opts$series[[1]]$data, heat$series[[1]]$data)
    expect_identical(opts$yAxis, heat$yAxis)
  }
  expect_error(hchart(m, type = "scatter"), "heatmap")
  contour <- hchart(
    m,
    type = "contour",
    contourInterval = 10,
    contourOffset = 0.5
  )
  expect_equal(contour$x$hc_opts$series[[1]]$contourInterval, 10)
  expect_equal(contour$x$hc_opts$series[[1]]$contourOffset, 0.5)
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
    seed <- .GlobalEnv$.Random.seed
    expect_warning(
      chart <- hc_add_series(highchart(), model),
      "Use predict",
      class = "deprecatedWarning"
    )
    series <- chart$x$hc_opts$series
    expect_identical(.GlobalEnv$.Random.seed, seed)
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
  expect_true(plain$colorAxis$visible)
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
