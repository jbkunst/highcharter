validate_args <- function(name, lstargs) {
  
  lstargsnn <- lstargs[which(names(lstargs) == "")]
  lenlst <- length(lstargsnn)
  
  if (lenlst != 0) {
    
    chrargs <- lstargsnn %>% 
      unlist() %>% 
      as.character()
    
    chrargs <- paste0("'", chrargs, "'", collapse = ", ")
    
    txt <- ifelse(lenlst == 1, " is ", "s are ")
    
    stop(chrargs, " argument", txt, "not named in ", paste0("hc_", name),
         call. = FALSE)
    
  }
  
}

#' @importFrom rlist list.merge
.hc_opt <- function(hc, name, ...) {
  
  assertthat::assert_that(is.highchart(hc))
  
  validate_args(name, eval(substitute(alist(...))))
  
  if (is.null(hc$x$hc_opts[[name]])) {
    
    hc$x$hc_opts[[name]] <- list(...)
    
  } else {
    
    hc$x$hc_opts[[name]] <- list.merge(hc$x$hc_opts[[name]], list(...))
    
  }
  
  # Setting fonts
  hc$x$fonts <- unique(c(hc$x$fonts, .hc_get_fonts(hc$x$hc_opts)))
  
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
#' @importFrom stringr str_glue
#' @importFrom htmlwidgets JS
#' @examples
#'
#'
#' \dontrun{
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
#'     positioner = JS("function () { return { x: this.chart.plotLeft + 10, y: 10}; }"),
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
#'  }
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
  
  jss <- "function() {{
  var point = this;
  console.log(point);
  console.log(point.{accesor});
  setTimeout(function() {{

  $(\"#tooltipchart-{id}\").highcharts(hcopts);

  }, 0);

  return '<div id=\"tooltipchart-{id}\" style=\"width: {w}px; height: {h}px;\"></div>';

  }}"
  # cat(jss)
  
  # jsss <- whisker.render(
  #   jss,
  #   list(id = random_id(), w = width, h = height, accesor = accesor)
  # )
  # cat(jsss)
  
  jsss <- stringr::str_glue(jss, id = random_id(), w = width, h = height, accesor = accesor)
  
  jsss <- stringr::str_replace(jsss, "hcopts", hcopts)
  # cat(jsss)
  
  JS(jsss)
  
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
#' hc <- hchart(ts(rnorm(100)), showInLegend = FALSE)
#'
#' hc_size(hc, 200, 200)
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

#' Setting Motion options to highcharts objects
#'
#' The Motion Highcharts Plugin adds an interactive HTML5 player
#' to any Highcharts chart (Highcharts, Highmaps and Highstock).
#'
#' @param hc A \code{highchart} \code{htmlwidget} object.
#' @param enabled Enable the motion plugin.
#' @param startIndex start index, default to 0.
#' @param ... Arguments defined in \url{https://github.com/larsac07/Motion-Highcharts-Plugin/wiki}.
#'
#' @export
hc_motion <- function(hc, enabled = TRUE, startIndex = 0, ...) {
  
  hc <- .hc_opt(hc, "motion", enabled = enabled, startIndex = startIndex, ...)
  
  # hc <- hc_add_dependency_fa(hc)
  
  hc
  
}



#' @rdname hc_xAxis
#' @export
hc_yAxis_multiples <- function(hc, ...) {
  
  # print(length(list(...)));  print(length(list(...)[[1]]));
  # print(class(list(...)));  print(class(list(...)[[1]]))
  
  if (length(list(...)) == 1 & class(list(...)[[1]]) == "hc_yaxis_list") {
    hc$x$hc_opts$yAxis <- list(...)[[1]]
  } else {
    hc$x$hc_opts$yAxis <- list(...)
  }
  
  hc
  
}

#' Creating multiples yAxis t use with highcharts
#' @param naxis Number of axis an integer.
#' @param heights A numeric vector. This values will be normalized.
#' @param sep A numeric value for the separation (in percentage) for the panes.
#' @param offset A numeric value (in percentage).
#' @param turnopposite A logical value to turn the side of each axis or not.
#' @param ... Arguments defined in \url{http://api.highcharts.com/highcharts/yAxis}. 
#' @examples 
#' 
#' highchart() %>% 
#'    hc_yAxis_multiples(create_yaxis(naxis = 2, heights = c(2, 1))) %>% 
#'    hc_add_series(data = c(1,3,2), yAxis = 0) %>% 
#'    hc_add_series(data = c(20, 40, 10), yAxis = 1)
#'    
#' highchart() %>% 
#'   hc_yAxis_multiples(create_yaxis(naxis = 3, lineWidth = 2, title = list(text = NULL))) %>% 
#'   hc_add_series(data = c(1,3,2)) %>% 
#'   hc_add_series(data = c(20, 40, 10), yAxis = 1) %>% 
#'   hc_add_series(data = c(200, 400, 500), type = "columnn", yAxis = 2) %>% 
#'   hc_add_series(data = c(500, 300, 400), type = "columnn", yAxis = 2)  
#'    
#' @importFrom dplyr bind_cols
#' @export
create_yaxis <- function(naxis = 2, heights = 1, sep = 0.01,
                         offset = 0, turnopposite = TRUE, ...) {
  
  pcnt <- function(x) paste0(x * 100, "%")
  
  heights <- rep(heights, length = naxis)
  
  heights <- (heights / sum(heights)) %>% 
    map(function(x) c(x, sep)) %>% 
    unlist() %>% 
    head(-1) %>%
    { . / sum(.) } %>% 
    round(5) 
  
  tops <- cumsum(c(0, head(heights, -1)))
  
  tops <- pcnt(tops)
  heights <- pcnt(heights)
  
  dfaxis <- tibble(height = heights, top = tops, offset = offset)
  
  dfaxis <- dfaxis %>% dplyr::filter(seq_len(nrow(dfaxis)) %% 2 != 0)
  
  if (turnopposite) {
    ops <- rep_len(c(FALSE, TRUE), length.out = nrow(dfaxis))
    dfaxis <- dfaxis %>%
      mutate(opposite = ops)
  }
  
  dfaxis <- bind_cols(dfaxis, tibble(nid = seq(naxis), ...))
  
  yaxis <- list_parse(dfaxis)
  
  # yaxis <- map(yaxis, function(x) c(x, ...))
  
  class(yaxis) <- "hc_yaxis_list"
  
  yaxis
  
}
