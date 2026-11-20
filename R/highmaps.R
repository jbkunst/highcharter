#' Add a map series
#'
#' @param hc A `highchart` `htmlwidget` object.
#' @param map A `list` object loaded from a geojson file.
#' @param df A `data.frame` object with data to chart. Code region and value are
#'   required.
#' @param value A string value with the name of the variable to chart.
#' @param joinBy What property to join the  \code{map} and \code{df}
#' @param ... Additional shared arguments for the data series
#'   (\url{https://api.highcharts.com/highcharts/series}).
#'
#' @examples
#'
#' path <- system.file("maps/custom/world-robinson-lowres.rds", package = "highcharter")
#' world <- readRDS(path)
#' income <- subset(world_income, year == 2024)
#' highchart(type = "map") |>
#'   hc_add_series_map(world, income, value = "gni_per_capita",
#'     joinBy = c("iso-a3", "iso3"), name = "GNI per capita"
#'   ) |>
#'   hc_tooltip(valuePrefix = "$", valueDecimals = 0)
#'
#' @details This function force the highchart object to be map type.
#' @importFrom utils tail
#' @export
hc_add_series_map <- function(hc, map, df, value, joinBy, ...) {
  stopifnot(
    is.highchart(hc),
    is.list(map),
    is.data.frame(df),
    length(value) == 1L,
    value %in% names(df),
    length(joinBy) > 0L,
    tail(joinBy, 1) %in% names(df)
  )

  ddta <- rename(df, value := value)
  ddta <- list_parse(ddta)

  hc$x$type <- "map"

  hc |>
    hc_add_series(
      mapData = map,
      data = ddta,
      joinBy = joinBy,
      ...
    ) |>
    hc_colorAxis(min = 0)
}

#' List installed maps
#'
#' @return A character vector of map identifiers accepted by [hcmap()].
#'   Country maps use two-letter codes. World and regional maps use collection paths.
#' @examples
#' head(hc_maps())
#' grep("^custom/", hc_maps(), value = TRUE)
#' @export
hc_maps <- function() {
  files <- list.files(
    system.file("maps", package = "highcharter", mustWork = TRUE),
    pattern = "\\.rds$",
    recursive = TRUE
  )
  ids <- sub("\\.rds$", "", files)
  sub("\\.topo$", ".topo.json", ids)
}

#' Create a map chart
#'
#' Draw a packaged country map offline, load another map by its
#' [Highcharts collection](https://code.highcharts.com/mapdata/) path, or supply
#' a GeoJSON or TopoJSON list.
#'
#' @param map A two-letter country code (case-insensitive), a collection path
#'   such as `"countries/jp/jp-all"` or `"custom/world"`, or a loaded map list.
#'   See [hc_maps()] for installed identifiers. Country codes and their matching
#'   collection paths use the same local file.
#' @param download_map_data For maps outside the package, download the map in R
#'   (`TRUE`) or attach the CDN script to the widget (`FALSE`). Defaults to
#'   `getOption("highcharter.download_map_data")`.
#' @param data Optional data to make a choropleth, in case of use
#'   the joinBy and value are needed.
#' @param value A string value with the name of the variable to chart.
#' @param joinBy What property to join the \code{map} and \code{df}.
#' @param ... Additional shared arguments for the data series
#'   (\url{https://api.highcharts.com/highcharts/series}).
#'
#' @examples
#'
#' hcmap("jp")
#' hcmap("custom/south-america", showInLegend = FALSE)
#' hcmap("custom/world-robinson-lowres", data = subset(world_income, year == 2024),
#'   value = "gni_per_capita",
#'   joinBy = c("iso-a3", "iso3")
#' )
#'
#' # Read a local GeoJSON or TopoJSON file and plot its boundaries.
#' path <- system.file("extdata", "districts.topo.json", package = "highcharter")
#' map <- jsonlite::read_json(path, simplifyVector = FALSE)
#' hcmap(map, showInLegend = FALSE)
#' @importFrom htmltools htmlDependency
#' @importFrom rlang .data
#' @export
hcmap <- function(
  map = "custom/world",
  download_map_data = getOption("highcharter.download_map_data"),
  data = NULL,
  value = NULL,
  joinBy = NULL,
  ...
) {
  validate_args("hcmap", rlang::enquos(...))
  hc <- highchart(type = "map")

  if (is.character(map)) {
    local <- packaged_map_file(map)
    if (nzchar(local)) map <- readRDS(local)
  }
  if (is.list(map)) {
    mapdata <- map
  } else {
    map <- fix_map_name(map)
    if (download_map_data) {
      mapdata <- download_map_data(map)
    } else {
      dep <- htmlDependency(
        name = basename(map),
        version = "0.1.0",
        src = c(href = "https://code.highcharts.com/mapdata"),
        script = map
      )

      hc$dependencies <- c(hc$dependencies, list(dep))
      mapdata <- JS(sprintf(
        "Highcharts.maps['%s']",
        str_replace(map, "\\.js$", "")
      ))
    }
  }

  if (is.null(data)) {
    hc <- hc |>
      hc_add_series.default(
        mapData = mapdata,
        ...
      )
  } else {
    data <- rename(data, value := all_of(value))

    hc <- hc |>
      hc_add_series.default(
        mapData = mapdata,
        data = list_parse(data),
        joinBy = joinBy,
        ...
      ) |>
      hc_colorAxis(auxpar = NULL)
  }

  hc |>
    hc_credits(enabled = TRUE)
}

