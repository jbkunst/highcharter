#' Adding and removing series from highchart objects
#'
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param data An R object like numeric, list, ts, xts, etc.
#' @param ... Arguments defined in \url{http://api.highcharts.com/highcharts#chart}. 
#' @examples
#' 
#'  highchart() %>%
#'    hc_add_series(data = abs(rnorm(5)), type = "columnn") %>% 
#'    hc_add_series(data = purrr::map(0:4, function(x) list(x, x)), type = "scatter", color = "blue")
#'
#' @export
hc_add_series <- function(hc, data = NULL, ...){
  
  assertthat::assert_that(is.highchart(hc))
  
  UseMethod("hc_add_series", data)
  
}


#' @export
hc_add_series.default <- function(hc, ...) {
  
  assertthat::assert_that(is.highchart(hc))
  
  if (getOption("highcharter.verbose"))
    message("hc_add_series.default")
  
  validate_args("add_series", eval(substitute(alist(...))))

  hc$x$hc_opts$series <- append(hc$x$hc_opts$series, list(list(...)))
  
  hc
  
}


#' `hc_add_series` for numeric objects
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param data A numeric object
#' @param ... Arguments defined in \url{http://api.highcharts.com/highcharts#chart}. 
#' @export
hc_add_series.numeric <- function(hc, data, ...) {
  
  if (getOption("highcharter.verbose"))
    message("hc_add_series.numeric")
  
  data <- fix_1_length_data(data)
  
  hc_add_series.default(hc, data = data, ...)
  
}


#' hc_add_series for time series objects
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param data A time series \code{ts} object.
#' @param ... Arguments defined in \url{http://api.highcharts.com/highcharts#chart}. 
#' @importFrom zoo as.Date
#' @importFrom stats time
#' @export
hc_add_series.ts <- function(hc, data, ...) {
  
  if (getOption("highcharter.verbose"))
    message("hc_add_series.ts")
  
  # http://stackoverflow.com/questions/29202021/
  timestamps <- data %>% 
    stats::time() %>% 
    zoo::as.Date() %>% 
    datetime_to_timestamp()
  
  series <- list_parse2(data.frame(timestamps, as.vector(data)))
  
  hc_add_series(hc, data = series, ...)
  
}


#' hc_add_series for xts objects
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param data A \code{xts} object.
#' @param ... Arguments defined in \url{http://api.highcharts.com/highcharts#chart}. 
#' @importFrom xts is.xts
#' @importFrom quantmod is.OHLC
#' @export
hc_add_series.xts <- function(hc, data, ...) {
  
  if (getOption("highcharter.verbose"))
    message("hc_add_series.xts")
  
  if (is.OHLC(data))
    return(hc_add_series.ohlc(hc, data, ...))
  
  timestamps <- datetime_to_timestamp(time(data))
  
  series <- list_parse2(data.frame(timestamps, as.vector(data)))
  
  hc_add_series(hc, data = series, ...)
  
}


#' @rdname hc_add_series.xts
#' @param type The way to show the \code{xts} object. Can be 'candlestick' or 'ohlc'.
#' @importFrom stringr str_extract
#' @export
hc_add_series.ohlc <- function(hc, data, type = "candlestick", ...){
  
  if (getOption("highcharter.verbose"))
    message("hc_add_series.xts.ohlc")
  
  time <- datetime_to_timestamp(time(data))
  xdf <- cbind(time, as.data.frame(data))
  xds <- list_parse2(xdf)
  
  nm <- ifelse(!is.null(list(...)[["name"]]),
               list(...)[["name"]],
               str_extract(names(data)[1], "^[A-Za-z]+"))
  
  hc_add_series(hc, data = xds, name = nm, type = type, ...)
  
}


