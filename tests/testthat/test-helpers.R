context("Testing utils")

test_that("list.parse", {
  result <- list(
    list(4, 2),
    list(4, 10),
    list(7, 4),
    list(7, 22),
    list(8, 16),
    list(9, 10)
  )

  expect_equal(list_parse2(head(cars)), result)
})

test_that("Sankey links count transitions between adjacent columns", {
  paths <- data.frame(a = c("a", "a"), b = c("b", "b"), c = c("c", "d"))
  links <- data_to_sankey(paths)
  expect_equal(links$from, c("a", "b", "b"))
  expect_equal(links$to, c("b", "c", "d"))
  expect_equal(links$weight, c(2, 1, 1))
})
