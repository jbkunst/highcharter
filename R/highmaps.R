#' Add a map series
#' 
#' @param hc A `highchart` `htmlwidget` object. 
#' @param map A `list` object loaded from a geojson file.
#' @param df A `data.frame` object with data to chart. Code region and value are
#'   required.
#' @param value A string value with the name of the columnn to chart.
#' @param joinBy What property to join the  \code{map} and \code{df}
#' @param ... Additional shared arguments for the data series
#'   (\url{http://api.highcharts.com/highcharts#series}).
#'   
#' @examples 
#' 
#' library("dplyr")
#' 
#' data("USArrests", package = "datasets")
#' data("usgeojson")
#' 
#' USArrests <- mutate(USArrests, state = rownames(USArrests))
#' 
#' highchart() %>% 
#'   hc_title(text = "Violent Crime Rates by US State") %>% 
#'   hc_subtitle(text = "Source: USArrests data") %>% 
#'   hc_add_series_map(usgeojson, USArrests, name = "Murder arrests (per 100,000)",
#'                     value = "Murder", joinBy = c("woename", "state"),
#'                     dataLabels = list(enabled = TRUE,
#'                                       format = '{point.properties.postalcode}')) %>% 
#'   hc_colorAxis(stops = color_stops()) %>% 
#'   hc_legend(valueDecimals = 0, valueSuffix = "%") %>%
#'   hc_mapNavigation(enabled = TRUE) 
#' 
#' \dontrun{
#' 
#' data(worldgeojson, package = "highcharter")
#' data("GNI2014", package = "treemap")
#' 
#' highchart(type = "map") %>% 
#'   hc_add_series_map(map = worldgeojson, df = GNI2014, value = "GNI", joinBy = "iso3") %>% 
#'   hc_colorAxis(stops = color_stops()) %>% 
#'   hc_tooltip(useHTML = TRUE, headerFormat = "",
#'   pointFormat = "this is {point.name} and have {point.population} people with gni of {point.GNI}")
#'   
#'  }
#'   
#' @details This function force the highchart object to be map type.
#' @importFrom utils tail
#' @export
hc_add_series_map <- function(hc, map, df, value, joinBy, ...) {
  
  assertthat::assert_that(is.highchart(hc),
                          is.list(map),
                          is.data.frame(df),
                          value %in% names(df),
                          tail(joinBy, 1) %in% names(df))
  
  joindf <- tail(joinBy, 1)
  
  ddta <- mutate_(df, "value" = value, "code" = joindf)
  ddta <- list_parse(ddta)
  
  hc$x$type <- "map"
  
  hc %>% 
    hc_add_series(mapData = map, data = ddta,
                  joinBy = c(joinBy[1], "code"),
                  ...) %>% 
    hc_colorAxis(min = 0)
  
}

