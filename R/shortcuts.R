#' Shorcut for data series from a list of data series
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object.
#' @param lst A list of data series.
#' 
#' @examples 
#' 
#' ds <- lapply(seq(5), function(x){
#'   list(data = cumsum(rnorm(100, 2, 5)), name = x)
#' })
#' 
#' highchart() %>% 
#'   hc_plotOptions(series = list(marker = list(enabled = FALSE))) %>% 
#'   hc_add_series_list(ds)
#'   
#' @export
hc_add_series_list <- function(hc, lst) {
  
  assertthat::assert_that(.is_highchart(hc), is.list(lst))
                          
  hc$x$hc_opts$series <- append(
    hc$x$hc_opts$series,
    lst
  )
  
  hc
  
}

#' Shorcut for tidy data frame a la ggplot2/qplot
#' 
#' Function to create chart from tidy data frames. As same as qplot
#' you can use aesthetic including the group variable
#' 
#' The types supported are line, column, point, polygon,
#' columrange, spline, areaspline among others.
#' 
#' Automatically parsed de data frame (to a list o series). You
#' you can use the  default parameters of highcharts such as \code{x}, \code{y},
#' \code{z}, \code{color}, \code{name}, \code{low}, \code{high} for 
#' each series, for example check 
#' \url{http://api.highcharts.com/highcharts#series<bubble>.data}.
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object.
#' @param data A \code{data.frame} object.
#' @param type The type of chart. Possible values are line, scatter, point, colum,
#'   columnrange, etc. See \url{http://api.highcharts.com/highcharts#series}.
#' @param ... Aesthetic mappings, \code{x y group color low high}.
#'   
#' @examples 
#' 
#' require("dplyr")
#' n <- 100
#' df <- data_frame(
#'   x = rnorm(n),
#'   y = x * 2 + rnorm(n),
#'   w =  x^2
#'   )
#'   
#' hc_add_series_df(highchart(), data = df, type = "point", x = x, y = y)
#' hc_add_series_df(highchart(), data = df, type = "point", color = w)
#' hc_add_series_df(highchart(), data = df, type = "point", color = w, size = y)
#'
#' m <- 100
#' s <- cumsum(rnorm(m))
#' e <- 2 + rbeta(m, 2, 2)
#' 
#' df2 <- data_frame(
#'   var = seq(m),
#'   l = s - e,
#'   h = s + e,
#'   n = paste("I'm point ", var)
#' )
#' 
#' hc_add_series_df(highchart(), data = df2, type = "columnrange",
#'                  x = var, low = l, high = h, name = n, color = var)
#' 
#' hc_add_series_df(highchart(), iris, "point",
#'                       x = Sepal.Length, y = Sepal.Width, group = Species)
#' 
#'   
#' data(mpg, package = "ggplot2")
#' 
#' # point and scatter is the same
#' hc_add_series_df(highchart(), mpg, "scatter", x = displ, y = cty)
#' hc_add_series_df(highchart(), mpg, "point", x = displ, y = cty,
#'                       group = manufacturer)
#'      
#' 
#' mpgman <- count(mpg, manufacturer)
#' hc_add_series_df(highchart(), mpgman, "column", x = manufacturer, y = n) %>% 
#'   hc_xAxis(type = "category")
#' 
#' mpgman2 <- count(mpg, manufacturer, year)
#' hc_add_series_df(highchart(), mpgman2, "bar", x = manufacturer, y = n, group = year) %>% 
#'   hc_xAxis(type = "category")
#'   
#' data(economics, package = "ggplot2")
#' 
#' hc_add_series_df(highchart(), economics, "line", x = date, y = unemploy) %>% 
#'   hc_xAxis(type = "datetime")
#' 
#' data(economics_long, package = "ggplot2")
#' 
#' economics_long2 <- filter(economics_long,
#'                           variable %in% c("pop", "uempmed", "unemploy"))
#'                           
#' hc_add_series_df(highchart(), economics_long2, "line", x = date,
#'                  y = value01, group = variable) %>% 
#'   hc_xAxis(type = "datetime")
#' 
#' 
#' @importFrom lubridate is.Date
#' @importFrom dplyr arrange_
#' @export
hc_add_series_df <- function(hc, data, type = NULL, ...) {
  
  # check data
  assertthat::assert_that(.is_highchart(hc))
  
  series <- get_hc_series_from_df(data, type = type, ...)
  
  hc_add_series_list(hc, series)
  
}

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
#' \dontrun{
#' hc <- highchart()
#' 
#' hc_add_series_scatter(hc, mtcars$wt, mtcars$mpg)
#' hc_add_series_scatter(hc, mtcars$wt, mtcars$mpg, mtcars$drat)
#' hc_add_series_scatter(hc, mtcars$wt, mtcars$mpg, mtcars$drat, mtcars$am)
#' hc_add_series_scatter(hc, mtcars$wt, mtcars$mpg, mtcars$drat, mtcars$qsec)
#' hc_add_series_scatter(hc, mtcars$wt, mtcars$mpg, mtcars$drat, mtcars$qsec, rownames(mtcars))
#' 
#' # Add named attributes to data (attributes length needs to match number of rows)
#' hc_add_series_scatter(hc, mtcars$wt, mtcars$mpg, mtcars$drat, mtcars$qsec,
#'                       name = rownames(mtcars), gear = mtcars$gear) %>%
#'   hc_tooltip(pointFormat = "<b>{point.name}</b><br/>Gear: {point.gear}")
#'   
#' }
#' 
#' @importFrom dplyr mutate do data_frame
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
  
  # Add arguments to data points if they match the length of the data
  args <- list(...)
  for (i in seq_along(args)) {
    if (length(x) == length(args[[i]]) && names(args[i]) != "name") {
      attr <- list(args[i])
      names(attr) <- names(args)[i]
      df <- cbind(df, attr)
      # Used argument is set to zero length
      args[[i]] <- character(0)
    }
  }
  # Remove already used arguments
  args <- Filter(length, args)
  
  ds <- list.parse3(df)
  
  type <- ifelse(!is.null(z), "bubble", "scatter")
  
  if (!is.null(label)) {
    dlopts <- list(enabled = TRUE, format = "{point.label}")
  } else {
    dlopts <- list(enabled = FALSE)
  }
  
  do.call("hc_add_series", c(list(hc,
                                  data = ds, 
                                  type = type, 
                                  showInLegend = showInLegend, 
                                  dataLabels = dlopts),
                             args))
}

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
#' data(GNI2014)
#' head(GNI2014)
#' 
#' tm <- treemap(GNI2014, index = c("continent", "iso3"),
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

