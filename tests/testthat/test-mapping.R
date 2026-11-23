test_that("mappings evaluate in their original environment and label computed axes", {
  make_mappings <- function(scale) {
    list(hcaes(tick, rate * scale), hcaes_string("tick", "rate * scale"))
  }
  df <- data.frame(tick = 1:2, rate = c(0.03, NA), note = c("first", "gap"))
  for (mapping in make_mappings(100)) {
    opts <- hchart(df, "line", mapping)$x$hc_opts
    expect_identical(opts$yAxis$title$text, "rate * scale")
    expect_identical(opts$series[[1]]$data[[1]]$y, 3)
    expect_identical(opts$series[[1]]$data[[2]]$note, "gap")
    expect_identical(
      mutate_mapping(df, mapping, drop = TRUE),
      data.frame(x = 1:2, y = c(3, NA))
    )
  }

  df[["net rate"]] <- df$rate
  from_column <- function(column) hcaes(y = {{ column }})
  expect_identical(mutate_mapping(df, from_column(`net rate`))$y, df$rate)
  expect_identical(
    mutate_mapping(df, hcaes_string(y = "`net rate`"))$y,
    df$rate
  )
  expect_identical(mutate_mapping(df, hcaes(y = "rate"))$y, df$rate)
  legacy <- structure(
    list(x = "tick", y = quote(rate * 100)),
    class = c("hcaes", "uneval")
  )
  expect_identical(
    mutate_mapping(df, legacy, TRUE),
    data.frame(x = 1:2, y = c(3, NA))
  )
  expect_identical(mutate_mapping(df, hcaes()), df)
  reserved <- mutate_mapping(df, hcaes(series = note), drop = TRUE)
  expect_identical(names(reserved), "seriess")
  expect_error(hcaes(tick, rate, note), "Name each mapping")
  expect_error(hcaes_string("tick", "rate", "note"), "Name each mapping")
  expect_error(mutate_mapping(df, hcaes(y = unknown_rate)), "unknown_rate")
})

test_that("group indices preserve group and point order, extras and missing values", {
  df <- data.frame(
    tick = 1:5,
    rate = c(1, 2, 3, NA, 5),
    team = factor(c("A", NA, "B", "A", "B"), levels = c("B", "unused", "A"))
  )
  df$custom <- lapply(df$tick, function(i) list(id = i))
  mapping <- hcaes(tick, rate, group = team)
  hc <- hchart(df, "line", mapping, lineWidth = 3)
  series <- hc$x$hc_opts$series
  added <- hc_add_series(highchart(), df, "line", mapping, lineWidth = 3)
  expect_identical(added$x$hc_opts$series, series)
  expect_identical(vapply(series, "[[", "", "name"), c("B", "A", NA_character_))
  xs <- lapply(series, function(s) vapply(s$data, "[[", 1L, "x"))
  expect_identical(xs, list(c(3L, 5L), c(1L, 4L), 2L))
  expect_identical(series[[2]]$data[[2]]$custom, list(id = 4L))
  expect_identical(series[[2]]$data[[2]]$y, NA_real_)
  expect_null(hc$x$hc_opts$plotOptions$series$showInLegend)
  expect_length(hchart(df[0, ], "line", mapping)$x$hc_opts$series, 0)

  df$group <- df$team
  ungrouped <- hchart(df, mapping = hcaes(y = rate))$x$hc_opts
  expect_null(ungrouped$plotOptions$series$showInLegend)
  expect_null(ungrouped$series[[1]]$type)
  expect_length(ungrouped$series[[1]]$data, 5)
  expect_length(hchart(df[0, ], mapping = hcaes(y = rate))$x$hc_opts$series, 0)
})

test_that("factor levels set x-axis category order across grouped series", {
  df <- data.frame(
    priority = factor(
      c("Low", "High", "Medium"),
      levels = c("High", "Medium", "Low")
    ),
    team = factor(c("A", "B", "A"), levels = c("B", "A")),
    count = c(2, 8, 5)
  )
  mapping <- hcaes(priority, count, group = team)
  opts <- hchart(df, "column", mapping)$x$hc_opts
  expect_identical(opts$xAxis$categories, levels(df$priority))
  expect_identical(vapply(opts$series, "[[", "", "name"), levels(df$team))

  df$priority <- as.character(df$priority)
  expect_null(hchart(df, "column", mapping)$x$hc_opts$xAxis$categories)
})

