# Snapshot the upstream geometries with their original attribution and join keys.
collection <- "https://raw.githubusercontent.com/highcharts/map-collection-dist/9a96e58cc818b66d246cc58e31448c3167b9a3b1"
paths <- c(
  world_robinson = "custom/world-robinson-lowres.geo.json",
  world = "custom/world.topo.json",
  europe = "custom/europe.geo.json",
  south_america = "custom/south-america.geo.json",
  new_zealand = "countries/nz/nz-all.geo.json"
)
hc_maps <- lapply(paths, function(path) {
  jsonlite::read_json(paste(collection, path, sep = "/"))
})
save(hc_maps, file = "data/hc_maps.rda", compress = "xz", version = 2)

utils::data("GNI2014", package = "treemap")
gni2014 <- GNI2014
save(gni2014, file = "data/gni2014.rda", compress = "xz", version = 2)
