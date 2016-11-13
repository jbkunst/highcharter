#' Setting elementId
#' 
#' Function to modify the \code{id} for the container.
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param id A string
#' 
#' @examples 
#' 
#' hchart(rnorm(10)) %>% 
#'   hc_elementId("newid")
#' 
#' @export
hc_elementId <- function(hc, id = NULL) {
  
  assertthat::assert_that(is.highchart(hc))
  
  hc$elementId <- as.character(id)
  
  hc
}

#' Changing the size of a \code{highchart} object
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param width	A numeric input in pixels.
#' @param height	A numeric input in pixels.
#' 
#' @examples 
#' 
#' hc_size(hcts(rnorm(100)), 400, 200)
#' 
#' @export
hc_size <- function(hc, width = NULL, height = NULL) {
  
  assertthat::assert_that(is.highchart(hc))
  
  if(!is.null(width))
    hc$width <- width
  
  if(!is.null(height))
    hc$height <- height
  
  hc
  
}

.hc_tooltip_table <- function(hc, ...) {
  # http://stackoverflow.com/a/22327749/829971
  hc %>% 
    highcharter::hc_tooltip(
      useHTML = TRUE,
      headerFormat = '<small>{point.key}</small><table>',
      pointFormat = '<tr><td style="color: {series.color}">{series.name}: </td><td style="text-align: right"><b>{point.y}</b></td></tr>',
      footerFormat = '</table>'
    )
}

.hc_tooltip_sort <- function(hc, ...) {
  # http://stackoverflow.com/a/16954666/829971
  hc %>% 
    highcharter::hc_tooltip(
      shared = TRUE,
      formatter = JS(
        "function(tooltip){
          function isArray(obj) {
          return Object.prototype.toString.call(obj) === '[object Array]';
          }
          
          function splat(obj) {
          return isArray(obj) ? obj : [obj];
          }
          
          var items = this.points || splat(this), series = items[0].series, s;
          
          // sort the values
          items.sort(function(a, b){
          return ((a.y < b.y) ? -1 : ((a.y > b.y) ? 1 : 0));
          });
          items.reverse();
          
          return tooltip.defaultFormatter.call(this, tooltip);
        }"))
  
}


