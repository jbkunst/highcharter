test_that("presets keep regional formatting and fall back to English text", {
  expect_identical(hc_language(), list(locale = "en"))
  expect_identical(hc_language("de-DE"), list(locale = "de-DE"))
  expect_identical(hc_language("es-CL")$locale, "es-CL")
  expect_identical(hc_language("es-MX")$loading, hc_language("es")$loading)
  expect_identical(hc_language("pt-BR")$downloadCSV, "Baixar CSV")
  expect_identical(hc_language("fr-CA")$accessibility$defaultChartTitle, "Graphique")
  expect_null(hc_language("es-CL")$months)
  expect_error(hc_language("es_CL"), "language code")
  expect_error(hc_language(c("en", "es")), "language code")
  expect_error(hc_language("es", "CSV"), "Name each")
})

test_that("language overrides merge nested keys and replace arrays", {
  lang <- hc_language("es-CL", exportData = list(categoryHeader = "Producto"),
                      numericSymbols = c("K", "M"))
  expect_identical(lang$exportData$categoryHeader, "Producto")
  expect_identical(lang$exportData$annotationHeader, "Anotaciones")
  expect_identical(lang$numericSymbols, c("K", "M"))
  expect_named(hc_language("es", numericSymbols = NULL)["numericSymbols"], "numericSymbols")
  expect_identical(hc_language("es")$exportData$categoryHeader, "Categoría")
})

test_that("the default abbreviated weekdays have the Highcharts Sunday-first order", {
  expect_identical(getOption("highcharter.lang")$shortWeekdays,
                   c("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"))
})

test_that("app and per-widget languages remain independent", {
  old <- options(highcharter.lang = hc_language("es-CL", decimalPoint = ","))
  on.exit(options(old), add = TRUE)
  manual <- list(locale = "fr-CA", loading = "Patientez")
  for (widget in list(highchart(), highchartstock(), highchartzero())) {
    localized <- hc_add_language(widget, manual, noData = "Pas de données")
    expect_identical(localized$x$hc_opts$lang, c(manual, list(noData = "Pas de données")))
    expect_null(localized$x$conf_opts$lang)
    english <- hc_add_language(localized, "en")
    expect_identical(english$x$hc_opts$lang, list(locale = "en"))
  }
  expect_identical(highchart()$x$conf_opts$lang, getOption("highcharter.lang"))
  expect_identical(getOption("highcharter.lang")$locale, "es-CL")
  expect_error(hc_add_language(highchart(), list("unnamed")), "named list")
})