#' hc_add_series for forecast objects
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param data A \code{forecast} object.
#' @param addOriginal Logical value to add the original series or not.
#' @param addLevels Logical value to show predictions bands.
#' @param fillOpacity The opacity of bands
#' @param ... Arguments defined in
#'   \url{http://api.highcharts.com/highcharts#chart}. 
#' @export
hc_add_series.forecast <- function(hc, data, addOriginal = FALSE,
                                   addLevels = TRUE, fillOpacity = 0.1, ...) {
  
  if (getOption("highcharter.verbose"))
    message("hc_add_series.forecast")
  
  rid <- random_id()
  method <- data$method
  
  # hc <- highchart() %>% hc_title(text = "LALALA")
  # ... <- NULL
  
  if (addOriginal)
    hc <- hc_add_series(hc, data$x, name = "Series", zIndex = 3, ...)
  
  
  hc <- hc_add_series(hc, data$mean, name = method,  zIndex = 2, id = rid, ...)
  
  
  if (addLevels){
    
    tmf <- datetime_to_timestamp(zoo::as.Date(time(data$mean)))
    nmf <- paste(method, "level", data$level)
    
    for (m in seq(ncol(data$upper))){ 
      # m <- 1
      dfbands <- data_frame(
        t = tmf,
        u = as.vector(data$upper[, m]),
        l = as.vector(data$lower[, m])
      )
      
      hc <- hc %>%
        hc_add_series(
          data = list_parse2(dfbands),
          name = nmf[m],
          type = "arearange",
          fillOpacity = fillOpacity,
          zIndex = 1,
          lineWidth = 0,
          linkedTo = rid,
          ...)
    }
  }
  
  
  hc
  

}


#' hc_add_series for density objects
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param data A \code{density} object.
#' @param ... Arguments defined in \url{http://api.highcharts.com/highcharts#chart}. 
#' @export
hc_add_series.density <- function(hc, data, ...) {
  
  if (getOption("highcharter.verbose"))
    message("hc_add_series.density")
  
  data <- list_parse(data.frame(cbind(x = data$x, y = data$y)))
  
  hc_add_series(hc, data = data, ...)
}


#' hc_add_series for character and factor objects
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param data A \code{character} or \code{factor} object.
#' @param ... Arguments defined in \url{http://api.highcharts.com/highcharts#chart}. 
#' @export
hc_add_series.character <- function(hc, data, ...) {
  
  if (getOption("highcharter.verbose"))
    message("hc_add_series.character")
  
  series <- data %>% 
    table() %>% 
    as.data.frame(stringsAsFactors = FALSE) %>% 
    setNames(c("name", "y")) %>% 
    list_parse()
  
  hc_add_series(hc, data = series, ...)
  
}


#' @rdname hc_add_series.character
#' @export
hc_add_series.factor <- hc_add_series.character

#' hc_add_series for geo_json & geo_list objects
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param data A \code{geo_json} or \code{geo_list} object.
#' @param type Type of series. Can be 'mapline', 'mapoint'.
#' @param ... Arguments defined in \url{http://api.highcharts.com/highcharts#chart}. 
#' @export
hc_add_series.geo_json <- function(hc, data, type = NULL, ...) {
  
  if (getOption("highcharter.verbose"))
    message("hc_add_series.geo_json")  
  
  stopifnot(hc$x$type == "map", !is.null(type))

  hc_add_series.default(hc, data = data, geojson = TRUE, type = type, ...)
  
}

#' @rdname hc_add_series.geo_json
#' @export
hc_add_series.geo_list <- function(hc, data, type = NULL, ...) {
  
  if (getOption("highcharter.verbose"))
    message("hc_add_series.geo_list")  
  
  stopifnot(hc$x$type == "map", !is.null(type))
  
  hc_add_series.default(hc, data = data, geojson = TRUE, type = type, ...)
  
}

