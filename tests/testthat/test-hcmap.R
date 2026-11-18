test_that("hcmap uses a loaded map without downloads or remote dependencies", {
  chart <- hcmap(worldgeojson, showInLegend = FALSE)
  expect_identical(chart$x$type, "map")
  expect_identical(chart$x$hc_opts$series[[1]]$mapData, worldgeojson)
  expect_null(chart$dependencies)
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
  expect_identical(
    external$dependencies[[1]]$script,
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
