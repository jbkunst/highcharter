library("purrr")

#### citytemp ####
library("dplyr")
citytemp <- data_frame(
  month = month.abb,
  tokyo = c(7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6),
  new_york = c(-0.2, 0.8, 5.7, 11.3, 17.0, 22.0, 24.8, 24.1, 20.1, 14.1, 8.6, 2.5),
  berlin = c(-0.9, 0.6, 3.5, 8.4, 13.5, 17.0, 18.6, 17.9, 14.3, 9.0, 3.9, 1.0),
  london = c(3.9, 4.2, 5.7, 8.5, 11.9, 15.2, 17.0, 16.6, 14.2, 10.3, 6.6, 4.8))

save(citytemp, file = "data/citytemp.rda", compress = "xz")

#### favorite_bars ####
favorite_bars <- data_frame(
  bar = c("Mclaren's", "McGee's", "P & G",
          "White Horse Tavern", "King Cole Bar"),
  percent = c(30, 28, 27, 12, 3)
)

save(favorite_bars, file = "data/favorite_bars.rda", compress = "xz")

#### favorite_pies ####
favorite_pies <- data_frame(
  pie = c("Strawberry Rhubarb", "Pumpkin", "Lemon Meringue",
          "Blueberry", "Key Lime"),
  percent = c(85, 64, 75, 100, 57)
)

save(favorite_pies, file = "data/favorite_pies.rda", compress = "xz")

#### worldgeojson ####
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

save(worldgeojson, file = "data/worldgeojson.rda", compress = "xz")

#### unemployment ####
url <- "https://www.highcharts.com/samples/data/jsonp.php?filename=us-counties-unemployment.json"
tmpfile <- tempfile(fileext = ".json")
download.file(url, tmpfile)
unemployment <- readLines(tmpfile)
unemployment <- gsub("callback\\(|\\);$", "", unemployment)
unemployment <- jsonlite::fromJSON(unemployment, simplifyVector = FALSE)
unemployment <- map_df(unemployment, function(x) as.data.frame(x, stringsAsFactors = FALSE))
unemployment$name <- iconv(unemployment$name)

save(unemployment, file = "data/unemployment.rda", compress = "xz")

#### uscountygeojson all all ####
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

save(uscountygeojson, file = "data/uscountygeojson.rda", compress = "xz")

#### usgeojson all all ####
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

save(usgeojson, file = "data/usgeojson.rda", compress = "xz")



#### fontawesome ####
library("stringr")
library("dplyr")
library("rvest")

icons <- readLines("https://raw.githubusercontent.com/FortAwesome/Font-Awesome/master/less/variables.less")
icons <- icons[str_detect(icons, "@fa-var")]

iconsnames <- str_extract(icons, ".*:")
iconsnames <- str_replace_all(iconsnames, "@fa-var-|:", "")

iconcode <-  str_extract(icons, ":.*$")
iconcode <-  str_extract(iconcode, "[[:alnum:]]+")

icons <- read_html("http://fortawesome.github.io/Font-Awesome/cheatsheet/") %>% 
  html_nodes("div.col-md-4.col-sm-6.col-lg-3")

dficons <- purrr::map_df(icons, function(divico){ # divico <- sample(icons, size = 1)[[1]]
  txt <- html_text(divico)
  data_frame(class = str_extract(txt, "fa-.*"),
             name = str_replace(class, "fa-", ""),
             unicode = str_extract(txt, "\\[.*\\]") %>% str_replace_all("\\[|\\]", ""))
}) 

fontawesomeicos <- data_frame(name = iconsnames, code = iconcode) %>% 
  left_join(dficons)

saveRDS(fontawesomeicos, file = "inst/extdata/faicos.rds", compress = "xz")
# save(fontawesomeicos, file = "data/fontawesomeicos.rda", compress = "xz")

