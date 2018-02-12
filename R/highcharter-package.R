#' An `htmlwidget` interface to the
#' Highcharts javascript chart library
#' 
#' Highcharts \url{http://www.highcharts.com/} is a mature javascript
#' charting library. Highcharts provide a various type of charts, from
#' scatters to heatmaps or treemaps. 
#' 
#' @name highcharter
#' @docType package
#' @author Joshua Kunst (@@jbkunst)
NULL

#' highcharter exported operators and S3 methods
#' 
#' The following functions are imported and then re-exported
#' from the highcharter package to avoid listing the magrittr
#' as Depends of highcharter.
#' 
#' @name highcharter-exports
NULL

#' @importFrom magrittr %>%
#' @name %>%
#' @export
#' @rdname highcharter-exports
NULL

#' @importFrom htmltools tags
#' @name tags
#' @export
#' @rdname highcharter-exports
NULL

if (getRversion() >= "2.15.1")  utils::globalVariables(c(".", "colorValue", "level", "name", "parent"))
