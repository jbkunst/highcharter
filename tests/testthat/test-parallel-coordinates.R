test_that("parallel coordinates retain the axis order, gaps and series options", {
  measures <- data.frame(b = c(1, NA, 3), a = rep(4, 3))
  series <- data_to_parallel_coordinates(
    measures,
    name = letters[1:3],
    color = "red"
  )
  lines <- hc_add_series_list(highchart(), series)$x$hc_opts$series
  expect_identical(
    lapply(lines, "[[", "data"),
    list(
      list(1, 4),
      list(NULL, 4),
      list(3, 4)
    )
  )
  expect_identical(vapply(lines, "[[", "", "name"), letters[1:3])
  expect_identical(vapply(lines, "[[", "", "color"), rep("red", 3))
})

test_that("parallel coordinates validate measurements and options", {
  expect_equal(
    nrow(data_to_parallel_coordinates(iris[0, 1:4], color = "red")),
    0
  )
  expect_error(data_to_parallel_coordinates(iris), "numeric column")
  expect_error(
    data_to_parallel_coordinates(iris[1:4], "red"),
    "Name each option"
  )
  expect_error(data_to_parallel_coordinates(iris[1:4], color = c("a", "b")))
})
