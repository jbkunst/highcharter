context("Testing utils")

test_that("list.parse", {
  
  result <- list(list(4, 2),
                 list(4, 10),
                 list(7, 4),
                 list(7, 22),
                 list(8, 16),
                 list(9, 10))
  
  
  expect_equal(list_parse2(head(cars)), result)
  
})
