#' Shorcut for create scatter plots
#'
#' This function helps to create scatter plot from two numerics vectors. Options
#' argumets like size, color and label for points are added. 
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param x A numeric vector. 
#' @param y A numeric vector. Same length of \code{x}.
#' @param z A numeric vector for size. Same length of \code{x}.
#' @param color A vector to color the points.
#' @param label A vector to put names in the dots if you enable the datalabels.
#' @param showInLegend Logical value to show or not the data in the legend box.
#' @param viridis.option Palette to use in case the \code{color}. Argument can not
#'   be \code{NULL} in the case of use \code{color} argument.
#'  Options are A, B, C, D.
#' @param ... Aditional shared arguments for the data series 
#'   (\url{http://api.highcharts.com/highcharts#series}).
#' 
#' @examples 
#' 
#' hc <- highchart()
#' 
#' hc_add_series_scatter(hc, mtcars$wt, mtcars$mpg)
#' hc_add_series_scatter(hc, mtcars$wt, mtcars$mpg, mtcars$drat)
#' hc_add_series_scatter(hc, mtcars$wt, mtcars$mpg, mtcars$drat, mtcars$am)
#' hc_add_series_scatter(hc, mtcars$wt, mtcars$mpg, mtcars$drat, mtcars$qsec)
#' hc_add_series_scatter(hc, mtcars$wt, mtcars$mpg, mtcars$drat, mtcars$qsec, rownames(mtcars))
#' 
#' @importFrom dplyr mutate group_by do select data_frame
#' 
#' @export 
hc_add_series_scatter <- function(hc, x, y, z = NULL, color = NULL, label = NULL,
                                 showInLegend = FALSE, viridis.option = "D", ...) {
  
  assertthat::assert_that(.is_highchart(hc), length(x) == length(y),
                          is.numeric(x), is.numeric(y))
  
  df <- data_frame(x, y)
  
  if (!is.null(z)) {
    assert_that(length(x) == length(z))
    df <- df %>% mutate(z = z)
  }
  
  if (!is.null(color)) {
    
    assert_that(length(x) == length(color))
    assert_that(viridis.option %in% c("A", "B", "C", "D"))
    
    cols <- colorize_vector(color, option = viridis.option)
    
    df <- df %>% mutate(valuecolor = color,
                        color = cols)
  }
  
  if (!is.null(label)) {
    assert_that(length(x) == length(label))
    df <- df %>% mutate(label = label)
  }
  
  ds <- list.parse3(df)
  
  type <- ifelse(!is.null(z), "bubble", "scatter")
  
  if (!is.null(label)) {
    dlopts <- list(enabled = TRUE, format = "{point.label}")
  } else {
    dlopts <- list(enabled = FALSE)
  }
  
  hc %>% hc_add_series(data = ds,
                       type = type,
                       showInLegend = showInLegend,
                       dataLabels = dlopts, ...)
  
}

#' @rdname hc_add_series_scatter
#' @export
hc_add_serie_scatter <- hc_add_series_scatter

