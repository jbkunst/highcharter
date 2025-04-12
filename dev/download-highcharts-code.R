# packages ----------------------------------------------------------------
library(purrr)
library(rvest)
library(dplyr)
library(yaml)
library(stringr)

# settings ----------------------------------------------------------------
# version to download
version <- "12.2.0"
hccodeurl <- "http://code.highcharts.com"

path       <- sprintf("inst/htmlwidgets/lib/highcharts")
path_temp  <- sprintf("inst/htmlwidgets/lib/highcharts-temp")

# creating folder structure
folders <- c("", "modules", "plugins", "css", "custom")
try(map(file.path(path_temp, folders), dir.create))

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

basename(files)

main <- str_subset(files, "code/highcharts")
main
  
file.copy(
  main,
  file.path(path_temp, basename(main)),
  overwrite = TRUE
)

modules <- str_subset(files, "code/modules")
modules

file.copy(
  modules,
  file.path(path_temp, "modules", basename(modules)),
  overwrite = TRUE
)


# map ---------------------------------------------------------------------
urlmapmodule <- sprintf("https://code.highcharts.com/maps/%s/modules/map.js", version)

download.file(
  urlmapmodule,
  file.path(path_temp, "modules", basename(urlmapmodule))
)

# check what modules are missing in yaml ----------------------------------
modules <- dir(file.path(path, "modules")) 
modules

modules_yalm <- readLines("inst/htmlwidgets/highchart.yaml") %>% 
  str_subset("modules/") %>%
  str_extract("modules/.*") %>% 
  str_trim() %>% 
  basename()

# copy and paste if this is not empty
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
  # "http://blacklabel.github.io/multicolor_series/js/multicolor_series.js",
  "https://raw.githubusercontent.com/larsac07/Motion-Highcharts-Plugin/master/motion.js",
  "https://raw.githubusercontent.com/highcharts/draggable-legend/master/draggable-legend.js",
  # "https://raw.githubusercontent.com/rudovjan/highcharts-tooltip-delay/master/tooltip-delay.js",
  "https://raw.githubusercontent.com/blacklabel/grouped_categories/master/grouped-categories.js",
  "https://raw.githubusercontent.com/streamlinesocial/highcharts-regression/master/highcharts-regression.js"
  # "https://raw.githubusercontent.com/highcharts/pattern-fill/master/pattern-fill-v2.js",
  # "https://raw.githubusercontent.com/blacklabel/annotations/master/js/annotations.js",
  # "https://raw.githubusercontent.com/highcharts/export-csv/master/export-csv.js",
  # "https://raw.githubusercontent.com/highcharts/draggable-points/master/draggable-points.js",
  )

walk2(
  files,
  file.path(path_temp, "plugins", basename(files)),
  download.file
)

# customs -----------------------------------------------------------------
file.copy(
  dir(file.path(path, "custom"), full.names = TRUE),
  str_replace(dir(file.path(path, "custom"), full.names = TRUE), path, path_temp),
  overwrite = TRUE
)

file.copy(
  dir(file.path(path, "css"), full.names = TRUE),
  str_replace(dir(file.path(path, "css"), full.names = TRUE), path, path_temp),
  overwrite = TRUE
)

# moving ------------------------------------------------------------------
try(fs::dir_delete(path))

try(fs::dir_create(path))

try(map(file.path(path, folders), fs::dir_create))

file.copy(
  dir(file.path(path_temp), full.names = TRUE, recursive = TRUE),
  str_replace(dir(file.path(path_temp), full.names = TRUE, recursive = TRUE), path_temp, path),
  overwrite = TRUE
)

try(fs::dir_delete(path_temp))

# change the version on yaml ----------------------------------------------
walk(1:5, ~ message("change version on inst/htmlwidgets/highchart.yaml and inst/htmlwidgets/highchartzero.yaml"))
walk(1:5, ~ message("Line 11 in inst/htmlwidgets/highchart.yaml"))





