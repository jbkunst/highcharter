#' Set the default language for Highcharts widgets
#'
#' `hc_set_language()` sets the `highcharter.lang` option for charts created
#' afterwards in the current R process. `hc_language()` builds a language
#' list with the same arguments and leaves the current option unchanged.
#'
#' @param locale Use a language code: `"en"` (English), `"es"` (Spanish),
#'   `"pt"` (Portuguese) or `"fr"` (French). A region is optional: `"es-MX"`
#'   uses the same Spanish labels as `"es"` with Mexican date and number
#'   formatting. Other languages use English labels and their own formatting.
#' @param ... Named Highcharts `lang` options to override, including nested
#'   lists such as `exportData = list(categoryHeader = "Product")`.
#' @return `hc_language()` returns a Highcharts `lang` list.
#'   `hc_set_language()` invisibly returns the previous option.
#' @details The Spanish and Portuguese presets cover common chart controls, downloads,
#'   Stock range selection and basic accessibility labels. Highcharts supplies
#'   the English defaults for untranslated text and the French language pack.
#' @examples
#' hc_set_language("es")
#' highchart() |> hc_add_series(data = c(3, 1, 4))
#' @export
hc_language <- function(locale = "en", ...) {
  if (!is.character(locale) || length(locale) != 1L || is.na(locale) ||
      !grepl("^[A-Za-z]{2,3}(-[A-Za-z]{4})?(-([A-Za-z]{2}|[0-9]{3}))?$", locale)) {
    stop("Use a language code such as 'en', 'es', 'pt' or 'fr', optionally with a region.", call. = FALSE)
  }
  code <- tolower(sub("-.*", "", locale))
  lang <- list()
  if (code %in% c("es", "pt", "fr")) {
    path <- system.file("lang", paste0(code, ".json"), package = "highcharter", mustWork = TRUE)
    lang <- jsonlite::fromJSON(path)
  }
  lang$locale <- locale
  overrides <- list(...)
  if (length(overrides) && (is.null(names(overrides)) || any(!nzchar(names(overrides))))) {
    stop("Name each Highcharts lang override.", call. = FALSE)
  }
  utils::modifyList(lang, overrides, keep.null = TRUE)
}

#' @rdname hc_language
#' @export
hc_set_language <- function(locale, ...) {
  options(highcharter.lang = hc_language(locale, ...))
}
