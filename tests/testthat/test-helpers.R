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

test_that("explicit color stops pair each position with its original color", {
  colors <- c("navy", "#FFCC00", "red")
  positions <- c(low = 0, mid = 0.5, high = 0.9)
  expected <- list(list(0, "navy"), list(0.5, "#FFCC00"), list(0.9, "red"))
  expect_identical(
    color_stops(colors = colors, positions = positions),
    expected
  )
  expect_identical(color_stops(3, colors, positions), expected)
  expect_identical(
    color_stops(colors = "red", positions = 0.5),
    list(list(0.5, "red"))
  )
  expect_identical(
    color_stops(colors = c("blue", "red"), positions = c(0.4, 0.4)),
    list(list(0.4, "blue"), list(0.4, "red"))
  )
  expect_error(color_stops(colors = colors, positions = c(0, 1)))
  expect_error(color_stops(5, colors, positions))
  expect_error(color_stops(colors = colors, positions = c(0, 0.8, 0.4)))
  expect_error(color_stops(colors = colors, positions = c(0, 1, 1.1)))
  expect_error(color_stops(colors = colors, positions = c(0, NA, 1)))
})

test_that("Sankey links count transitions between adjacent columns", {
  paths <- data.frame(a = c("a", "a"), b = c("b", "b"), c = c("c", "d"))
  links <- data_to_sankey(paths)
  expect_equal(links$from, c("a", "b", "b"))
  expect_equal(links$to, c("b", "c", "d"))
  expect_equal(links$weight, c(2, 1, 1))
})
