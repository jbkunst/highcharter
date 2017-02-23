# packages ----------------------------------------------------------------
library(purrr)
library(rvest)
library(stringr)
library(yaml)
library(stringr)

# settings ----------------------------------------------------------------
version <- "5.0.7"
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
hchtml <- read_html(hccodeurl)

hclnks <- hchtml %>% 
  html_node("ul") %>% # first list
  html_nodes("li") %>% 
  html_text() %>% 
  .[!str_detect(., "src.js")] %>% 
  str_replace("^.*com\\/", "")

map2(
  file.path(hccodeurl, hclnks),
  file.path(path, hclnks),
  download.file
)

# stock & map
hclnks <- c("http://code.highcharts.com/stock/highstock.js",
            "http://code.highcharts.com/maps/modules/map.js") %>% 
  str_replace("^.*com\\/", "")
  
map2(
  file.path(hccodeurl, hclnks),
  str_replace(file.path(path, hclnks), "stock/|maps/", ""),
  download.file
)  


# plugins -----------------------------------------------------------------
files <- c(
  "https://raw.githubusercontent.com/blacklabel/annotations/master/js/annotations.js",
  "http://blacklabel.github.io/multicolor_series/js/multicolor_series.js",
  "https://raw.githubusercontent.com/larsac07/Motion-Highcharts-Plugin/master/motion.js",
  "https://raw.githubusercontent.com/highcharts/pattern-fill/master/pattern-fill-v2.js",
  "https://raw.githubusercontent.com/highcharts/draggable-points/master/draggable-points.js",
  "https://raw.githubusercontent.com/highcharts/draggable-legend/master/draggable-legend.js",
  "https://raw.githubusercontent.com/highcharts/export-csv/master/export-csv.js",
  "https://raw.githubusercontent.com/rudovjan/highcharts-tooltip-delay/master/tooltip-delay.js",
  "https://raw.githubusercontent.com/blacklabel/grouped_categories/master/grouped-categories.js",
  "https://raw.githubusercontent.com/streamlinesocial/highcharts-regression/master/highcharts-regression.js"
  )
# 
# map2(
#   files,
#   file.path(path, "plugins", basename(files)),
#   download.file
# )

file.copy(
  file.path(path_old, "plugins", basename(files)),
  file.path(path, "plugins", basename(files)),
  overwrite = TRUE
)


# for yaml ----------------------------------------------------------------
# path %>% 
#   dir(recursive = TRUE, full.names = TRUE, pattern = ".js$") %>% 
#   setdiff(file.path(path, "modules", c("accessibility.js", "boost.js", "canvas-tools.js"))) %>% 
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



