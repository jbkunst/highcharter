#' An \code{htmlwidget} interface to the
#' Highcharts javascript chart library
#' 
#' Highcarts \url{http://www.highcharts.com/} is a mature javascript
#' charting library. Highcharts provide a various type of charts, from
#' scatters to heatmaps or treemaps. 
#' 
#' @name higcharter
#' @docType package
#' @author Joshua Kunst (@@jbkunst)
NULL

#' highcharter exported operators and S3 methods
#' 
#' The following functions are imported and then re-exported
#' from the highcarter package to avoid listing the magrittr
#' as Depends of highcarters.
#' 
#' @name highcarter-exports
NULL

#' @importFrom magrittr %>%
#' @name %>%
#' @export
#' @rdname highcarter-exports
NULL

#' @importFrom htmlwidgets JS
#' @name JS
#' @export
#' @rdname highcarter-exports
NULL

#' @importFrom htmltools tags
#' @name tags
#' @export
#' @rdname highcarter-exports
NULL
