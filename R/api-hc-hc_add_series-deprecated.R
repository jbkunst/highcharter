#' Shorcut for create/add time series charts from a ts object
#'
#' This function add a time series to a \code{highchart} object
#' from a \code{ts} object. 
#' 
#' This function \bold{modify} the type of \code{chart} to \code{datetime}
#'  
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param ts A time series object.
#' @param ... Aditional arguments for the data series (\url{http://api.highcharts.com/highcharts#series}).
#' 
#' @examples 
#' 
#' \dontrun{
#' highchart() %>% 
#'   hc_title(text = "Monthly Airline Passenger Numbers 1949-1960") %>% 
#'   hc_subtitle(text = "The classic Box and Jenkins airline data") %>% 
#'   hc_add_series_ts(AirPassengers, name = "passengers") %>%
#'   hc_tooltip(pointFormat =  '{point.y} passengers')
#' 
#' highchart() %>% 
#'   hc_title(text = "Monthly Deaths from Lung Diseases in the UK") %>% 
#'   hc_add_series_ts(fdeaths, name = "Female") %>%
#'   hc_add_series_ts(mdeaths, name = "Male")
#' }
#' 
#' @importFrom stats is.ts time
#' @importFrom xts is.xts
#' 
#' @export 
hc_add_series_ts <- function(hc, ts, ...) {
  
  assertthat::assert_that(is.ts(ts), is.highchart(hc))
  
  .Deprecated("hc_add_series")
  
  # http://stackoverflow.com/questions/29202021/
  dates <- time(ts) %>% 
    zoo::as.Date()
  
  values <- as.vector(ts)
  
  hc %>% hc_add_series_times_values(dates, values, ...)
  
}

#' Shorcut for create highstock chart from \code{xts} object
#'
#' This function helps to create highstock charts from \code{xts} objects
#' obtaining by \code{getSymbols} function from the  \pkg{quantmod}.
#' 
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param x A \code{xts} object from the \pkg{quantmod} package.
#' @param ... Aditional shared arguments for the data series
#'   (\url{http://api.highcharts.com/highcharts#series}).
#'   
#' @examples 
#' 
#' \dontrun{
#' 
#' library("quantmod")
#' 
#' usdjpy <- getSymbols("USD/JPY", src="oanda", auto.assign = FALSE)
#' eurkpw <- getSymbols("EUR/KPW", src="oanda", auto.assign = FALSE)
#' 
#' highchart(type = "stock") %>% 
#'   hc_add_series_xts(usdjpy, id = "usdjpy") %>% 
#'   hc_add_series_xts(eurkpw, id = "eurkpw")
#' }
#' 
#' @importFrom xts is.xts
#' @export
hc_add_series_xts <- function(hc, x, ...) {
  
  .Deprecated("hc_add_series")
  
  assertthat::assert_that(is.highchart(hc), is.xts(x))
  
  hc$x$type <- "stock"
  
  timestamps <- datetime_to_timestamp(time(x))
  
  ds <- list_parse2(data.frame(timestamps, as.vector(x)))
  
  hc %>%  hc_add_series(data = ds, ...)
  
}

