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
