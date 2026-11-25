test_that("random forests use the recorded OOB and test histories", {
  skip_if_not_installed("randomForest")
  set.seed(42)
  fit <- randomForest::randomForest(
    iris[1:4],
    iris$Species,
    xtest = iris[1:4],
    ytest = iris$Species,
    ntree = 8
  )
  opts <- hchart(fit)$x$hc_opts
  series <- opts$series
  expect_true(opts$tooltip$shared)
  expect_true(opts$tooltip$useHTML)
  expect_match(opts$tooltip$pointFormat, "<tr>", fixed = TRUE)
  expect_identical(opts$tooltip$valueSuffix, "%")
  expect_equal(series[[1]]$data, 100 * fit$err.rate[, 1], ignore_attr = TRUE)
  expect_equal(series[[4]]$name, "OOB \u00b7 virginica")
  expect_equal(
    series[[5]]$data,
    100 * fit$test$err.rate[, 1],
    ignore_attr = TRUE
  )
  expect_equal(series[[5]]$dashStyle, "Dash")
  reg <- randomForest::randomForest(mpg ~ wt, data = mtcars, ntree = 8)
  opts <- hchart(reg)$x$hc_opts
  expect_equal(opts$series[[1]]$data, reg$mse)
  expect_false(identical(opts$tooltip$footerFormat, "</table>"))
})

test_that("glmnet whiskers and lambda markers match the fit", {
  skip_if_not_installed("glmnet")
  x <- as.matrix(mtcars[c("hp", "wt", "qsec")])
  cv <- glmnet::cv.glmnet(x, mtcars$mpg, foldid = rep_len(1:5, nrow(x)))
  opts <- hchart(cv)$x$hc_opts
  expect_true(opts$xAxis$crosshair)
  expect_false(opts$yAxis$crosshair$snap)
  expect_identical(opts$yAxis$title$text, as.character(cv$name))
  expect_equal(vapply(opts$series[[1]]$data, "[[", numeric(1), "y"), cv$cvm)
  expect_equal(
    do.call(rbind, lapply(opts$series[[2]]$data, unlist)),
    cbind(-log(cv$lambda), cv$cvlo, cv$cvup),
    ignore_attr = TRUE
  )
  expect_equal(
    vapply(opts$xAxis$plotLines, "[[", numeric(1), "value"),
    -log(unique(c(cv$lambda.min, cv$lambda.1se)))
  )
})

test_that("cluster charts preserve heights and the supplied leaf order", {
  fit <- stats::hclust(stats::dist(USArrests[1:8, ]))
  dend <- stats::as.dendrogram(fit)
  opts <- hchart(fit)$x$hc_opts
  expect_equal(opts, hchart(dend)$x$hc_opts)
  expect_identical(opts$series[[1]]$type, "treegraph")
  nodes <- opts$series[[1]]$data
  leaf_names <- function(nodes) {
    tips <- Filter(function(node) node$custom$members == 1L, nodes)
    vapply(tips, "[[", character(1), "name")
  }
  expect_equal(leaf_names(nodes), labels(dend))
  expect_equal(
    leaf_names(hchart(rev(dend))$x$hc_opts$series[[1]]$data),
    rev(labels(dend))
  )
  joins <- Filter(function(node) node$custom$members > 1L, nodes)
  heights <- vapply(joins, "[[", numeric(1), "x")
  expect_equal(sort(heights), sort(fit$height))
})

test_that("phylogenies preserve unequal lengths, multifurcations and unit edges", {
  skip_if_not_installed("ape")
  tree <- ape::read.tree(text = "((A:2,B:4,C:1):2,D:3);")
  opts <- hchart(tree)$x$hc_opts
  expect_true(opts$chart$polar)
  nodes <- opts$series[[2]]$data
  expect_equal(
    vapply(nodes, "[[", numeric(1), "y"),
    ape::node.depth.edgelength(tree)
  )
  expect_equal(vapply(nodes[1:4], "[[", character(1), "name"), tree$tip.label)
  expect_equal(
    hchart(tree, layout = "rectangular")$x$hc_opts$series[[2]]$data,
    nodes
  )
  tree$edge.length <- NULL
  unit <- hchart(tree)$x$hc_opts$series[[2]]$data
  expect_equal(vapply(unit[1:4], "[[", numeric(1), "y"), c(2, 2, 2, 1))
})

test_that("XGBoost charts select the requested tree and retain margin and cover", {
  skip_if_not_installed("xgboost", minimum_version = "3.1.0")
  d <- xgboost::xgb.DMatrix(as.matrix(iris[1:3]), label = iris$Petal.Width)
  fit <- xgboost::xgb.train(
    list(objective = "reg:squarederror", max_depth = 2L, nthread = 1L),
    d,
    nrounds = 2L,
    verbose = 0
  )
  nodes <- xgboost::xgb.model.dt.tree(model = fit, trees = 2L)
  pts <- hchart(fit, tree = 2L)$x$hc_opts$series[[1]]$data
  expect_equal(vapply(pts, "[[", character(1), "id"), nodes$ID)
  expect_equal(vapply(pts, function(p) p$custom$cover, numeric(1)), nodes$Cover)
  expect_equal(pts[[match(nodes$Yes[1], nodes$ID)]]$parent, nodes$ID[1])
  i <- which(is.na(nodes$Yes))[1]
  expect_equal(as.numeric(pts[[i]]$name), signif(nodes$Gain[i], 5))
  expect_error(hchart(fit, tree = 3), "exceeds")
  expect_error(hchart(fit, tree = 0), "positive integer")
})