#' Shortcut for create map from \url{https://code.highcharts.com/mapdata/}
#' collection.
#' @param map String indicating what map to chart, a list from 
#'   \url{https://code.highcharts.com/mapdata/}. See examples.
#' @param download_map_data A logical value whether to download
#'   (add as a dependency) the map. Default \code{TRUE} via
#'   \code{getOption("highcharter.download_map_data")}.
#' @param data Optional data to make a choropleth, in case of use
#'   the joinBy and value are needed.
#' @param value A string value with the name of the columnn to chart.
#' @param joinBy What property to join the \code{map} and \code{df}.
#' @param ... Additional shared arguments for the data series
#'   (\url{http://api.highcharts.com/highcharts#series}).
#'   
#' @examples
#' hcmap(nullColor = "#DADADA")
#' hcmap(nullColor = "#DADADA", download_map_data = FALSE)
#' 
#' require(dplyr) 
#' data("USArrests", package = "datasets")
#' USArrests <- mutate(USArrests, "woe-name" = rownames(USArrests))
#' 
#' hcmap(map = "countries/us/us-all", data = USArrests,
#'       joinBy = "woe-name", value = "UrbanPop", name = "Urban Population")
#'       
#' # download_map_data = FALSE        
#' hcmap(map = "countries/us/us-all", data = USArrests,
#'       joinBy = "woe-name", value = "UrbanPop", name = "Urban Population",
#'       download_map_data = FALSE) 
#'   
#' @importFrom htmltools htmlDependency
#' @export
hcmap <- function(map = "custom/world",
                  download_map_data = getOption("highcharter.download_map_data"),
                  data = NULL, value = NULL, joinBy = NULL, 
                  ...) {
  
  map <- fix_map_name(map)
  
  hc <- highchart(type = "map")
  
  if (download_map_data) {
    
    mapdata <- download_map_data(map)
    
  } else {
    
    dep <-  htmlDependency(
      name = basename(map),
      version = "0.1.0",
      src = c(href = "https://code.highcharts.com/mapdata"),
      script = map
    )
    
    hc$dependencies <- c(hc$dependencies, list(dep))
    mapdata <- json_verbatim(sprintf("Highcharts.maps['%s']", str_replace(map, "\\.js$", "")))
    
  }
  
  if (is.null(data)) {
    
    hc <- hc %>% 
      hc_add_series.default(
        mapData = mapdata, ...)
    
  } else {
    
    data <- mutate_(data, "value" = value)
    
    hc <- hc %>% 
      hc_add_series.default(
        mapData = mapdata,
        data = list_parse(data), joinBy = joinBy, ...) %>% 
      hc_colorAxis(auxpar = NULL)
    
  }
  
  hc %>% 
    hc_credits(enabled = TRUE)
  
}

#' Helper function to download the map data form a url
#' 
#' The urls are listed in \url{https://code.highcharts.com/mapdata/}.
#' @param url The map's url.
#' @param showinfo Show the properties of the downloaded map to know how
#'   are the keys to add data in \code{hcmap}.
#' @examples
#' \dontrun{
#' mpdta <- download_map_data("https://code.highcharts.com/mapdata/countries/us/us-ca-all.js")
#' str(mpdta, 1)
#' }
#' @seealso \code{\link{hcmap}}
#' @importFrom dplyr glimpse
#' @importFrom utils download.file
#' @export
download_map_data <- function(url = "custom/world.js", showinfo = FALSE) {
  
  url <- sprintf("https://code.highcharts.com/mapdata/%s",
                 fix_map_name(url))
  
  tmpfile <- tempfile(fileext = ".js")
  download.file(url, tmpfile)
  mapdata <- readLines(tmpfile, warn = FALSE, encoding = "UTF-8")
  mapdata[1] <- gsub(".* = ", "", mapdata[1])
  mapdata <- paste(mapdata, collapse = "\n")
  mapdata <- jsonlite::fromJSON(mapdata, simplifyVector = FALSE)
  
  if (showinfo) {
    glimpse(get_data_from_map(mapdata))
  }
  
  mapdata
  
}

#' Helper function to get the data inside the map data
#' The urls are listed in \url{https://code.highcharts.com/mapdata/}.
#' @param mapdata A list obtained from \code{\link{download_map_data}}.
#' @examples
#' dta <- download_map_data("https://code.highcharts.com/mapdata/countries/us/us-ca-all.js")
#' get_data_from_map(dta)
#' @seealso \code{\link{download_map_data}}
#' @importFrom purrr map_lgl
#' @export
get_data_from_map <- function(mapdata) {
  mapdata$features %>%
    map("properties") %>%
    map_df(function(x) {
      x[!map_lgl(x, is.null)]
      })
}

fix_map_name <- function(x = "custom/world") {
  x <- str_replace(x, "\\.js$", "")
  x <- str_replace(x, "https://code\\.highcharts\\.com/mapdata/", "")
  x <- sprintf("%s.js", x)
  x
}
