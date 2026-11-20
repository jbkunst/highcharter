#' Function to export js file the configuration options
#'
#' @param hc A \code{Highcharts object}.
#' @param filename Output path. A `.js` extension is appended unless the path
#'   already ends in `.js`, `.mjs` or `.cjs`.
#' @param as String to define how to save the configuration options.
#'   One of 'is', 'container', 'variable'.
#' @param name A variable used to put as name of the generated object if
#'   \code{as} is \code{'variable'} and the css/js selector if is \code{as} is
#'   container.
#'
#' @examples
#'
#' fn <- "function(){
#'   console.log('Category: ' + this.category);
#'   alert('Category: ' + this.category);
#' }"
#'
#' hc <- highcharts_demo() |>
#'   hc_plotOptions(
#'     series = list(
#'       cursor = "pointer",
#'       point = list(
#'         events = list(
#'           click = JS(fn)
#'         )
#'       )
#'     )
#'   )
#' \dontrun{
#' export_hc(hc, filename = "~/hc_is.js", as = "is")
#' export_hc(hc, filename = "~/hc_vr.js", as = "variable", name = "objectname")
#' export_hc(hc, filename = "~/hc_ct.js", as = "container", name = "#selectorid")
#' }
#'
#' @importFrom jsonlite toJSON
#' @importFrom utils head
#' @export
export_hc <- function(hc, filename = NULL, as = "is", name = NULL) {
  stopifnot(!is.null(filename))
  stopifnot(as %in% c("is", "container", "variable"))

  if (as != "is") {
    stopifnot(!is.null(name))
  }

  js <- .hc_options_js(hc$x$hc_opts, pretty = TRUE)

  if (as == "container") {
    js <- sprintf("$(function(){\n\t$('%s').highcharts(\n%s\n);\n});", name, js)
  } else if (as == "variable") {
    js <- sprintf("var %s = %s;", name, js)
  }

  if (!any(endsWith(filename, c(".js", ".mjs", ".cjs")))) {
    filename <- paste0(filename, ".js")
  }

  writeLines(js, filename)
}

# Keep explicit JS() expressions executable while quoting ordinary R strings.
.hc_options_js <- function(options, pretty = FALSE) {
  options <- rapply(
    options,
    function(x) structure(as.character(x), class = "json"),
    classes = "JS_EVAL",
    how = "replace"
  )
  toJSON(
    options,
    pretty = pretty,
    auto_unbox = TRUE,
    json_verbatim = TRUE,
    force = TRUE,
    null = "null",
    na = "null"
  )
}