#' Shorcut for add series for pie, bar and column charts
#'
#' This function add data to plot pie, bar and column charts.
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param labels A vector of labels. 
#' @param values A numeric vector. Same length of \code{labels}.
#' @param colors A not required color vector (hexadecimal format). Same length of \code{labels}.
#' @param ... Aditional shared arguments for the data series 
#'   (\url{http://api.highcharts.com/highcharts#series}).
#' 
#' @examples 
#' 
#' data("favorite_bars")
#' data("favorite_pies")
#' 
#' highchart() %>% 
#'   hc_title(text = "This is a bar graph describing my favorite pies
#'                    including a pie chart describing my favorite bars") %>%
#'   hc_subtitle(text = "In percentage of tastiness and awesomeness") %>% 
#'   hc_add_series_labels_values(favorite_pies$pie, favorite_pies$percent, name = "Pie",
#'                              colorByPoint = TRUE, type = "column") %>% 
#'   hc_add_series_labels_values(favorite_bars$bar, favorite_bars$percent,
#'                              colors = substr(terrain.colors(5), 0 , 7), type = "pie",
#'                              name = "Bar", colorByPoint = TRUE, center = c('35%', '10%'),
#'                              size = 100, dataLabels = list(enabled = FALSE)) %>% 
#'   hc_yAxis(title = list(text = "percentage of tastiness"),
#'            labels = list(format = "{value}%"), max = 100) %>% 
#'   hc_xAxis(categories = favorite_pies$pie) %>% 
#'   hc_legend(enabled = FALSE) %>% 
#'   hc_tooltip(pointFormat = "{point.y}%")
#' 
#' 
#' @export
hc_add_series_labels_values <- function(hc, labels, values, colors = NULL, ...) {
  
  assertthat::assert_that(.is_highchart(hc),
                          is.numeric(values),
                          length(labels) == length(values))

  df <- data_frame(name = labels, y = values)
  
  if (!is.null(colors)) {
    assert_that(length(labels) == length(colors))
    
    df <- mutate(df, color = colors)
    
  }
  
  ds <- list.parse3(df)
  
  hc <- hc %>% hc_add_series(data = ds, ...)
  
  hc
                      
}

#' @rdname hc_add_series_labels_values
#' @export
hc_add_serie_labels_values <- hc_add_series_labels_values

#' Shorcut for create treemaps
#'
#' This function helps to create higcharts treemaps from \code{treemap} objects
#' from the package \code{treemap}.
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param tm A \code{treemap} object from the treemap package.
#' @param ... Aditional shared arguments for the data series
#'   (\url{http://api.highcharts.com/highcharts#series}).
#' 
#' @examples 
#'  
#' \dontrun{
#' 
#' library("treemap")
#' library("viridis")
#' 
#' data(GNI2010)
#' head(GNI2010)
#' 
#' tm <- treemap(GNI2010, index = c("continent", "iso3"),
#'               vSize = "population", vColor = "GNI",
#'               type = "comp", palette = rev(viridis(6)),
#'               draw = FALSE)
#' 
#' highchart(height = 800) %>% 
#'   hc_add_series_treemap(tm, allowDrillToNode = TRUE,
#'                        layoutAlgorithm = "squarified",
#'                        name = "tmdata") %>% 
#'    hc_title(text = "Gross National Income World Data") %>% 
#'    hc_tooltip(pointFormat = "<b>{point.name}</b>:<br>
#'                              Pop: {point.value:,.0f}<br>
#'                              GNI: {point.valuecolor:,.0f}")
#' 
#' }
#' 
#' @importFrom dplyr filter_ mutate_ rename_ select_ tbl_df
#' @importFrom purrr map map_df map_if 
#' 
#' @export 
hc_add_series_treemap <- function(hc, tm, ...) {
  
  assertthat::assert_that(.is_highchart(hc), is.list(tm))
  
  df <- tm$tm %>% 
    tbl_df() %>% 
    select_("-x0", "-y0", "-w", "-h", "-stdErr", "-vColorValue") %>% 
    rename_("value" = "vSize", "valuecolor" = "vColor") %>% 
    purrr::map_if(is.factor, as.character) %>% 
    data.frame(stringsAsFactors = FALSE) %>% 
    tbl_df()
  
  ndepth <- which(names(df) == "value") - 1
  
  ds <- map_df(seq(ndepth), function(lvl){ # lvl <- sample(seq(ndepth), size = 1)
    
    df2 <- df %>% 
      filter_(sprintf("level == %s", lvl)) %>% 
      rename_("name" = names(df)[lvl]) %>% 
      mutate_("id" = "highcharter::str_to_id(name)")
    
    if (lvl > 1) {
      df2 <- df2 %>% 
        mutate_("parent" = names(df)[lvl - 1],
                "parent" = "highcharter::str_to_id(parent)")
    } else {
      df2 <- df2 %>% 
        mutate_("parent" = NA)
    }
    
    df2 
    
  })
  
  ds <- list.parse3(ds)
  
  ds <- map(ds, function(x){
    if (is.na(x$parent))
      x$parent <- NULL
    x
  })
  
  hc %>% hc_add_series(data = ds, type = "treemap", ...)
  
}