#' Shorcut for create candlestick charts
#'
#' This function helps to create candlestick from \code{xts} objects
#' obtaining by \code{getSymbols} function from the  \pkg{quantmod}.
#' 
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param x A \code{OHLC} object from the \pkg{quantmod} package.
#' @param type The type of chart. Can be \code{candlestick} or \code{ohlc}.
#' @param ... Aditional shared arguments for the data series
#'   (\url{http://api.highcharts.com/highcharts#series}).
#'   
#' @examples   
#' 
#' \dontrun{
#' 
#' library("xts")
#'
#' data(sample_matrix)
#'
#' matrix_xts <- as.xts(sample_matrix, dateFormat = "Date")
#' 
#' head(matrix_xts)
#' 
#' class(matrix_xts)
#' 
#' highchart() %>% 
#'   hc_add_series_ohlc(matrix_xts)
#'    
#' library("quantmod")
#'
#' x <- getSymbols("AAPL", auto.assign = FALSE)
#' y <- getSymbols("SPY", auto.assign = FALSE)
#' 
#' highchart() %>% 
#'   hc_add_series_ohlc(x) %>% 
#'   hc_add_series_ohlc(y)
#'   
#' }
#'   
#' @importFrom quantmod is.OHLC
#' @importFrom stringr str_extract
#' @export
hc_add_series_ohlc <- function(hc, x, type = "candlestick", ...){
  
  .Deprecated("hc_add_series")
  
  assertthat::assert_that(is.highchart(hc), is.xts(x), is.OHLC(x))
  
  hc$x$type <- "stock"
  
  time <- datetime_to_timestamp(time(x))
  
  xdf <- cbind(time, as.data.frame(x))
  
  xds <- list_parse2(xdf)
  
  nm <- ifelse(!is.null(list(...)[["name"]]),
               list(...)[["name"]],
               str_extract(names(x)[1], "^[A-Za-z]+"))

  hc <- hc %>% hc_add_series(data = xds,
                             name = nm,
                             type = type)
  
  hc
  
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
hc_add_series_scatter <- function(hc, x, y, z = NULL, color = NULL,
                                  label = NULL, showInLegend = FALSE,
                                  ...) {
  
  .Deprecated("hc_add_series")
  
  assertthat::assert_that(is.highchart(hc), length(x) == length(y),
                          is.numeric(x), is.numeric(y))
  
  df <- data_frame(x, y)
  
  if (!is.null(z)) {
    assert_that(length(x) == length(z))
    df <- df %>% mutate(z = z)
  }
  
  if (!is.null(color)) {
    
    assert_that(length(x) == length(color))
    
    cols <- colorize(color)
    
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
  
  ds <- list_parse(df)
  
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

hc_add_series_df_old <- function(hc, data, ...) {
  
  .Deprecated("hc_add_series")
  
  assertthat::assert_that(is.highchart(hc), is.data.frame(data))
  
  hc <- hc %>%
    hc_add_series(data = list_parse(data), ...)
  
  hc
}

#' Shorcut for create boxplot 
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param x A numerci vector
#' @param by A string vector same length of \code{x}
#' @param outliers A boolean value to show or not the outliers
#' @param ... Aditional arguments for the data series (\url{http://api.highcharts.com/highcharts#series}).
#' @examples
#' 
#' \dontrun{
#' highchart() %>% 
#'   hc_add_series_boxplot(x = iris$Sepal.Length, by = iris$Species, name = "length") 
#' }
#'   
#' @importFrom grDevices boxplot.stats
#' @importFrom purrr map2_df
#' @export
hc_add_series_boxplot <- function(hc, x, by = NULL, outliers = TRUE, ...) {
  
  .Deprecated("hcboxplot")
  
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
          data =  list_parse(outs),
          name = str_trim(paste(list(...)$name, "outliers")),
          type = "scatter", #linkedTo = ":previous",
          marker = list(...),
          tooltip = list(
            headerFormat = "<span>{point.key}</span><br/>",
            # pointFormat = "Observation: {point.y}"
            pointFormat = "<span style='color:{point.color}'></span> 
            Outlier: <b>{point.y}</b><br/>"
          ),
          ...
        )
    }
    
  }
  
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
#' \dontrun{
#' require("dplyr")
#' n <- 50
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
#' m <- 50
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
#' }
#' 
#' @importFrom lubridate is.Date
#' @importFrom dplyr arrange_
#' @export
hc_add_series_df <- function(hc, data, type = NULL, ...) {
  
  .Deprecated("hc_add_series")
  
  # check data
  assertthat::assert_that(is.highchart(hc))
  
  series <- get_hc_series_from_df(data, type = type, ...)
  
  hc_add_series_list(hc, series)
  
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
  
  .Deprecated("hctreemap")
  
  assertthat::assert_that(is.highchart(hc), is.list(tm))
  
  df <- tm$tm %>% 
    tbl_df() %>% 
    select_("-x0", "-y0", "-w", "-h", "-stdErr", "-vColorValue") %>% 
    rename_("value" = "vSize", "valuecolor" = "vColor") %>% 
    purrr::map_if(is.factor, as.character) %>% 
    data.frame(stringsAsFactors = FALSE) %>% 
    tbl_df()
  
  ndepth <- which(names(df) == "value") - 1
  
  ds <- map_df(seq(ndepth), function(lvl) {
    
    # lvl <- sample(seq(ndepth), size = 1)
    
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
  
  ds <- list_parse(ds)
  
  ds <- map(ds, function(x){
    if (is.na(x$parent))
      x$parent <- NULL
    x
  })
  
  hc %>% hc_add_series(data = ds, type = "treemap", ...)
  
}

#' Shorcut for add flags to highstock chart
#'
#' This function helps to add flags highstock charts created from \code{xts} objects.
#' 
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param dates Date vector.
#' @param title A character vector with titles.
#' @param text A character vector with the description.
#' @param id The name of the series to add the flags. A previous series
#'   must be added whith this \code{id}. 
#' @param ... Aditional shared arguments for the *flags* data series
#'   (\url{http://api.highcharts.com/highstock#plotOptions.flags})
#'   
#' @examples
#' 
#' 
#' \dontrun{
#' 
#' library("quantmod")
#' 
#' usdjpy <- getSymbols("USD/JPY", src="oanda", auto.assign = FALSE)
#' 
#' dates <- as.Date(c("2015-05-08", "2015-09-12"), format = "%Y-%m-%d")
# 
#' highchart(type = "stock") %>% 
#'   hc_add_series_xts(usdjpy, id = "usdjpy") %>% 
#'   hc_add_series_flags(dates,
#'                       title = c("E1", "E2"), 
#'                       text = c("This is event 1", "This is the event 2"),
#'                       id = "usdjpy") 
#' }
#'                       
#' @export
hc_add_series_flags <- function(hc, dates,
                                title = LETTERS[seq(length(dates))],
                                text = title,
                                id = NULL, ...) {
  
  .Deprecated("hc_add_series")
  
  assertthat::assert_that(is.highchart(hc), is.date(dates))
  
  dfflags <- data_frame(x = datetime_to_timestamp(dates),
                        title = title, text = text)
  
  dsflags <- list_parse(dfflags)
  
  hc %>% hc_add_series(data = dsflags, onSeries = id, type = "flags", ...)
  
}
