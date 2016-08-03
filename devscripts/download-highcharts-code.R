library(purrr)

version <- "4.2.6"
path <- sprintf("inst/htmlwidgets/lib/highcharts-%s/", version)
try(dir.create(path))


# MAIN FILES --------------------------------------------------------------
files <- c(
  "http://code.highcharts.com/highcharts.js",
  "http://code.highcharts.com/stock/highstock.js",
  "http://code.highcharts.com/highcharts-more.js",
  "http://code.highcharts.com/highcharts-3d.js"
)

file.path(path, basename(files))

map2(files, file.path(path, basename(files)), download.file)


# MODULES -----------------------------------------------------------------
url <- "http://code.highcharts.com/modules"
files <- c(
  "exporting.js",
  "boost.js",
  "drilldown.js",
  "data.js",
  "heatmap.js",
  "treemap.js",
  "funnel.js",
  "solid-gauge.js",
  "no-data-to-display.js"
  )

try(dir.create(file.path(path, basename(url))))

map2(
  file.path(url, files),
  file.path(path, basename(url), basename(files)),
  download.file
)

# MAP ---------------------------------------------------------------------
url <- "http://code.highcharts.com/maps/modules"
files <- c("map.js")

map2(
  file.path(url, files),
  file.path(path, basename(url), basename(files)),
  download.file
)


# PLUGINS -----------------------------------------------------------------
try(dir.create(file.path(path, "plugins")))

files <- c(
  "https://raw.githubusercontent.com/blacklabel/annotations/master/js/annotations.js",
  "https://rawgit.com/larsac07/Motion-Highcharts-Plugin/master/motion.js",
  "https://raw.githubusercontent.com/highcharts/pattern-fill/master/pattern-fill-v2.js",
  "https://raw.githubusercontent.com/highcharts/draggable-points/master/draggable-points.js",
  "https://raw.githubusercontent.com/highcharts/draggable-legend/master/draggable-legend.js"
  )

map2(
  files,
  file.path(path, "plugins", basename(files)),
  download.file
)

try(dir.create(file.path(path, "css")))

# MY SCRIPTS --------------------------------------------------------------
message("PLZ DON'T FORGET!")
message("symbols-extras.js")
message("reset.js")
message("motion.css")