#' @rdname hc_add_series_treemap
#' @export
hc_add_serie_treemap <- hc_add_series_treemap

#' Shorcut for create map
#'
#' This function helps to create higcharts treemaps from \code{treemap} objects
#' from the package \code{treemap}.
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param map A \code{list} object loaded from a geojson file.
#' @param df A \code{data.frame} object with data to chart. Code region and value are
#'   required.
#' @param value A string value with the name of the column to chart.
#' @param joinBy What property to join the  \code{map} and \code{df}
#' @param ... Aditional shared arguments for the data series
#'   (\url{http://api.highcharts.com/highcharts#series}).
#'   
#' @examples 
#' 
#' library("dplyr")
#' library("viridisLite")
#' 
#' data("USArrests", package = "datasets")
#' data("usgeojson")
#' 
#' USArrests <- USArrests %>% 
#'   mutate(state = rownames(.))
#' 
#' n <- 4
#' colstops <- data.frame(q = 0:n/n,
#'                        c = substring(viridis(n + 1, option = "A"), 0, 7)) %>% 
#' list.parse2()
#' 
#' highchart() %>% 
#'   hc_title(text = "Violent Crime Rates by US State") %>% 
#'   hc_subtitle(text = "Source: USArrests data") %>% 
#'   hc_add_series_map(usgeojson, USArrests, name = "Murder arrests (per 100,000)",
#'                     value = "Murder", joinBy = c("woename", "state"),
#'                     dataLabels = list(enabled = TRUE,
#'                                       format = '{point.properties.postalcode}')) %>% 
#'   hc_colorAxis(stops = colstops) %>% 
#'   hc_legend(valueDecimals = 0, valueSuffix = "%") %>%
#'   hc_mapNavigation(enabled = TRUE) 
#' 
#' \dontrun{
#' 
#' library("viridisLite")
#' library("dplyr")
#' data(unemployment)
#' data(uscountygeojson)
#'  
#' dclass <- data_frame(from = seq(0, 10, by = 2),
#'                      to = c(seq(2, 10, by = 2), 50),
#'                      color = substring(viridis(length(from), option = "C"), 0, 7))
#'  dclass <- list.parse3(dclass)
# 
#' highchart() %>% 
#'   hc_title(text = "US Counties unemployment rates, April 2015") %>% 
#'   hc_add_series_map(uscountygeojson, unemployment,
#'                     value = "value", joinBy = "code") %>%
#'   hc_colorAxis(dataClasses = dclass) %>%
#'   hc_legend(layout = "vertical", align = "right",
#'             floating = TRUE, valueDecimals = 0,
#'             valueSuffix = "%") %>%
#'   hc_mapNavigation(enabled = TRUE)
#'   
#' }
#'   
#' @importFrom utils tail
#' @export
hc_add_series_map <- function(hc, map, df, value, joinBy, ...) {
  
  assertthat::assert_that(.is_highchart(hc),
                          is.list(map),
                          is.data.frame(df),
                          value %in% names(df),
                          tail(joinBy, 1) %in% names(df))
  
  joindf <- tail(joinBy, 1)
  
  ddta <- data_frame(value = df[[value]],
                     code = df[[joindf]]) %>% 
    list.parse3()
  
  hc$x$type <- "map"
  
  hc %>% 
    hc_add_series(mapData = map, data = ddta,
                  joinBy = c(joinBy[1], "code"),
                  ...) %>% 
    hc_colorAxis(min = 0)
  
}

#' @rdname hc_add_series_map
#' @export
hc_add_serie_map <- hc_add_series_map
