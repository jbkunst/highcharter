test_that("Sankey drops incomplete links and keeps valid subsequent stages", {
  stages <- data.frame(first = c("A", NA), second = "B", third = "C")
  links <- data_to_sankey(stages)
  expect_equal(links$from, c("A", "B"))
  expect_equal(links$to, c("B", "C"))
  expect_identical(links$weight, c(1L, 2L))

  empty <- tibble::tibble(
    from = character(),
    to = character(),
    weight = integer(),
    id = character()
  )
  expect_identical(data_to_sankey(stages[1]), empty)
  expect_identical(data_to_sankey(stages[0]), empty)
  expect_identical(data_to_sankey(stages[0, ]), empty)
})

test_that("Sankey bins numeric stages with missing values and tied cuts", {
  values <- c(rep(0, 20), 1:11, NA_real_)
  stages <- data.frame(amount = values, end = "B")
  expect_warning(links <- data_to_sankey(stages), "amount")
  expect_identical(links$weight, c(20L, 5L, 6L))
  expect_no_warning(data_to_sankey(data.frame(code = 1:3, end = "B")))
})

test_that("Sankey assigns distinct IDs to links with the same joined labels", {
  links <- data_to_sankey(data.frame(
    a = c("ab", "a", "x"),
    b = c("c", "bc", "y")
  ))
  expect_identical(links$id, c("abc", "abc.1", "xy"))
})