#' hc_add_series for data frames objects
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param data A \code{data.frame} object.
#' @param type The type of the series: line, bar, etc.
#' @param mapping The mapping, same idea as \code{ggplot2}.
#' @param ... Arguments defined in 
#'   \url{http://api.highcharts.com/highcharts#chart}. 
#' @export
hc_add_series.data.frame <- function(hc, data, type = NULL, mapping = hcaes(),
                                     ...) {
  
  if (getOption("highcharter.verbose"))
    message("hc_add_series.data.frame")
  
  if (length(mapping) == 0) {
    
    if(has_name(data, "series"))
      data <- rename_(data, "seriess" = "series")
    
    return(hc_add_series(hc, data = list_parse(data), type = type, ...))
    
  }
  
  data <- mutate_mapping(data, mapping)
  
  series <- data_to_series(data, mapping, type = type, ...)

  hc_add_series_list(hc, series)
  
}

#' Define aesthetic mappings.
#' Similar in spirit to \code{ggplot2::aes}
#' @param x,y,... List of name value pairs giving aesthetics to map to
#'   variables. The names for x and y aesthetics are typically omitted because
#'   they are so common; all other aesthetics must be named.
#' @examples 
#' 
#' hcaes(x = xval, color = colorvar, group = grvar)
#' 
#' @export
hcaes <- function (x, y, ...) {
  mapping <- structure(as.list(match.call()[-1]), class = "uneval")
  mapping <- mapping[names(mapping) != ""]
  class(mapping) <- c("hcaes", class(mapping))
  mapping
}

#' Define aesthetic mappings using strings.
#' Similar in spirit to \code{ggplot2::aes_string}
#' @param x,y,... List of name value pairs giving aesthetics to map to
#'   variables. The names for x and y aesthetics are typically omitted because
#'   they are so common; all other aesthetics must be named.
#' @examples
#' hchart(mtcars, "point", hcaes_string("hp", "mpg", group = "cyl"))
#' 
#' hcaes_string(x = 'xval', color = 'colorvar', group = 'grvar')
#' @export
hcaes_string <- function (x, y, ...){
  
  mapping <- list(...)
  
  if (!missing(x))
    mapping["x"] <- list(x)
  
  if (!missing(y))
    mapping["y"] <- list(y)
  
  mapping <- lapply(mapping, function(x) {
    if (is.character(x)) {
      parse(text = x)[[1]]
    }
    else {
      x
    }
  })
  
  mapping <- structure(mapping, class = "uneval")
  
  mapping <- mapping[names(mapping) != ""]
  
  class(mapping) <- c("hcaes", class(mapping))
  
  mapping
}

#' @rdname hcaes_string
#' @export
hcaes_ <- hcaes_string


#' Modify data frame according to mapping
#' @param data A data frame object.
#' @param mapping A mapping from \code{hcaes} function.
#' @examples 
#' 
#' mutate_mapping(data = head(mtcars), mapping = hcaes(x = cyl, y = wt + cyl, group = gear))
#' 
#' @export
mutate_mapping <- function(data, mapping) {
  
  stopifnot(is.data.frame(data), inherits(mapping, "hcaes"))
  
  mapping_attributes <- attributes(mapping)
  mapping = lapply(mapping, function(x){
    if(is.symbol(x) == FALSE & is.language(x)){
      t_eval = tryCatch({eval(x)}, 
                        error = function(cond){
                          return(x)
                        })
    }else{
      return(x)
    }
  })
  attributes(mapping) = mapping_attributes
  
  # http://rmhogervorst.nl/cleancode/blog/2016/06/13/NSE_standard_evaluation_dplyr.html
  tran <- as.character(mapping)
  newv <- names(mapping)
   
  setNames(tran, newv)

  data <- dplyr::mutate_(data, .dots = setNames(tran, newv))
  
  # Reserverd  highcharts names (#241)
  if(has_name(data, "series"))
    data <- rename_(data, "seriess" = "series")
  
  data
  
}

add_arg_to_df <- function(data, ...) {
  
  datal <- as.list(data)
  
  l <- map_if(list(...), function(x) is.list(x), list)
  
  datal <- append(datal, l)
  
  as_data_frame(datal)
  
}

