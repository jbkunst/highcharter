test_that("the packaged presets produce themes for widgets", {
  presets <- hc_themes()
  expect_setequal(
    presets,
    c(
      "538",
      "alone",
      "bloom",
      "bslib",
      "carbon",
      "chalk",
      "cloudscape",
      "darkunica",
      "db",
      "economist",
      "elementary",
      "ffx",
      "flat",
      "flatdark",
      "ft",
      "ggplot2",
      "google",
      "gridlight",
      "handdrawn",
      "hcrt",
      "monokai",
      "null",
      "sandsignika",
      "smpl",
      "sparkline",
      "sparkline_vb",
      "superheroes",
      "tufte"
    )
  )
  for (name in presets) {
    theme <- hc_theme(name)
    expect_s3_class(theme, "hc_theme")
    expect_identical(hc_add_theme(highchart(), theme)$x$theme, theme)
  }
  expect_identical(hc_theme("ft")$chart$backgroundColor, "#FFF1E5")
  expect_equal(length(unique(hc_theme("economist")$colors)), 6)
  expect_identical(hc_theme("carbon")$colors[1], "#6929C4")
  for (name in c("hcrt", "smpl")) {
    expect_identical(hc_theme(name)$symbols, rep("circle", 5))
  }
  cloudscape <- hc_theme("cloudscape")
  expect_length(cloudscape$colors, 10)
  expect_identical(cloudscape$colors[1:2], c("#688AE8", "#C33D69"))
  for (theme in list(hc_theme("carbon"), cloudscape)) {
    expect_identical(theme$symbols, rep("circle", 5))
    expect_equal(theme$xAxis$gridLineWidth, 1)
    expect_equal(theme$yAxis$gridLineWidth, 1)
  }
  expect_identical(
    hc_theme("superheroes")$xAxis$gridLineDashStyle,
    hc_theme("flat")$xAxis$gridLineDashStyle
  )
  expect_s3_class(hc_theme("sparkline")$tooltip$positioner, "JS_EVAL")
})

test_that("textured presets embed the original files in the widget", {
  files <- c(
    chalk = "chalk.jpg",
    handdrawn = "handdrawn.jpg",
    sandsignika = "sand.png"
  )
  for (name in names(files)) {
    image <- highchart(theme = hc_theme(name))$x$theme$chart$divBackgroundImage
    expect_match(image, "^data:image/(jpeg|png);base64,")
    expect_false(grepl("\n", image, fixed = TRUE))
    file <- system.file(
      "themes",
      "backgrounds",
      files[[name]],
      package = "highcharter"
    )
    expect_identical(
      jsonlite::base64_dec(sub("^[^,]*,", "", image)),
      readBin(file, "raw", file.size(file))
    )
  }
})

test_that("themes merge nested options, preserving null fields and replacing arrays", {
  gradient <- list(stops = list(list(0, "white"), list(1, "blue")))
  theme <- hc_theme("darkunica", chart = list(backgroundColor = gradient))
  expect_identical(theme$chart$backgroundColor$stops, gradient$stops)
  expect_true("linearGradient" %in% names(theme$chart$backgroundColor))
  expect_identical(hc_theme(colors = "red")$colors, list("red"))
  replacement <- hc_theme(
    chart = list(backgroundColor = NULL),
    colors = c("red", "blue")
  )
  combined <- hc_theme_merge(theme, replacement)
  expect_true("backgroundColor" %in% names(combined$chart))
  expect_null(combined$chart$backgroundColor)
  expect_identical(combined$colors, replacement$colors)
  expect_identical(combined$chart$style, theme$chart$style)
  expect_error(hc_theme("ft", list()), "Name each")
})

test_that("the setter snapshots names and custom themes for each widget", {
  old <- options("highcharter.theme")
  on.exit(options(old))
  previous <- hc_set_theme("ft")
  expect_identical(previous, old)
  first <- highchart()
  theme <- hc_theme(colors = c("#005F73", "#CA6702"))
  hc_set_theme(theme)
  expect_identical(first$x$theme, hc_theme("ft"))
  expect_identical(highchartstock()$x$theme, theme)
  expect_identical(highchart()$x$theme, theme)
  expect_identical(highchart(theme = first$x$theme)$x$theme, first$x$theme)
  expect_error(hc_set_theme("../ft"), "Choose a theme")
  expect_identical(getOption("highcharter.theme"), theme)
})

test_that("widgets keep only the font families in their theme and options", {
  fonts <- function(hc) unname(vapply(hc$dependencies, "[[", "", "name"))
  ibm <- "highcharter-font-ibm-plex-sans"
  title <- "highcharter-font-alegreya-sans-sc"
  chart <- highchart(theme = hc_theme("hcrt"))
  expect_setequal(fonts(chart), c(ibm, title))
  expect_identical(fonts(hc_add_theme(chart, hc_theme("carbon"))), ibm)

  chart <- chart |>
    hc_title(style = list(fontFamily = "system-ui")) |>
    hc_add_series(
      data = 1:3,
      dataLabels = list(style = list(fontFamily = "IBM Plex Sans"))
    )
  expect_identical(fonts(chart), ibm)
  expect_identical(fonts(hc_add_theme(chart, hc_theme("bslib"))), ibm)
  expect_length(fonts(highchart(theme = hc_theme("bslib"))), 0L)

  point <- list(
    y = 1,
    dataLabels = list(style = list(fontFamily = "Alegreya Sans SC"))
  )
  chart <- highchart(theme = hc_theme()) |> hc_add_series(data = list(point))
  expect_identical(fonts(chart), title)
  expect_match(chart$dependencies[[1L]]$src$file, "alegreya-sans-sc$")
})

test_that("explicit web fonts survive theme merges and reach the widget as CSS", {
  skip_if_not_installed("sass")
  font <- sass::font_google("Noto Sans", local = FALSE)
  custom <- hc_theme(chart = list(style = list(fontFamily = font)))
  combined <- hc_theme_merge(hc_theme("carbon"), custom)
  old <- hc_set_theme(combined)
  on.exit(options(old), add = TRUE)

  chart <- highchartstock()
  expect_identical(
    as.character(chart$x$theme$chart$style$fontFamily),
    "'Noto Sans'"
  )
  expect_length(chart$dependencies, 1L)
  expect_match(
    chart$dependencies[[1L]]$head,
    "fonts.googleapis.com",
    fixed = TRUE
  )

  chart <- chart |>
    hc_add_theme(hc_theme("carbon")) |>
    hc_title(style = list(fontFamily = font))
  expect_length(chart$dependencies, 2L)
  chart <- hc_title(chart, style = list(fontFamily = "system-ui"))
  expect_identical(
    chart$dependencies[[1L]]$name,
    "highcharter-font-ibm-plex-sans"
  )
  expect_length(chart$dependencies, 1L)
})
