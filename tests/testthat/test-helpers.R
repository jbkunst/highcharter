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

test_that("color stops start at zero and span the gradient", {
  colors <- c("#000000", "#FFFFFF")
  expect_identical(color_stops(1, colors), list(list(0, "#000000")))
  expect_identical(
    color_stops(3, colors),
    list(list(0, "#000000"), list(0.5, "#7F7F7F"), list(1, "#FFFFFF"))
  )
  expect_error(color_stops(0))
  expect_error(color_stops(1.5))
})

test_that("Sankey links count transitions between adjacent columns", {
  paths <- data.frame(a = c("a", "a"), b = c("b", "b"), c = c("c", "d"))
  links <- data_to_sankey(paths)
  expect_equal(links$from, c("a", "b", "b"))
  expect_equal(links$to, c("b", "c", "d"))
  expect_equal(links$weight, c(2, 1, 1))
})
