test_that("axis wrappers accept collections and preserve other axes on named updates", {
  x <- list(list(id = "lower"), list(id = "upper", opposite = TRUE))
  for (setter in list(hc_xAxis, hc_yAxis, hc_zAxis)) {
    chart <- setter(highchart(), x)
    expect_equal(setter(highchart(), x[[1]], x[[2]]), chart)
    expect_error(setter(chart, list(id = "one"), opposite = TRUE), "named axis")
    expect_error(setter(chart, 2), "Each axis")
  }
  chart <- highchart() |> hc_xAxis(x) |> hc_xAxis(title = list(text = "Months"))
  expect_identical(chart$x$hc_opts$xAxis[[2]], x[[2]])
  expect_identical(chart$x$hc_opts$xAxis[[1]]$id, "lower")
  expect_identical(chart$x$hc_opts$xAxis[[1]]$title$text, "Months")
  opts <- create_axis(
    2,
    heights = c(3, 1),
    sep = 0,
    title = list(text = "Value")
  )
  expect_identical(opts[[1]]$height, "75%")
  expect_identical(opts[[2]]$top, "75%")
  expect_identical(opts[[2]]$title, list(text = "Value"))
  expect_warning(hc_yAxis_multiples(highchart(), x), "deprecated")
})

test_that("a single axis category stays an array when serialized", {
  for (category in list(2012, "one")) {
    chart <- hc_xAxis(highchart(), categories = category)
    expect_identical(chart$x$hc_opts$xAxis$categories, list(category))
  }

  axes <- list(
    list(categories = c("one", "two")),
    list(categories = c(year = 2012))
  )
  chart <- hc_yAxis(highchart(), axes)
  expect_identical(chart$x$hc_opts$yAxis[[1]]$categories, c("one", "two"))
  expect_identical(chart$x$hc_opts$yAxis[[2]]$categories, list(2012))
  chart <- hc_yAxis(chart, categories = "one")
  expect_identical(chart$x$hc_opts$yAxis[[1]]$categories, list("one"))
  expect_identical(chart$x$hc_opts$yAxis[[2]]$categories, list(2012))
})

test_that("annotation rows keep label options and anchor to the requested axes", {
  notes <- data.frame(x = c(2, 4), y = c(5, 8), text = c("A", "B"))
  notes$style <- list(list(color = "red"), list(color = "blue"))
  labels <- data_to_annotation_labels(notes, xAxis = "months", yAxis = 1)
  expect_identical(
    labels[[2]]$point,
    list(x = 4, y = 8, xAxis = "months", yAxis = 1)
  )
  expect_identical(labels[[2]]$text, "B")
  expect_identical(labels[[2]]$style, notes$style[[2]])
  expect_identical(data_to_annotation_labels(notes[0, ]), list())
  expect_error(data_to_annotation_labels(notes["x"]))

  chart <- highchart() |>
    hc_add_annotation(id = "first") |>
    hc_add_annotation(labels = labels)
  expect_identical(
    chart$x$hc_opts$annotations,
    list(list(id = "first"), list(labels = labels))
  )
})
