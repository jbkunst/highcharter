#' Language presets for Highcharts widgets
#'
#' @param locale A language code, optionally with a script and region, such as
#'   `"es-CL"`, `"pt-BR"` or `"fr-CA"`. Spanish, Portuguese and French have
#'   translated controls. Other languages use Highcharts' English interface.
#'   The browser formats dates and numbers for the requested locale.
#' @param ... Named Highcharts `lang` options to override, including nested
#'   lists such as `exportData = list(categoryHeader = "Product")`.
#' @param hc A highchart widget.
#' @param language A locale string or a named list of Highcharts `lang` options,
#'   including an existing hand-written translation.
#' @return `hc_language()` returns a plain list suitable for the
#'   `highcharter.lang` option. `hc_add_language()` returns the widget with
#'   its language replaced. Supply chart-specific overrides in `...`.
#' @details Set `options(highcharter.lang = ...)` at application startup for
#'   a shared default. Inside a Shiny session, use `hc_add_language()` in the
#'   render expression to choose a language for that viewer.
#'
#'   The Spanish and Portuguese presets cover common chart controls, downloads,
#'   Stock range selection and basic accessibility labels. Highcharts supplies
#'   the English defaults for untranslated text and the French language pack.
#' @examples
#' old <- options(highcharter.lang = hc_language("es-CL"))
#' highchart() |> hc_add_series(data = c(3, 1, 4))
#' options(old)
#'
#' highchart() |>
#'   hc_add_series(data = c(3, 1, 4)) |>
#'   hc_add_language("pt-BR", loading = "Aguarde...")
#' @export
hc_language <- function(locale = "en", ...) {
  if (!is.character(locale) || length(locale) != 1L || is.na(locale) ||
      !grepl("^[A-Za-z]{2,3}(-[A-Za-z]{4})?(-([A-Za-z]{2}|[0-9]{3}))?$", locale)) {
    stop("Use a language code such as 'en', 'es-CL', 'pt-BR' or 'fr-CA'.", call. = FALSE)
  }
  code <- tolower(sub("-.*", "", locale))
  lang <- list()
  if (code %in% c("es", "pt", "fr")) {
    path <- system.file("lang", paste0(code, ".json"), package = "highcharter", mustWork = TRUE)
    lang <- jsonlite::fromJSON(path)
  }
  lang$locale <- locale
  .merge_language(lang, list(...))
}

#' @rdname hc_language
#' @export
hc_add_language <- function(hc, language, ...) {
  assertthat::assert_that(is.highchart(hc))
  lang <- if (is.character(language)) hc_language(language) else language
  if (!is.list(lang) || !length(lang) || is.null(names(lang)) || anyNA(names(lang)) ||
      any(!nzchar(names(lang)))) {
    stop("Use a locale string or a named list of Highcharts lang options.", call. = FALSE)
  }
  # A local language replaces the app default, including its date/number overrides.
  hc$x$conf_opts$lang <- NULL
  hc$x$hc_opts$lang <- .merge_language(lang, list(...))
  hc
}

.merge_language <- function(lang, overrides) {
  if (length(overrides) && (is.null(names(overrides)) || any(!nzchar(names(overrides))))) {
    stop("Name each Highcharts lang override.", call. = FALSE)
  }
  utils::modifyList(lang, overrides, keep.null = TRUE)
}
