#' An `htmlwidget` interface to the
#' Highcharts javascript chart library
#'
#' Highcharts \url{https://www.highcharts.com/} is a mature javascript
#' charting library. Highcharts provide a various type of charts, from
#' scatters to heatmaps or treemaps.
#'
#' @name highcharter
#' @docType package
#' @author Joshua Kunst (@@jbkunst)
#' @importFrom utils data
#' @importFrom stringr str_c str_detect str_extract str_replace str_replace_all
#'      str_trim str_to_lower str_to_title
#' @importFrom htmlwidgets JS
"_PACKAGE"

#' highcharter exported operators and S3 methods
#'
#' The following functions are imported and then re-exported
#' from the highcharter package to avoid listing the magrittr
#' as Depends of highcharter.
#'
#' @name highcharter-exports
NULL

#' @importFrom htmlwidgets JS
#' @name JS
#' @export
#' @rdname highcharter-exports
NULL

#' @importFrom htmltools tags
#' @name tags
#' @export
#' @rdname highcharter-exports
NULL

if (getRversion() >= "2.15.1") utils::globalVariables(c(".", "colorValue", "level", "name", "parent"))
