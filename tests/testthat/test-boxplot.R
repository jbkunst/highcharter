test_that("outliers share their category position with the corresponding box", {
  sales <- data.frame(
    store = rep(c("Sur", "Norte"), each = 6),
    channel = rep(c("A", "B"), each = 6),
    amount = c(1:5, 50, 1:6)
  )

  series <- data_to_boxplot(sales, amount, store, channel, add_outliers = TRUE)
  box <- series$data[[which(series$id == "A")]][[1]]
  point <- series$data[[which(series$linkedTo == "A")]][[1]]

  expect_equal(box$name, "Sur")
  expect_equal(point$x, box$x)
  expect_equal(point$y, 50)
  expect_equal(box$high, 5)
  expect_equal(
    data_to_boxplot(sales, amount, store, channel)$type,
    rep("boxplot", 2)
  )
})

test_that("a single boxplot series controls its outliers from the legend", {
  series <- data_to_boxplot(iris, Petal.Length, Species, add_outliers = TRUE)
  expect_identical(series$type, c("boxplot", "scatter"))
  expect_identical(series$linkedTo[[2]], ":previous")
  expect_false(series$showInLegend[[2]])
})