data_to_series <- function(data, mapping, type, ...) {
  
  # check type and fix
  type <- ifelse(type == "point", "scatter", type)
  type <- ifelse((has_name(mapping, "size") | has_name(mapping, "z")) & type == "scatter",
                 "bubble", type)
  
  # heatmap
  if (type == "heatmap") {
    if (!is.numeric(data[["x"]])) {
      data[["xf"]] <- as.factor(data[["x"]])
      data[["x"]] <- as.numeric(as.factor(data[["x"]])) - 1
    }
    if (!is.numeric(data[["y"]])) {
      data[["yf"]] <- as.factor(data[["y"]])
      data[["y"]] <- as.numeric(as.factor(data[["y"]])) - 1
    }
  }
  
  # x
  if (has_name(mapping, "x")) {
    if (is.Date(data[["x"]])) {
      data[["x"]] <- datetime_to_timestamp(data[["x"]])
      
    } else if (is.character(data[["x"]]) | is.factor(data[["x"]])) {
      data[["name"]] <- data[["x"]]
      data[["x"]] <- NULL
    } 
  }
  
  # color
  if (has_name(mapping, "color")) {
    
    if (type == "treemap") {
      data <- rename_(data, "colorValue" = "color")
    } else if (!all(is.hexcolor(data[["color"]]))) { 
      data  <- mutate_(data, "colorv" = "color", "color" = "highcharter::colorize(color)")  
    }
    
  } else if (has_name(data, "color")) {
    data <- rename_(data, "colorv" = "color")
  }
  
  # size
  if (type %in% c("bubble", "scatter")) {
    
    if (has_name(mapping, "size"))
      data <- mutate_(data, "z" = "size")
    
  }
  
  # group 
  if (!has_name(mapping, "group"))
    data[["group"]] <- "group"
  
  data <- data %>% 
    group_by_("group") %>% 
    do(data = list_parse(select_(., quote(-group)))) %>% 
    ungroup()

  data$type <- type
  
  if (length(list(...)) > 0)
    data <- add_arg_to_df(data, ...)
  
  if (has_name(mapping, "group") & !has_name(list(...), "name"))
    data <- rename_(data, "name" = "group")  
  
  series <- list_parse(data)
  
  series
  
}

data_to_options <- function(data, type) {
  
  opts <- list()
  
  # x
  if (has_name(data, "x")) {
    if (is.Date(data[["x"]])) {
      opts$xAxis_type <- "datetime"
    } else if (is.character(data[["x"]]) | is.factor(data[["x"]])) {
      opts$xAxis_type <- "category"
    } else {
      opts$xAxis_type <- "linear"
    }
  }
  
  # y
  if (has_name(data, "x")) {
    if (is.Date(data[["y"]])) {
      opts$yAxis_type <- "datetime"
    } else if (is.character(data[["y"]]) | is.factor(data[["y"]])) {
      opts$yAxis_type <- "category"
    } else {
      opts$yAxis_type <- "linear"
    }
  }  
  
  # showInLegend
  opts$series_plotOptions_showInLegend <- "group" %in% names(data)
  
  # colorAxis
  opts$add_colorAxis <- 
    (type == "treemap" & "color" %in% names(data)) | (type == "heatmap")
  
  # series marker enabled
  opts$series_marker_enabled <- !(type %in% c("line", "spline"))
  
  # heatmap
  if (type == "heatmap") {
    if (!is.numeric(data[["x"]])) {
      opts$xAxis_categories <- levels(as.factor(data[["x"]]))
    }
    if (!is.numeric(data[["y"]])) {
      opts$yAxis_categories <- levels(as.factor(data[["y"]]))
    }
  }
  
  opts
  
}


#' Removing series to highchart objects
#'
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param names The series's names to delete.
#' 
#' @export
hc_rm_series <- function(hc, names = NULL) {
  
  stopifnot(!is.null(names))
  
  positions <- hc$x$hc_opts$series %>%
    map("name") %>%
    unlist()
  
  position <- which(positions %in% names)
  
  hc$x$hc_opts$series[position] <- NULL
  
  hc
  
}
