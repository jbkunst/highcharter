library(purrr)
# worldgeojson ------------------------------------------------------------
url <- "https://code.highcharts.com/mapdata/custom/world.js"
tmpfile <- tempfile(fileext = ".json")
download.file(url, tmpfile)

worldgeojson <- readLines(tmpfile)
worldgeojson <- gsub(".* = ", "", worldgeojson)
worldgeojson <- jsonlite::fromJSON(worldgeojson, simplifyVector = FALSE)

worldgeojson$features <- map(worldgeojson$features, function(x){
  # x <- worldgeojson$features[[10]]
  x$properties <- x$properties[!grepl("hc", names(x$properties))]
  names(x$properties) <- gsub("-", "", names(x$properties))
  names(x$properties) <- gsub("isoa", "iso", names(x$properties))
  x$properties <- map(x$properties, function(x){ ifelse(is.null(x), NA, iconv(x, to = "UTF-8")) })
  x
})

map_df(worldgeojson$features, function(x){
  as.data.frame(x$properties, stringsAsFactors = FALSE)
})

devtools::use_data(worldgeojson, overwrite = TRUE)

# usgeojson ---------------------------------------------------------------
url <- "https://code.highcharts.com/mapdata/countries/us/us-all.js"
tmpfile <- tempfile(fileext = ".json")
download.file(url, tmpfile)
usgeojson <- readLines(tmpfile)
usgeojson <- gsub(".* = ", "", usgeojson)
usgeojson <- jsonlite::fromJSON(usgeojson, simplifyVector = FALSE)

usgeojson$features[52] <- NULL

usgeojson$features <- map(usgeojson$features, function(x){
  # x <- uscountygeojson$features[[10]]
  x$properties$code <-  x$properties$`hc-key`
  x$properties <- x$properties[!grepl("hc", names(x$properties))]
  names(x$properties) <- gsub("-", "", names(x$properties))
  names(x$properties) <- gsub("isoa", "iso", names(x$properties))
  x$properties$name <- ifelse(x$properties$code == "us-nm-013", "Dona Ana", x$properties$name)
  x
})

states <- map_df(usgeojson$features, function(x){
  as.data.frame(x$properties, stringsAsFactors = FALSE)
})

states

devtools::use_data(usgeojson, overwrite = TRUE)

# uscountygeojson ---------------------------------------------------------
url <- "https://code.highcharts.com/mapdata/countries/us/us-all-all.js"
tmpfile <- tempfile(fileext = ".json")
download.file(url, tmpfile)
uscountygeojson <- readLines(tmpfile)
uscountygeojson <- gsub(".* = ", "", uscountygeojson)
uscountygeojson <- jsonlite::fromJSON(uscountygeojson, simplifyVector = FALSE)

uscountygeojson$features <- map(uscountygeojson$features, function(x){
  # x <- uscountygeojson$features[[10]]
  x$properties$code <-  x$properties$`hc-key`
  x$properties <- x$properties[!grepl("hc", names(x$properties))]
  names(x$properties) <- gsub("-", "", names(x$properties))
  names(x$properties) <- gsub("isoa", "iso", names(x$properties))
  x$properties$name <- ifelse(x$properties$code == "us-nm-013", "Dona Ana", x$properties$name)
  x
})

counties <- map_df(uscountygeojson$features, function(x){
  as.data.frame(x$properties, stringsAsFactors = FALSE)
})

counties

devtools::use_data(uscountygeojson, overwrite = TRUE)

