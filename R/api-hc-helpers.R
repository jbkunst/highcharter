#' Helpers to use highcharter as input in shiny apps
#'
#' When you use highcharter in a shiny app, for example
#' \code{renderHighcharter('my_chart')}, you can access to the actions of the
#' user using and then use the \code{hc_add_event_point} via the
#' \code{my_chart} input (\code{input$my_chart}). That's a way you can
#' use a chart as an input.
#'
#' @param hc A `highchart` `htmlwidget` object.
#' @param series The name of type of series to apply the event.
#' @param event The name of event: click, mouseOut,  mouseOver. See
#'   \url{http://api.highcharts.com/highcharts/plotOptions.areasplinerange.point.events.select}
#'   for more details.
#'
#' @note Event details are accessible from hc_name_EventType, i.e. if a highchart is rendered against output$my_hc and
#'     and we wanted the coordinates of the user-clicked point we would use input$my_hc_click
#'
#' @export
hc_add_event_point <- function(hc, series = "series", event = "click"){

  fun <- paste0("function(){
  var pointinfo = {series: this.series.name, seriesid: this.series.id,
  name: this.name, x: this.x, y: this.y, category: this.category.name}
  window.x = this;
  console.log(pointinfo);

  if (typeof Shiny != 'undefined') { Shiny.onInputChange(this.series.chart.renderTo.id + '_' + '", event, "', pointinfo); }
}")

  fun <- json_verbatim(fun)

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

  fun <- paste0("function(){
  var seriesinfo = {name: this.name }
  console.log(seriesinfo);
  window.x = this;
  if (typeof Shiny != 'undefined') { Shiny.onInputChange(this.chart.renderTo.id + '_' + '", event, "', seriesinfo); }

}")
  fun <- json_verbatim(fun)

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
#' @param hc A `highchart` `htmlwidget` object.
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

#' Changing the size of a `highchart` object
#'
#' @param hc A `highchart` `htmlwidget` object.
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
      formatter = json_verbatim(
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


#' Helper to create charts in tooltips.
#'
#' @details This function needs to be used in the `pointFormatter` argument
#' inside of `hc_tooltip` function an `useHTML = TRUE` option.
#'
#' @param accesor A string indicating the name of the column where the data is.
#' @param hc_opts A list of options using the  \url{http://api.highcharts.com/highcharts}
#'   syntax.
#' @param width	A numeric input in pixels indicating the with of the tooltip.
#' @param height	A numeric input in pixels indicating the height of the tooltip.
#'
#' @importFrom whisker whisker.render
#' @examples
#'
#' require(dplyr)
#' require(purrr)
#' require(tidyr)
#' require(gapminder)
#' data(gapminder, package = "gapminder")
#'
#' gp <- gapminder %>%
#'   arrange(desc(year)) %>%
#'   distinct(country, .keep_all = TRUE)
#'
#' gp2 <- gapminder %>%
#'   nest(-country) %>%
#'   mutate(data = map(data, mutate_mapping, hcaes(x = lifeExp, y = gdpPercap), drop = TRUE),
#'          data = map(data, list_parse)) %>%
#'   rename(ttdata = data)
#'
#' gptot <- left_join(gp, gp2)
#'
#' hc <- hchart(
#'         gptot,
#'         "point",
#'         hcaes(
#'           lifeExp,
#'           gdpPercap,
#'           name = country,
#'           size = pop,
#'           group = continent
#'           )
#'        ) %>%
#'   hc_yAxis(type = "logarithmic")
#'
#' hc %>%
#'   hc_tooltip(useHTML = TRUE, pointFormatter = tooltip_chart(accesor = "ttdata"))
#'
#' hc %>%
#'   hc_tooltip(useHTML = TRUE, pointFormatter = tooltip_chart(
#'     accesor = "ttdata",
#'     hc_opts = list(chart = list(type = "column"))
#'   ))
#'
#' hc %>%
#'   hc_tooltip(
#'     useHTML = TRUE,
#'     positioner = json_verbatim("function () { return { x: this.chart.plotLeft + 10, y: 10}; }"),
#'     pointFormatter = tooltip_chart(
#'       accesor = "ttdata",
#'       hc_opts = list(
#'         title = list(text = "point.country"),
#'         xAxis = list(title = list(text = "lifeExp")),
#'         yAxis = list(title = list(text = "gdpPercap")))
#'       )
#'     )
#'
#' hc %>%
#'   hc_tooltip(
#'     useHTML = TRUE,
#'     pointFormatter = tooltip_chart(
#'       accesor = "ttdata",
#'       hc_opts = list(
#'         legend = list(enabled = TRUE),
#'         series = list(list(color = "gray", name = "point.name"))
#'       )
#'     )
#'   )
#'
#' @export
tooltip_chart <- function(
  accesor = NULL,
  hc_opts = NULL,
  width = 250,
  height = 150
) {

  assertthat::assert_that(assertthat::is.string(accesor))

  if(is.null(hc_opts)) {
    hc_opts[["series"]][[1]] <- list(data =  sprintf("point.%s", accesor))
  } else {
    if(!has_name(hc_opts, "series"))
      hc_opts[["series"]][[1]] <- list()
    hc_opts[["series"]][[1]][["data"]] <- sprintf("point.%s", accesor)
  }

  hc_opts <- rlist::list.merge(
    getOption("highcharter.chart")[c("title", "yAxis", "xAxis", "credits", "exporting")],
    list(chart = list(backgroundColor = "transparent")),
    list(legend = list(enabled = FALSE), plotOptions = list(series = list(animation = FALSE))),
    hc_opts
  )

  if(!has_name(hc_opts[["series"]][[1]], "color")) hc_opts[["series"]][[1]][["color"]] <- "point.color"

  hcopts <- toJSON(
    x = hc_opts, pretty = TRUE, auto_unbox = TRUE, json_verbatim = TRUE,
    force = TRUE, null = "null", na = "null"
  )
  hcopts <- as.character(hcopts)
  # cat(hcopts)

  # fix point.color
  hcopts <- str_replace(hcopts, "\\{point.color\\}", "point.color")

  # remove "\"" to have access to the point object
  ts <- stringr::str_extract_all(hcopts, "\"point\\.\\w+\"") %>% unlist()
  for(t in ts) hcopts <- str_replace(hcopts, t, str_replace_all(t, "\"", ""))

  # remove "\"" in the options
  ts <- stringr::str_extract_all(hcopts, "\"\\w+\":") %>%  unlist()
  for(t in ts) {
    t2 <- str_replace_all(t, "\"", "")
    # t2 <- str_replace(t2, ":", "")
    hcopts <- str_replace(hcopts, t, t2)
  }
  # cat(hcopts)

  jss <- "function() {
  var point = this;
  console.log(point);
  console.log(point.{{accesor}});
  setTimeout(function() {

  $(\"#tooltipchart-{{id}}\").highcharts(hcopts);

  }, 0);

  return '<div id=\"tooltipchart-{{id}}\" style=\"width: {{w}}px; height: {{h}}px;\"></div>';

  }"
  # cat(jss)

  jsss <- whisker.render(
    jss,
    list(id = random_id(), w = width, h = height, accesor = accesor)
  )
  # cat(jsss)

  jsss <- stringr::str_replace(jsss, "hcopts", hcopts)
  # cat(jsss)

  json_verbatim(jsss)

}

#' Helper for make table in tooltips
#'
#' Helper to make table in tooltips for the \code{pointFormat}
#' parameter in \code{hc_tooltip}
#'
#' @param x A string vector with description text
#' @param y A string with accessors example: \code{point.series.name},
#'   \code{point.x}
#' @param title A title tag with accessors or string
#' @param img Image tag
#' @param ... html attributes for the table element
#'
#' @examples
#'
#' x <- c("Income:", "Genre", "Runtime")
#' y <- c("$ {point.y}", "{point.series.options.extra.genre}",
#'        "{point.series.options.extra.runtime}")
#'
#' tooltip_table(x, y)
#'
#' @importFrom purrr map2
#' @importFrom htmltools tags tagList
#' @export
tooltip_table <- function(x, y,
                          title = NULL,
                          img = NULL, ...) {
  
  assertthat::assert_that(length(x) == length(y))
  
  tbl <- map2(x, y, function(x, y){
    tags$tr(
      tags$th(x),
      tags$td(y)
    )
  })
  
  tbl <- tags$table(tbl, ...)
  
  if (!is.null(title))
    tbl <- tagList(title, tbl)
  
  if (!is.null(img))
    tbl <- tagList(tbl, img)
  
  as.character(tbl)
  
}
