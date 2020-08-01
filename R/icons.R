#' Helpers functions to get FontAwesome icons code
#' @param hc A `highchart` `htmlwidget` object.
#' @export
hc_add_dependency_fa <- function(hc) {
  .Deprecated(msg = "Deprecated function. Use the fontawesome package. Example in the docs website.")
  dep <- htmlDependency(
    name = "font-awesome",
    version = "0.0.0",
    src = c(file = system.file("htmlwidgets/lib/font-awesome-4.7.0", package = "highcharter")),
    stylesheet = "css/font-awesome.min.css"
  )

  hc$dependencies <- c(hc$dependencies, list(dep))

  hc
}

#' @rdname hc_add_dependency_fa
#' @param iconname The icon's name
#' @export
fa_icon <- function(iconname = "circle") {
  .Deprecated(msg = "Deprecated function. Use the fontawesome package. Example in the docs website.")
  sprintf("<i class=\"fa fa-%s\"></i>", iconname)
}

#' @rdname hc_add_dependency_fa
#' @export
fa_icon_mark <- function(iconname = "circle") {
  
  .Deprecated(msg = "Deprecated function. Use the fontawesome package. Example in the docs website.")
  
  faicos <- readRDS(system.file("extdata/faicos.rds", package = "highcharter"))

  idx <- purrr::map_int(iconname, function(icn) which(faicos$name %in% icn))

  cod <- faicos$code[idx]

  # this is for the plugin: need the text:code to parse
  paste0("text:", cod)
}