#' Shorcut for create boxplot 
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param x A numerci vector
#' @param by A string vector same length of \code{x}
#' @param outliers A boolean value to show or not the outliers
#' @param ... Aditional shared arguments for the data series
#'   (\url{http://api.highcharts.com/highcharts#series}).
#' @examples
#' 
#' highchart() %>% 
#'   hc_add_series_boxplot(x = iris$Sepal.Length, by = iris$Species, name = "length") 
#'   
#' @importFrom grDevices boxplot.stats
#' @importFrom purrr map2_df
#' @export
hc_add_series_boxplot <- function(hc, x, by = NULL, outliers = TRUE, ...) {
  
  if (is.null(by)) {
    by <- "value"
  } else {
    stopifnot(length(x) == length(by))
  }
  
  df <- data_frame(value = x, by = by) %>% 
    group_by_("by") %>% 
    do(data = boxplot.stats(.$value))
  
  bxps <- map(df$data, "stats")
  
  hc <- hc %>%
    hc_xAxis(categories = df$by) %>% 
    hc_add_series(data = bxps, type = "boxplot", ...)
  
  if (outliers) {
    outs <- map2_df(seq(nrow(df)), df$data, function(x, y){
      if (length(y$out) > 0)
        d <- data_frame(x = x - 1, y = y$out)
      else
        d <- data_frame()
      d
    })
    
    if (nrow(outs) > 0) {
      hc <- hc %>%
        hc_add_series(
          data =  list.parse3(outs),
          name = str_trim(paste(list(...)$name, "outliers")),
          type = "scatter", #linkedTo = ":previous",
          marker = list(...),
          tooltip = list(
            headerFormat = "<span>{point.key}</span><br/>",
            # pointFormat = "Observation: {point.y}"
            pointFormat = "<span style='color:{point.color}'></span> Outlier: <b>{point.y}</b><br/>"
          ),
          ...
        )
    }
    
  }
  
  hc
  
}

#' Shorcut to create a density plot 
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param x A numeric vector
#' @param area A boolean value to show or not the area
#' @param ... Aditional shared arguments for the data series
#'   (\url{http://api.highcharts.com/highcharts#series})
#' @importFrom stats density
#' @examples
#' 
#' highchart() %>%
#'   hc_add_series_density(rnorm(1000)) %>%
#'   hc_add_series_density(rexp(1000), area = TRUE)
#'  
#' @export
hc_add_series_density <- function(hc, x, area = FALSE, ...) {
  
  stopifnot(inherits(x, "density") || inherits(x, "numeric"))
  
  if (is.numeric(x)) x <- density(x)
  
  type <- ifelse(area, "areaspline", "spline")
  data <- list.parse3(data.frame(cbind(x = x$x, y = x$y)))
  
  hc %>% 
    hc_chart(zoomType = "x") %>% 
    hc_add_series(data = data, type = type, ...)
}


hc_add_series_df_old <- function(hc, data, ...) {
  
  assertthat::assert_that(.is_highchart(hc), is.data.frame(data))
  
  hc <- hc %>%
    hc_add_series(data = list.parse3(data), ...)
  
  hc
}
