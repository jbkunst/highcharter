#' Create, list and select chart themes
#'
#' A theme contains Highcharts options shared by one or more charts. Start
#' from a packaged preset or supply your own named Highcharts options.
#'
#' @param preset A name returned by `hc_themes()`, or `NULL` to start from
#'   an empty theme.
#' @param ... Named Highcharts options. Nested options override individual
#'   fields. Arrays such as `colors` and gradient stops are replaced in full.
#'   In a `fontFamily` field, name a bundled or page-supplied family, or
#'   pass `sass::font_google()` to include a web font with the chart.
#' @param theme A preset name or an object created with `hc_theme()`.
#' @return `hc_theme()` returns an `hc_theme` object. `hc_themes()` lists the
#'   available preset names. `hc_set_theme()` sets `highcharter.theme` for
#'   subsequent charts in the R process and invisibly returns the previous option.
#' @seealso [hc_add_theme()], [hc_theme_merge()], `vignette("themes", package = "highcharter")`
#' @examples
#' hc_themes()
#' highchart(theme = hc_theme("ft")) |> hc_add_series(data = c(3, 1, 4))
#' team <- hc_theme("carbon", colors = c("#005F73", "#CA6702"),
#'   chart = list(style = list(fontFamily = "IBM Plex Sans")))
#' old <- hc_set_theme(team)
#' highchart() |> hc_add_series(data = c(3, 1, 4))
#' options(old)
#'
#' @examplesIf requireNamespace("sass", quietly = TRUE)
#' font <- sass::font_google("Noto Sans", local = FALSE)
#' highcharts_demo() |>
#'   hc_add_theme(hc_theme(chart = list(style = list(fontFamily = font))))
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
  .hc_apply_fonts(hc, "theme")
}

#' Merge chart themes
#'
#' @param ... Themes built with [hc_theme()]. Later arguments take precedence.
#' @return An `hc_theme` object.
#' @examples
#' theme <- hc_theme_merge(hc_theme("ft"), hc_theme(chart = list(backgroundColor = "white")))
#' highcharts_demo() |> hc_add_theme(theme)
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

# Track font declarations by their option paths so an explicit style can
# override a theme and a replacement theme can drop unused dependencies.
.hc_apply_fonts <- function(hc, slot, section = NULL, append_from = NULL) {
  previous <- hc$font_fields[[slot]]
  fields <- previous
  options <- hc$x[[slot]]
  prefix <- if (is.null(section)) "" else paste0("/", section)
  if (is.null(append_from)) {
    fields <- if (is.null(section)) {
      list()
    } else {
      previous[!startsWith(as.character(names(previous)), paste0(prefix, "/"))]
    }
  }

  walk <- function(node, path) {
    if (!is.list(node)) {
      return(node)
    }
    keys <- rlang::names2(node)
    for (i in which(keys == "fontFamily")) {
      font <- node[[i]]
      if (inherits(font, "font_collection")) {
        font <- htmltools::attachDependencies(
          font$families,
          htmltools::findDependencies(font)
        )
        node[[i]] <- font
      }
      if (!is.character(font) || length(font) != 1L || is.na(font)) {
        next
      }
      key <- paste0(path, "/fontFamily")
      fields[key] <<- list(font)
    }
    # GeoJSON coordinates and TopoJSON arcs contain no Highcharts styles.
    children <- which(
      vapply(node, is.list, logical(1)) &
        !keys %in% c("fontFamily", "mapData", "geometry", "coordinates", "arcs")
    )
    for (i in children) {
      key <- if (nzchar(keys[i])) keys[i] else as.character(i)
      child_path <- paste0(path, "/", key)
      if (key == "data" && grepl("^/series/[^/]+$", path)) {
        # Only point data labels can supply a font in a series data array.
        points <- node[[i]]
        styled <- vapply(
          points,
          function(point) is.list(point) && !is.null(point[["dataLabels"]]),
          logical(1)
        )
        for (j in which(styled)) {
          points[[j]]$dataLabels <- walk(
            points[[j]]$dataLabels,
            paste0(child_path, "/", j, "/dataLabels")
          )
        }
        if (any(styled)) node[[i]] <- points
      } else {
        node[i] <- list(walk(node[[i]], child_path))
      }
    }
    node
  }

  if (is.null(section)) {
    hc$x[[slot]] <- walk(options, "")
  } else if (is.null(append_from)) {
    hc$x[[slot]][section] <- list(walk(options[[section]], prefix))
  } else {
    items <- options[[section]]
    for (i in append_from + seq_len(length(items) - append_from)) {
      items[i] <- list(walk(items[[i]], paste0(prefix, "/", i)))
    }
    hc$x[[slot]][[section]] <- items
  }

  if (!length(previous) && !length(fields) || identical(previous, fields)) {
    return(hc)
  }
  hc$font_fields[[slot]] <- fields
  overrides <- hc$font_fields$hc_opts
  defaults <- hc$font_fields$theme
  active <- c(overrides, defaults[setdiff(names(defaults), names(overrides))])
  fonts <- unique(unname(active))
  deps <- unlist(lapply(fonts, .hc_font_dependencies), recursive = FALSE)
  deps <- lapply(
    htmltools::resolveDependencies(deps, resolvePackageDir = FALSE),
    function(dep) {
      attr(dep, "highcharter_font") <- TRUE
      dep
    }
  )
  other <- Filter(
    function(dep) !isTRUE(attr(dep, "highcharter_font")),
    hc$dependencies
  )
  hc$dependencies <- c(other, deps)
  hc
}

.hc_font_dependencies <- function(font) {
  explicit <- htmltools::htmlDependencies(font)
  if (!is.null(explicit)) {
    return(explicit)
  }
  if (startsWith(trimws(font), "var(")) {
    return(list())
  }
  families <- trimws(strsplit(font, ",", fixed = TRUE)[[1L]])
  families <- gsub("^['\"]|['\"]$", "", families)
  slugs <- tolower(gsub("\\s+", "-", families))
  bundled <- basename(list.dirs(
    system.file("fonts", package = "highcharter"),
    recursive = FALSE
  ))
  lapply(intersect(slugs, bundled), function(slug) {
    htmltools::htmlDependency(
      name = paste0("highcharter-font-", slug),
      version = "5.3.0.1",
      src = file.path("fonts", slug),
      package = "highcharter",
      stylesheet = "font.css"
    )
  })
}
