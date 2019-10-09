# packages ----------------------------------------------------------------
library(purrr)
library(rvest)
library(dplyr)
library(yaml)
library(stringr)

# settings ----------------------------------------------------------------
version <- "7.2.0"
hccodeurl <- "http://code.highcharts.com"
path <- sprintf("inst/htmlwidgets/lib/highcharts-%s", version)

yml <- system.file("htmlwidgets/highchart.yaml", package = "highcharter")
yml <- yaml.load_file(yml)[[1]]
version_old <- map_chr(yml, c("version"))[map_chr(yml, c("name")) == "highcharts"]
path_old <- str_replace(path, version, version_old)

# creating folder structure
folders <- c("", "modules", "plugins", "css", "custom")
try(map(file.path(path, folders), dir.create))

# main files --------------------------------------------------------------
file_temp <- tempfile(fileext = ".zip")

download.file(
  sprintf("https://code.highcharts.com/zips/Highcharts-%s.zip", version),
  file_temp
)

folder_temp <- tempdir()

unzip(file_temp, exdir = folder_temp)

files <- dir(folder_temp, recursive = TRUE, full.names = TRUE) %>% 
  str_subset("src.js$", negate = TRUE) %>% 
  str_subset("js.map$", negate = TRUE)

main <- str_subset(files, "code/highcharts")
main
  
file.copy(
  main,
  file.path(path, basename(main)),
  overwrite = TRUE
)

modules <- str_subset(files, "code/modules")
modules

file.copy(
  modules,
  file.path(path, "modules", basename(modules)),
  overwrite = TRUE
)

# map
file_temp <- tempfile(fileext = ".zip")

download.file(
  sprintf("https://code.highcharts.com/zips/Highmaps-%s.zip", version),
  file_temp
)

folder_temp <- tempdir()

unzip(file_temp, exdir = folder_temp)

files <- dir(folder_temp, recursive = TRUE, full.names = TRUE) %>% 
  str_subset("src.js$", negate = TRUE) %>% 
  str_subset("js.map$", negate = TRUE)

mapmodule <- files %>% 
  str_subset("modules/map.js$")

file.copy(
  mapmodule,
  file.path(path, "modules", basename(mapmodule)),
  overwrite = TRUE
)

# check what modules are missing in yaml
modules <- dir(file.path(path, "modules")) 
modules

modules_yalm <- readLines("inst/htmlwidgets/highchart.yaml") %>% 
  str_subset("modules/") %>%
  str_extract("modules/.*") %>% 
  str_trim() %>% 
  basename()

# copy and paste y this is not empty
setdiff(modules, modules_yalm) %>% 
  str_c("#    - modules/", ., "\n") %>% 
  message()

# sobran
setdiff(modules_yalm, modules)

# repetidos en yalm
tibble(m = modules_yalm) %>% 
  count(m, sort = TRUE) %>% 
  filter(n > 1)

# plugins -----------------------------------------------------------------
files <- c(
  # "https://raw.githubusercontent.com/blacklabel/annotations/master/js/annotations.js",
  # "https://raw.githubusercontent.com/highcharts/export-csv/master/export-csv.js",
  # "https://raw.githubusercontent.com/highcharts/draggable-points/master/draggable-points.js",
  "http://blacklabel.github.io/multicolor_series/js/multicolor_series.js",
  "https://raw.githubusercontent.com/larsac07/Motion-Highcharts-Plugin/master/motion.js",
  "https://raw.githubusercontent.com/highcharts/pattern-fill/master/pattern-fill-v2.js",
  "https://raw.githubusercontent.com/highcharts/draggable-legend/master/draggable-legend.js",
  "https://raw.githubusercontent.com/rudovjan/highcharts-tooltip-delay/master/tooltip-delay.js",
  "https://raw.githubusercontent.com/blacklabel/grouped_categories/master/grouped-categories.js",
  "https://raw.githubusercontent.com/streamlinesocial/highcharts-regression/master/highcharts-regression.js"
  )

aux <- map2(
  files,
  file.path(path, "plugins", basename(files)),
  download.file
)

# file.copy(
#   file.path(path_old, "plugins", basename(files)),
#   file.path(path, "plugins", basename(files)),
#   overwrite = TRUE
# )

# for yaml ----------------------------------------------------------------
# path %>%
#   dir(recursive = TRUE, full.names = TRUE, pattern = ".js$") %>%
#   str_replace(path, "    - ") %>%
#   str_replace("/", "") %>%
#   paste0(collapse = "\n") %>%
#   cat()
  
# my customs --------------------------------------------------------------
file.copy(
  dir(file.path(path_old, "custom"), full.names = TRUE),
  str_replace(dir(file.path(path_old, "custom"), full.names = TRUE), version_old, version),
  overwrite = TRUE
)

file.copy(
  dir(file.path(path_old, "css"), full.names = TRUE),
  str_replace(dir(file.path(path_old, "css"), full.names = TRUE), version_old, version),
  overwrite = TRUE
)



