# highchart ----

test_that("highchart object is a from highchart and htmlwidget class", {
  hc <- highchart()

  expect_true(all(class(hc) %in% c("highchart", "htmlwidget")))
})

test_that("single numeric values use the same point array in both series APIs", {
  series <- list(
    list(data = c(a = 7)),
    list(data = 1:3),
    list(data = numeric()),
    list(name = "empty")
  )
  batch <- hc_add_series_list(highchart(), series)$x$hc_opts$series
  expect_identical(batch[[1]]$data, list(7))
  expect_identical(
    batch[[1]],
    hc_add_series(highchart(), data = 7)$x$hc_opts$series[[1]]
  )
  expect_identical(batch[-1], series[-1])
})

test_that("export_hc appends .js only when a JavaScript extension is absent", {
  dir <- tempfile()
  dir.create(dir)
  on.exit(unlink(dir, recursive = TRUE), add = TRUE)
  hc <- highchart()
  for (filename in c(
    "sales",
    "salesjs",
    "plot.js",
    "module.mjs",
    "module.cjs"
  )) {
    export_hc(hc, file.path(dir, filename))
  }
  expect_setequal(
    list.files(dir),
    c("sales.js", "salesjs.js", "plot.js", "module.mjs", "module.cjs")
  )
})

# highchartOutput ----

test_that("highchartOutput returns a function", {
  expect_true(
    all(class(highchartOutput("outputid")) %in% c("shiny.tag.list", "list"))
  )
})

test_that("mixed widgets resolve one Highcharts bundle in either order", {
  stock <- highchart(type = "stock")
  chart <- highchart()

  for (widgets in list(list(stock, chart), list(chart, stock))) {
    deps <- htmltools::renderTags(htmltools::tagList(widgets))$dependencies
    engine <- Filter(function(dep) dep$name == "highcharts", deps)
    expect_length(engine, 1)
    expect_identical(
      engine[[1]]$script,
      c(
        "highcharter-bundle.js",
        "highcharts/custom/reset.js",
        "highcharts/custom/highcharter-widget.js"
      )
    )
  }
})

test_that("highchartstock adds Stock Tools to the shared Highcharts engine", {
  tools <- highchartstock()
  regular <- highchart()

  expect_true(is.highchart(tools))
  expect_identical(tools$x$type, "stock")

  for (widgets in list(list(regular, tools), list(tools, regular))) {
    deps <- htmltools::renderTags(htmltools::tagList(widgets))$dependencies
    expect_length(Filter(function(dep) dep$name == "highcharts", deps), 1)
    expect_length(
      Filter(function(dep) dep$name == "highcharts-stock-tools", deps),
      1
    )
  }
})

test_that("third-party plugins stay optional", {
  plain <- highchart()
  motion <- hc_motion(highchart())

  expect_false(any(vapply(
    plain$dependencies,
    function(dep) {
      identical(dep$name, "highcharts-motion")
    },
    logical(1)
  )))
  expect_true(any(vapply(
    motion$dependencies,
    function(dep) {
      identical(dep$name, "highcharts-motion")
    },
    logical(1)
  )))
})

test_that("community plugins resolve to files and legacy modules explain migration", {
  chart <- highchart()
  plugin <- hc_add_dependency(chart, "plugins/highcharts-regression.js")
  dep <- tail(plugin$dependencies, 1)[[1]]
  expect_true(file.exists(file.path(dep$src$file, dep$script)))
  expect_error(
    hc_add_dependency(chart, "modules/pattern-fill.js"),
    "built-in modules"
  )
  expect_error(
    hc_add_dependency(chart, "modules/stock-tools.js"),
    "highchartstock"
  )
  expect_error(
    hc_add_dependency(chart, "plugins/missing.js"),
    "Choose a packaged plugin"
  )
})

test_that("repeated responsive rules replace the array and keep sibling options", {
  rule <- function(width) list(condition = list(maxWidth = width))
  chart <- highchart() |>
    hc_responsive(rules = list(rule(300), rule(500))) |>
    hc_responsive(rules = list(rule(900))) |>
    hc_xAxis(labels = list(rotation = 30), plotLines = list(list(value = 1))) |>
    hc_xAxis(labels = list(rotation = NULL), plotLines = list(list(value = 2)))
  expect_identical(chart$x$hc_opts$responsive$rules, list(rule(900)))
  axis <- chart$x$hc_opts$xAxis
  expect_identical(axis$plotLines, list(list(value = 2)))
  expect_false("rotation" %in% names(axis$labels))
})

test_that("Highcharts options require names and collections accept complete objects", {
  hc <- highchart()
  expect_identical(hc_title(hc), hc)
  expect_identical(hc_title(hc, text = "Sales")$x$hc_opts$title$text, "Sales")
  expect_error(hc_title(hc, "Sales"), "Name each option in hc_title")
  expect_error(hc_caption(hc, "Sales"), "Name each option in hc_caption")
  expect_error(
    hc_title(hc, text = "Sales", "left"),
    "Name each option in hc_title"
  )
  expect_error(
    hc_add_annotation(hc, "Sales"),
    "Name each option in hc_add_annotation"
  )

  points <- list(list(x = 1, y = 2))
  expect_identical(hc_add_series(hc, points)$x$hc_opts$series[[1]]$data, points)
  expect_error(
    hc_add_series(hc, points, "line"),
    "Name each option in hc_add_series"
  )
  expect_error(
    hchart(iris, "scatter", hcaes(Sepal.Length, Sepal.Width), 3),
    "Name each option"
  )
  for (key in c("series", "annotations", "colorAxis", "pane")) {
    setter <- get(paste0("hc_", key))
    chart <- setter(hc, list(id = "a"), list(id = "b"))
    expect_identical(
      chart$x$hc_opts[[key]],
      list(list(id = "a"), list(id = "b"))
    )
    expect_error(setter(hc, list("a")), "Name each option")
    expect_error(setter(hc, list(id = "a"), id = "b"), "Name each option")
  }
})
