#' Helpers to use highcharter as input in shiny apps
#' 
#' When you use highcharter in a shiny app, for example
#' \code{renderHighcharter("my_chart")} and then use the \code{hc_add_event_point}
#' function you can get the information of the point when the event is triggered
#' vía \code{input$my_chart}. So the highcharter can be used as an input.
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param series The name of type of series to apply the event.
#' @param event The name of event: click, mouseOut,  mouseOver. See 
#'   \url{http://api.highcharts.com/highcharts/plotOptions.areasplinerange.point.events.select}
#'   for more details.
#' 
#' @export
hc_add_event_point <- function(hc, series = "series", event = "click"){
  
  fun <- "function(){
  var pointinfo = {series: this.series.name, seriesid: this.series.id,
  name: this.name, x: this.x, y: this.y, category: this.category.name }
  window.x = this;
  console.log(pointinfo);
  
  if (typeof Shiny != 'undefined') { Shiny.onInputChange(this.series.chart.renderTo.id, pointinfo); } 
}"
  
  fun <- JS(fun)
  
  eventobj <- structure(
    list(structure(
      list(structure(
        list(structure(
          list(fun),
          .Names = event)
        ),
        .Names = "events")
      ),
      .Names = "point")
    ),
    .Names = series
  )
  
  hc$x$hc_opts$plotOptions <- rlist::list.merge(
    hc$x$hc_opts$plotOptions,
    eventobj
  )
  
  hc
  
  }

#' @rdname hc_add_event_point
#' @export
hc_add_event_series <- function(hc, series = "series", event = "click"){
  
  fun <- "function(){
  var seriesinfo = {name: this.name }
  console.log(seriesinfo);
  window.x = this;
  if (typeof Shiny != 'undefined') { Shiny.onInputChange(this.chart.renderTo.id, seriesinfo); }
  
}"
  fun <- JS(fun)
  
  eventobj <- structure(
    list(structure(
      list(structure(
        list(fun),
        .Names = event)
      ),
      .Names = "events")
    ),
    .Names = series
  )
  
  hc$x$hc_opts$plotOptions <- rlist::list.merge(
    hc$x$hc_opts$plotOptions,
    eventobj
  )
  
  hc
  
  }



#' Setting \code{elementId}
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
  
  if (!is.null(width))
    hc$width <- width
  
  if (!is.null(height))
    hc$height <- height
  
  hc
  
}

.hc_tooltip_table <- function(hc, ...) {
  # http://stackoverflow.com/a/22327749/829971
  hc %>% 
    highcharter::hc_tooltip(
      shared = TRUE,
      useHTML = TRUE,
      headerFormat = "<small>{point.key}</small><table>",
      pointFormat = "<tr><td style=\"color: {series.color}\">{series.name}: </td><td style=\"text-align: right\"><b>{point.y}</b></td></tr>",
      footerFormat = "</table>"
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
