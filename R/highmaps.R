#' Add a map series
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

#' Shorcut for create map
#' 
#' @param map String indicating what map to chart
#' @param data Optional data to make a choropleth, in case of use
#'   the joinBy and value are needed.
#' @param value A string value with the name of the column to chart.
#' @param joinBy What property to join the  \code{map} and \code{df}.
#' @param download_map_data A logical value to download or not (add as a depedeny)
#'   the map.
#' @param ... Aditional shared arguments for the data series
#'   (\url{http://api.highcharts.com/highcharts#series}).
#'   
#' @examples
#' require(dplyr) 
#' hcmap(nullColor = "#DADADA")
#' hcmap(nullColor = "#DADADA", download_map_data = TRUE)
#' 
#' data("USArrests", package = "datasets")
#' USArrests <- mutate(USArrests, "woe-name" = rownames(USArrests))
#' 
#' hcmap(map = "countries/us/us-all", data = USArrests,
#'       joinBy = "woe-name", value = "UrbanPop", name = "Urban Population")
#'       
#' hcmap(map = "countries/us/us-all", data = USArrests,
#'       joinBy = "woe-name", value = "UrbanPop", name = "Urban Population",
#'       download_map_data = TRUE) 
#'   
#' @importFrom htmltools htmlDependency
#' @export
hcmap <- function(map = "custom/world",
                  data = NULL, value = NULL, joinBy = "hc-key", 
                  download_map_data = FALSE, ...) {
  
  url <- "https://code.highcharts.com/mapdata"
  map <- str_replace(map, "\\.js", "")
  map <- str_replace(map, "https://code\\.highcharts\\.com/mapdata/", "")
  mapfile <- sprintf("%s.js", map)
  
  hc <- highchart(type = "map")
  
  if(download_map_data) {
    
    mapdata <- download_map_data(file.path(url, mapfile))
    
  } else {
    
    dep <-  htmlDependency(
      name = basename(map),
      version = "0.1.0",
      src = c(href = url),
      script = mapfile
    )
    
    hc$dependencies <- c(hc$dependencies, list(dep))
    
    mapdata <- JS(sprintf("Highcharts.maps['%s']", map))
    
  }
  
  if(is.null(data)) {
    
    hc <- hc %>% 
      hc_add_series.default(
        mapData = mapdata, ...)
    
  } else {
    
    stopifnot(joinBy %in% names(data))
    data <- mutate_(data, "value" = value)
    
    hc <- hc %>% 
      hc_add_series.default(
        mapData = mapdata,
        data = list_parse(data), joinBy = joinBy, ...) %>% 
      hc_colorAxis(auxpar = NULL)
    
  }
  
  hc
  
}

#' Auxilar function to download the map data form a url
#' The urls are listed in \url{https://code.highcharts.com/mapdata/}.
#' @param url The map's url.
#' @param showinfo Show the properties of the downloaded map to know how
#'   are the keys to add data in \code{hcmap}.
#' @examples
#' mpdta <- download_map_data("https://code.highcharts.com/mapdata/countries/us/us-ca-all.js")
#' str(mpdta, 1)
#' @seealso \code{\link{hcmap}}
#' @importFrom dplyr glimpse
#' @importFrom utils download.file
#' @export
download_map_data <- function(url = "https://code.highcharts.com/mapdata/custom/world.js",
                              showinfo = FALSE) {
  
  tmpfile <- tempfile(fileext = ".js")
  download.file(url, tmpfile)
  mapdata <- readLines(tmpfile, warn = FALSE)
  mapdata[1] <- gsub(".* = ", "", mapdata[1])
  mapdata <- paste(mapdata, collapse = "\n")
  mapdata <- jsonlite::fromJSON(mapdata, simplifyVector = FALSE)
  
  if(showinfo) {
    glimpse(get_data_from_map(mapdata))
  }
  
  mapdata
  
}

#' Auxilar function to get the data inside the map data
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
    map_df(function(x){ x[!map_lgl(x, is.null)] })
}