#' Helper function to download the map data form a url
#'
#' The urls are listed in \url{https://code.highcharts.com/mapdata/}.
#' @param url The map's url.
#' @param showinfo Show the properties of the downloaded map to know how
#'   are the keys to add data in \code{hcmap}.
#' @param quiet Boolean parameter to turn off download messages (on by default).
#' @param method A string value for the download method used by
#'   \code{\link[utils]{download.file}}. Defaults to R's configured method.
#' @examples
#' \dontrun{
#' mpdta <- download_map_data("https://code.highcharts.com/mapdata/countries/us/us-ca-all.js")
#' mpdta <- download_map_data("https://code.highcharts.com/mapdata/countries/us/us-ca-all.js",
#'   quiet = TRUE
#' )
#' str(mpdta, 1)
#' }
#' @seealso \code{\link{hcmap}}
#' @importFrom dplyr glimpse
#' @importFrom utils download.file
#' @importFrom stringr str_remove
#' @export
download_map_data <- function(
  url = "custom/world.js",
  showinfo = FALSE,
  quiet = FALSE,
  method = getOption("download.file.method", "auto")
) {
  url <- sprintf(
    "https://code.highcharts.com/mapdata/%s",
    fix_map_name(url)
  )

  tmpfile <- tempfile(fileext = ".js")
  on.exit(unlink(tmpfile), add = TRUE)
  download.file(url, tmpfile, quiet = quiet, method = method)
  mapdata <- readLines(tmpfile, warn = FALSE, encoding = "UTF-8")
  mapdata[1] <- gsub(".* = ", "", mapdata[1])
  mapdata <- paste(mapdata, collapse = "\n")
  mapdata <- stringr::str_remove(mapdata, ";$")
  mapdata <- jsonlite::fromJSON(mapdata, simplifyVector = FALSE)

  if (showinfo) {
    glimpse(get_data_from_map(mapdata))
  }

  mapdata
}

#' Helper function to get the data inside the map data
#' @param mapdata A GeoJSON FeatureCollection or a TopoJSON Topology read as
#'   an R list. For TopoJSON, the first object's geometry collection supplies
#'   the properties, matching the layer drawn by [hcmap()].
#' @return A tibble of feature properties, including any keys used by `joinBy`.
#' @examples
#' path <- system.file("maps/custom/world-robinson-lowres.rds", package = "highcharter")
#' head(get_data_from_map(readRDS(path)))
#' @seealso [hcmap()], [download_map_data()]
#' @export
get_data_from_map <- function(mapdata) {
  features <- if (identical(mapdata$type, "Topology")) {
    mapdata$objects[[1L]]$geometries
  } else {
    mapdata$features
  }
  properties <- lapply(features, function(feature) {
    Filter(Negate(is.null), feature[["properties"]])
  })
  dplyr::bind_rows(properties)
}

packaged_map_file <- function(map) {
  if (length(map) != 1L || is.na(map) || !nzchar(map)) {
    stop("Supply one country code or map path.", call. = FALSE)
  }
  key <- sub("\\.js$", "", map)
  if (grepl("^[A-Za-z]{2}$", key)) {
    path <- system.file(
      "maps",
      paste0(tolower(key), ".rds"),
      package = "highcharter"
    )
    if (!nzchar(path)) {
      stop("No packaged country map for: ", map, call. = FALSE)
    }
    return(path)
  }
  if (grepl("^countries/([a-z]{2})/\\1-all$", key)) {
    key <- basename(dirname(key))
  } else if (!grepl("^custom/[a-z0-9-]+(\\.topo\\.json)?$", key)) {
    return("")
  }
  key <- sub("\\.json$", "", key)
  system.file("maps", paste0(key, ".rds"), package = "highcharter")
}

fix_map_name <- function(x = "custom/world") {
  x <- sub("^https://code\\.highcharts\\.com/mapdata/", "", x)
  sprintf("%s.js", sub("\\.js$", "", x))
}
