#' Create, list and select chart themes
#'
#' A theme contains Highcharts options shared by one or more charts. Start
#' from a packaged preset or supply your own named Highcharts options.
#'
#' @param preset A name returned by `hc_themes()`, or `NULL` to start from
#'   an empty theme.
#' @param ... Named Highcharts options. Nested options override individual
#'   fields. Arrays such as `colors` and gradient stops are replaced in full.
#' @param theme A preset name or an object created with `hc_theme()`.
#' @return `hc_theme()` returns an `hc_theme` object. `hc_themes()` lists the
#'   available preset names. `hc_set_theme()` sets `highcharter.theme` for
#'   subsequent charts in the R process and invisibly returns the previous option.
#' @seealso [hc_add_theme()], [hc_theme_merge()], `vignette("themes", package = "highcharter")`
#' @examples
#' hc_themes()
#' highchart(theme = hc_theme("ft")) |> hc_add_series(data = c(3, 1, 4))
#' team <- hc_theme("carbon", colors = c("#005F73", "#CA6702"))
#' old <- hc_set_theme(team)
#' highchart() |> hc_add_series(data = c(3, 1, 4))
#' options(old)
#' @export
hc_theme <- function(preset = NULL, ...) {
  base <- if (is.null(preset)) list() else .read_theme_preset(preset)
  options <- validate_args("hc_theme", list(...))
  # htmlwidgets unboxes a one-element vector; Highcharts expects a color array.
  if (is.character(options$colors) && length(options$colors) == 1L) {
    options$colors <- as.list(options$colors)
  }
  structure(.merge_options(base, options, keep_null = TRUE), class = "hc_theme")
}

#' @rdname hc_theme
#' @export
hc_themes <- function() {
  files <- list.files(
    system.file("themes", package = "highcharter", mustWork = TRUE),
    pattern = "\\.yml$"
  )
  sub("\\.yml$", "", files)
}

.read_theme_preset <- function(name, parents = character()) {
  presets <- hc_themes()
  if (!is.character(name) || length(name) != 1L || !name %in% presets) {
    stop(
      "Choose a theme from: ",
      paste(presets, collapse = ", "),
      ".",
      call. = FALSE
    )
  }
  if (name %in% parents) {
    stop(
      "Circular theme inheritance: ",
      paste(c(parents, name), collapse = " -> "),
      call. = FALSE
    )
  }
  path <- system.file(
    "themes",
    paste0(name, ".yml"),
    package = "highcharter",
    mustWork = TRUE
  )
  theme <- yaml::read_yaml(
    path,
    handlers = list(js = htmlwidgets::JS, image = .theme_image),
    eval.expr = FALSE
  )
  if (is.null(theme$extends)) {
    return(theme)
  }
  base <- .read_theme_preset(theme$extends, c(parents, name))
  theme$extends <- NULL
  .merge_options(base, theme, keep_null = TRUE)
}

.theme_image <- function(filename) {
  path <- system.file(
    "themes",
    "backgrounds",
    filename,
    package = "highcharter",
    mustWork = TRUE
  )
  mime <- switch(
    tools::file_ext(filename),
    jpg = "image/jpeg",
    png = "image/png",
    stop("Unknown theme image format: ", filename, call. = FALSE)
  )
  bytes <- readBin(path, "raw", file.size(path))
  paste0(
    "data:",
    mime,
    ";base64,",
    gsub("\n", "", jsonlite::base64_enc(bytes), fixed = TRUE)
  )
}

#' @rdname hc_theme
#' @export
hc_set_theme <- function(theme, ...) {
  selected <- if (.is_hc_theme(theme)) {
    hc_theme_merge(theme, hc_theme(...))
  } else {
    hc_theme(theme, ...)
  }
  options(highcharter.theme = selected)
}

#' Apply a theme to a chart
#'
#' @param hc A highchart widget.
#' @param hc_thm A theme built with [hc_theme()].
#' @return The widget with the selected theme.
#' @examples
#' highchart() |>
#'   hc_add_series(data = c(7, 5, 9)) |>
#'   hc_add_theme(hc_theme("ft"))
#' @export
hc_add_theme <- function(hc, hc_thm) {
  stopifnot(
    is.highchart(hc),
    "The theme used is not from hc_theme class" = .is_hc_theme(hc_thm)
  )
  hc$x$theme <- hc_thm
  if (!identical(hc$x$google_fonts, FALSE)) {
    hc$x$fonts <- unique(c(.hc_get_fonts(hc$x$hc_opts), .hc_get_fonts(hc_thm)))
  }
  hc
}

#' Merge chart themes
#'
#' @param ... Themes built with [hc_theme()]. Later arguments take precedence.
#' @return An `hc_theme` object.
#' @examples
#' hc_theme_merge(hc_theme("ft"), hc_theme(chart = list(backgroundColor = "white")))
#' @export
hc_theme_merge <- function(...) {
  themes <- list(...)
  stopifnot(all(vapply(themes, .is_hc_theme, logical(1))))
  structure(
    Reduce(
      function(x, y) .merge_options(x, y, keep_null = TRUE),
      themes,
      init = list()
    ),
    class = "hc_theme"
  )
}

.is_hc_theme <- function(theme) {
  identical(class(theme), "hc_theme")
}

.hc_get_fonts <- function(lst) {
  values <- unlist(lst)
  families <- values[grepl("fontFamily$", names(values))]
  # CSS variables and generic/system fonts are provided by the surrounding page.
  families <- families[!grepl("^var\\(", trimws(families))]
  families <- trimws(sub(",.*", "", families))
  families <- families[
    !tolower(families) %in%
      c(
        "arial",
        "helvetica",
        "georgia",
        "verdana",
        "times new roman",
        "courier new",
        "system-ui",
        "sans-serif",
        "serif",
        "monospace",
        "inherit"
      )
  ]
  unname(gsub("\\s+", "+", families))
}
