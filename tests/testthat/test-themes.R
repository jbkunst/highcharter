test_that("the packaged presets produce themes for widgets", {
  presets <- hc_themes()
  expect_setequal(presets, c(
    "538", "alone", "bloom", "bslib", "carbon", "chalk", "darkunica", "db",
    "economist", "elementary", "ffx", "flat", "flatdark", "ft", "ggplot2",
    "google", "gridlight", "handdrawn", "hcrt", "monokai", "null", "sandsignika",
    "smpl", "sparkline", "sparkline_vb", "superheroes", "tufte"
  ))
  for (name in presets) {
    theme <- hc_theme(name)
    expect_s3_class(theme, "hc_theme")
    expect_identical(hc_add_theme(highchart(), theme)$x$theme, theme)
  }
  expect_identical(hc_theme("ft")$chart$backgroundColor, "#FFF1E5")
  expect_equal(length(unique(hc_theme("economist")$colors)), 6)
  expect_identical(hc_theme("carbon")$colors[1], "#6929C4")
  expect_identical(hc_theme("carbon")$plotOptions$series$marker$symbol, "circle")
  expect_identical(hc_theme("superheroes")$xAxis$gridLineDashStyle, hc_theme("flat")$xAxis$gridLineDashStyle)
  expect_s3_class(hc_theme("sparkline")$tooltip$positioner, "JS_EVAL")
})

test_that("textured presets embed the original files in the widget", {
  files <- c(chalk = "chalk.jpg", handdrawn = "handdrawn.jpg", sandsignika = "sand.png")
  for (name in names(files)) {
    image <- highchart(theme = hc_theme(name))$x$theme$chart$divBackgroundImage
    expect_match(image, "^data:image/(jpeg|png);base64,")
    expect_false(grepl("\n", image, fixed = TRUE))
    file <- system.file("themes", "backgrounds", files[[name]], package = "highcharter")
    expect_identical(jsonlite::base64_dec(sub("^[^,]*,", "", image)), readBin(file, "raw", file.size(file)))
  }
  carbon <- hc_theme("carbon")
  expect_equal(carbon$xAxis$gridLineWidth, 1)
  expect_equal(carbon$yAxis$gridLineWidth, 1)
})

test_that("themes merge nested options, preserving null fields and replacing arrays", {
  gradient <- list(stops = list(list(0, "white"), list(1, "blue")))
  theme <- hc_theme("darkunica", chart = list(backgroundColor = gradient))
  expect_identical(theme$chart$backgroundColor$stops, gradient$stops)
  expect_true("linearGradient" %in% names(theme$chart$backgroundColor))
  expect_identical(hc_theme(colors = "red")$colors, list("red"))
  replacement <- hc_theme(chart = list(backgroundColor = NULL), colors = c("red", "blue"))
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
  expect_identical(highchartzero()$x$theme, theme)
  expect_identical(highchart(theme = first$x$theme)$x$theme, first$x$theme)
  expect_error(hc_set_theme("../ft"), "Choose a theme")
  expect_identical(getOption("highcharter.theme"), theme)
})

test_that("CSS font variables do not create Google Fonts requests", {
  expect_length(highchart(theme = hc_theme("bslib"))$x$fonts, 0)
  off <- highchart(google_fonts = FALSE)
  expect_length(hc_add_theme(off, hc_theme("carbon"))$x$fonts, 0)
  expect_identical(unname(highchart(theme = hc_theme("carbon"), google_fonts = TRUE)$x$fonts),
                   "IBM+Plex+Sans")
})