test_that("point colors, bubble sizes and date-time axes preserve their values", {
  df <- data.frame(
    tick = as.POSIXct("2025-01-01", tz = "UTC") + 0:2,
    rate = 1:3,
    volume = c(10, 20, 5),
    hex = c("#0072B2", NA, "#D55E00")
  )
  opts <- hchart(
    df,
    "point",
    hcaes(tick, rate, size = volume, color = hex)
  )$x$hc_opts
  series <- opts$series[[1]]
  expect_identical(opts$xAxis$type, "datetime")
  expect_identical(series$type, "bubble")
  expect_identical(
    vapply(series$data, "[[", 1, "x"),
    datetime_to_timestamp(df$tick)
  )
  expect_identical(vapply(series$data, "[[", 1, "z"), df$volume)
  expect_identical(vapply(series$data, "[[", "", "color"), df$hex)
  opts <- hchart(df, "line", hcaes(y = tick))$x$hc_opts
  expect_identical(opts$yAxis$type, "datetime")
  expect_identical(
    vapply(opts$series[[1]]$data, "[[", 1, "y"),
    datetime_to_timestamp(df$tick)
  )

  df$level <- factor(c("A", "C", NA), levels = c("A", "B", "C"))
  points <- hchart(
    df,
    "scatter",
    hcaes(tick, rate, color = level)
  )$x$hc_opts$series[[1]]$data
  expect_identical(vapply(points, "[[", "", "color"), colorize(c("A", "C", NA)))
})

test_that("xrange converts both date endpoints and preserves numeric coordinates", {
  for (start in list(
    as.Date("2025-01-06") + 0:1,
    as.POSIXct("2025-01-06 08:45:00", tz = "America/Santiago") + 0:1,
    c(0.5, 1.5)
  )) {
    end <- start + 2
    end[2] <- NA
    rows <- data.frame(x = start, x2 = end, y = 0:1)
    mapping <- hcaes(x = x, x2 = x2, y = y)
    series <- hchart(rows, "xrange", mapping)$x$hc_opts$series
    points <- series[[1]]$data
    timestamp <- function(x) if (is.numeric(x)) x else datetime_to_timestamp(x)
    expect_identical(vapply(points, "[[", 0, "x"), timestamp(start))
    expect_identical(vapply(points, "[[", 0, "x2"), timestamp(end))
    direct <- hchart(rows, "xrange")
    expect_identical(direct$x$hc_opts$series[[1]]$data, points)
    added <- hc_add_series(highchart(), rows, "xrange")
    expect_identical(added$x$hc_opts$series[[1]]$data, points)
  }
})

test_that("heatmap coordinates agree with their axes and cell sizes", {
  cells <- data.frame(
    day = as.Date("2026-11-18") + c(0, 2, 5),
    store = factor(c("North", "South", "North"), levels = c("South", "North")),
    value = c(5, 3, 7)
  )
  mapping <- hcaes(day, store, value = value)
  opts <- hchart(cells, "heatmap", mapping)$x$hc_opts
  series <- opts$series[[1]]
  expect_identical(opts$xAxis$type, "datetime")
  expect_null(opts$xAxis$categories)
  expect_identical(opts$yAxis$categories, levels(cells$store))
  expect_equal(
    vapply(series$data, "[[", 0, "x"),
    datetime_to_timestamp(cells$day)
  )
  expect_equal(vapply(series$data, "[[", 0, "y"), c(1, 0, 1))
  expect_equal(series$colsize, 86400000)
  added <- hc_add_series(highchart(), cells, "heatmap", mapping)
  expect_identical(added$x$hc_opts$series, opts$series)

  cells$time <- as.POSIXct("2026-11-18", tz = "UTC") + c(5400, 0, 1800)
  mapping <- hcaes(store, time, value = value)
  opts <- hchart(cells, "heatmap", mapping)$x$hc_opts
  expect_identical(opts$yAxis$type, "datetime")
  expect_null(opts$yAxis$categories)
  expect_equal(opts$series[[1]]$rowsize, 1800000)
  expect_equal(
    vapply(opts$series[[1]]$data, "[[", 0, "y"),
    datetime_to_timestamp(cells$time)
  )
  custom <- hchart(cells, "heatmap", mapping, rowsize = 60000)
  expect_equal(custom$x$hc_opts$series[[1]]$rowsize, 60000)
  single <- hchart(cells[1, ], "heatmap", hcaes(y = time, value = value))
  expect_equal(single$x$hc_opts$series[[1]]$rowsize, 1000)
  expect_null(single$x$hc_opts$series[[1]]$data[[1]]$x)

  cells$store <- "Centro"
  opts <- hchart(cells, "heatmap", hcaes(store, value = value))$x$hc_opts
  expect_identical(opts$xAxis$categories, list("Centro"))
  expect_null(opts$series[[1]]$data[[1]]$y)
})
