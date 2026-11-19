test_that("hchart dispatches both GeoJSON forms and forwards series options", {
  skip_if_not_installed("geojsonio")
  path <- system.file("extdata", "districts.geojson", package = "highcharter")
  districts <- geojsonio::geojson_list(geojsonio::as.json(path))
  for (geo in list(districts, geojsonio::geojson_json(districts))) {
    chart <- hchart(geo, name = "Districts")
    series <- chart$x$hc_opts$series[[1]]
    expect_identical(chart$x$type, "map")
    expect_identical(series$type, "map")
    expect_identical(series$name, "Districts")
    expect_true(series$geojson)
    expect_identical(series$data, geo)
  }
  point <- geojsonio::geojson_list(c(-70.67, -33.45))
  expect_identical(hchart(point)$x$hc_opts$series[[1]]$type, "mappoint")
  route <- point
  route$features[[1]]$geometry <- list(
    type = "LineString",
    coordinates = list(c(-71, -33), c(-70, -34))
  )
  expect_identical(hchart(route)$x$hc_opts$series[[1]]$type, "mapline")
  route$features <- c(point$features, route$features, districts$features)
  types <- c("map", "mapline", "mappoint")
  for (geo in list(route, geojsonio::geojson_json(route))) {
    layers <- hchart(geo, name = "Clinics", id = types)$x$hc_opts$series
    expect_identical(vapply(layers, "[[", "", "type"), types)
    expect_identical(vapply(layers, "[[", "", "id"), types)
    expect_identical(
      vapply(layers, "[[", "", "name"),
      paste("Clinics", c("Polygons", "Lines", "Points"))
    )
    expect_identical(
      vapply(layers, function(s) length(s$data$features), 0L),
      c(2L, 1L, 1L)
    )
    expect_identical(
      hchart(geo, type = "mapline")$x$hc_opts$series[[1]]$type,
      "mapline"
    )
  }
  expect_error(hchart(route, id = "single"), "distinct series ID")
})

test_that("nested GeoJSON geometries preserve feature properties across layers", {
  point <- list(type = "MultiPoint", coordinates = list(c(0, 0), c(1, 1)))
  line <- list(type = "LineString", coordinates = list(c(0, 0), c(1, 1)))
  nested <- list(type = "GeometryCollection", geometries = list(point))
  feature <- list(
    type = "Feature",
    properties = list(name = "Route 1"),
    geometry = list(
      type = "GeometryCollection",
      geometries = list(nested, line)
    )
  )
  geo <- structure(
    list(type = "FeatureCollection", features = list(feature)),
    class = "geo_list"
  )
  layers <- hchart(geo)$x$hc_opts$series
  expect_identical(vapply(layers, "[[", "", "type"), c("mapline", "mappoint"))
  points <- layers[[2]]$data$features
  expect_identical(
    lapply(points, function(f) f$geometry$coordinates),
    point$coordinates
  )
  expect_identical(
    lapply(points, "[[", "properties"),
    rep(list(feature$properties), 2)
  )
})

test_that("hcmap uses a loaded map without downloads or remote dependencies", {
  chart <- hcmap(worldgeojson, showInLegend = FALSE)
  expect_identical(chart$x$type, "map")
  expect_identical(chart$x$hc_opts$series[[1]]$mapData, worldgeojson)
  expect_length(
    Filter(function(dep) !is.null(dep$src$href), chart$dependencies),
    0L
  )
  values <- data.frame(iso3 = "CHL", income = 12345)
  joined <- hcmap(
    worldgeojson,
    data = values,
    value = "income",
    joinBy = "iso3"
  )
  expect_identical(joined$x$hc_opts$series[[1]]$data[[1]]$value, 12345)
  expect_identical(joined$x$hc_opts$series[[1]]$joinBy, "iso3")
})

test_that("country codes and canonical paths use the same installed boundaries", {
  map <- function(key, ...) hcmap(key, ...)$x$hc_opts$series[[1]]$mapData
  chile <- map("cl")
  expect_identical(map("CL"), chile)
  expect_identical(map("countries/cl/cl-all"), chile)
  expect_identical(
    map("countries/cl/cl-all.js", download_map_data = FALSE),
    chile
  )
  regions <- get_data_from_map(chile)
  expect_setequal(regions$cut, sprintf("%02d", 1:16))
  expect_equal(regions$name[regions$cut == "16"], "Ñuble")
  expect_equal(regions$`hc-key`[regions$cut == "08"], "cl-bi")
  expect_equal(map("custom/world.topo.json")$type, "Topology")
  expect_error(map("zz"), "No packaged country map")
  external <- hcmap("countries/us/us-ca-all", download_map_data = FALSE)
  remote <- Filter(function(dep) !is.null(dep$src$href), external$dependencies)
  expect_length(remote, 1L)
  expect_identical(
    remote[[1L]]$script,
    "countries/us/us-ca-all.js"
  )
})

test_that("installed map identifiers resolve to local files", {
  ids <- hc_maps()
  expect_true(all(
    c("jp", "custom/south-america", "custom/world.topo.json") %in% ids
  ))
  expect_identical(anyDuplicated(ids), 0L)
  expect_true(all(file.exists(vapply(ids, packaged_map_file, character(1)))))
})

test_that("TopoJSON properties come from the first map layer", {
  path <- system.file("extdata", "districts.topo.json", package = "highcharter")
  topo <- jsonlite::read_json(path, simplifyVector = FALSE)
  topo$objects$default <- list(type = "GeometryCollection", geometries = list())
  expect_identical(get_data_from_map(topo)$code, c("01", "02"))
})
