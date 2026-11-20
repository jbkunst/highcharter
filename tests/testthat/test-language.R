test_that("presets keep regional formatting and fall back to English text", {
  expect_identical(hc_language(), list(locale = "en"))
  expect_identical(hc_language("de-DE"), list(locale = "de-DE"))
  expect_identical(hc_language("es-CL")$locale, "es-CL")
  for (locale in c("es-CL", "es-MX", "es-CO", "es-ES")) {
    spanish <- hc_language("es")
    spanish$locale <- locale
    expect_identical(hc_language(locale), spanish)
  }
  expect_identical(hc_language("pt-BR")$downloadCSV, "Baixar CSV")
  expect_identical(
    hc_language("fr-CA")$accessibility$defaultChartTitle,
    "Graphique"
  )
  expect_identical(hc_language("fr-FR")$downloadCSV, "Télécharger CSV")
  expect_identical(hc_language("nb-NO")$downloadCSV, "Last ned CSV")
  expect_identical(hc_language("nb")$viewData, "Vis datatabell")
  expect_identical(hc_language("nb-no")$locale, "nb-no")
  expect_null(hc_language("es-CL")$months)
  expect_identical(hc_language("ja-JP")$downloadCSV, "CSVをダウンロード")
  expect_equal(hc_language("ja-JP")$numericSymbolMagnitude, 10000)
  expect_identical(hc_language("ja-JP")$numericSymbols[1], "万")
  expect_identical(hc_language("ko-KR")$downloadCSV, "CSV 다운로드")
  expect_equal(hc_language("ko-KR")$numericSymbolMagnitude, 10000)
  expect_identical(hc_language("ko-KR")$numericSymbols[2], "억")
  expect_identical(hc_language("zh-CN")$downloadCSV, "下载 CSV")
  expect_identical(
    hc_language("zh-Hans")$viewData,
    hc_language("zh-CN")$viewData
  )
  expect_identical(hc_language("zh-TW"), list(locale = "zh-TW"))
  expect_error(hc_language("es_CL"), "language code")
  expect_error(hc_language(c("en", "es")), "language code")
  expect_error(hc_language("es", "CSV"), "Name each")
})

test_that("language overrides merge nested keys and replace arrays", {
  lang <- hc_language(
    "es-CL",
    exportData = list(categoryHeader = "Producto"),
    numericSymbols = c("K", "M")
  )
  expect_identical(lang$exportData$categoryHeader, "Producto")
  expect_identical(lang$exportData$annotationHeader, "Anotaciones")
  expect_identical(lang$numericSymbols, c("K", "M"))
  expect_named(
    hc_language("es", numericSymbols = NULL)["numericSymbols"],
    "numericSymbols"
  )
  expect_identical(hc_language("es")$exportData$categoryHeader, "Categoría")
})

test_that("widgets use the English preset and omit unset global options", {
  old <- options(highcharter.global = NULL)
  on.exit(options(old))
  expect_identical(highchart()$x$conf_opts, list(lang = hc_language("en")))

  global <- list(buttonTheme = list(fill = "white"))
  options(highcharter.global = global)
  expect_identical(highchart()$x$conf_opts$global, global)
  expect_identical(highchartstock()$x$conf_opts$global, global)
})

test_that("the setter snapshots the language for new widgets and restores the option", {
  manual <- list(loading = "Initial text")
  old <- options(highcharter.lang = manual)
  on.exit(options(old), add = TRUE)

  result <- withVisible(hc_set_language("es", loading = "Un momento"))
  expect_false(result$visible)
  expect_identical(result$value, list(highcharter.lang = manual))
  spanish <- hc_language("es", loading = "Un momento")
  expect_identical(getOption("highcharter.lang"), spanish)

  chart <- highchart()
  stock <- highchartstock()
  custom <- highchart(hc_opts = list(lang = manual))
  hc_set_language("pt")
  expect_identical(chart$x$conf_opts$lang, spanish)
  expect_identical(stock$x$conf_opts$lang, spanish)
  expect_identical(custom$x$hc_opts$lang, manual)
  expect_identical(highchart()$x$conf_opts$lang, hc_language("pt"))

  expect_error(hc_set_language("es_CL"), "language code")
  expect_identical(getOption("highcharter.lang"), hc_language("pt"))
  options(result$value)
  expect_identical(getOption("highcharter.lang"), manual)
})
