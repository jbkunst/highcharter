test_that("hierarchy IDs are unique and children retain their original parent path", {
  sales <- data.frame(
    zone = c("San Pedro", "San_Pedro", "Talca", "San Pedro", "Talca_Centro"),
    store = "Centro",
    desk = "A",
    sales = c(3, 2, 1, 4, 1)
  )
  nodes <- data_to_hierarchical(sales, c(zone, store, desk), sales)
  tree <- dplyr::bind_rows(nodes)
  expect_identical(anyDuplicated(tree$id), 0L)
  roots <- tree[tree$level == 1, ]
  stores <- tree[tree$level == 2, ]
  leaves <- tree[tree$level == 3, ]
  store <- match(leaves$parent, stores$id)
  zone <- roots$name[match(stores$parent[store], roots$id)]
  expect_equal(
    setNames(leaves$value, zone)[sales$zone[1:3]],
    c("San Pedro" = 7, San_Pedro = 2, Talca = 1)
  )
  expect_equal(sum(leaves$value), sum(sales$sales))
  expect_identical(roots$id[roots$name == "Talca"], "talca")
  expect_true(all(!is.na(zone)))
})

test_that("hierarchies preserve single levels, colors and empty input", {
  data <- data.frame(group = factor(c("B", "A", "A")), size = c(1, 2, 3))
  nodes <- data_to_hierarchical(data, group, size, colors = "red")
  expect_identical(
    nodes[[1]],
    list(name = "A", id = "a", color = "red", value = 5, level = 1L)
  )
  expect_null(data_to_hierarchical(data, group, size, colors = NULL)[[1]]$color)
  expect_identical(data_to_hierarchical(data[0, ], group, size), list())
})
