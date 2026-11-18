# Run from the package root. Only maintenance requires Node/npx (mapshaper).
revision <- "9a96e58cc818b66d246cc58e31448c3167b9a3b1"
archive <- tempfile(fileext = ".tar.gz")
work <- tempfile()
dir.create(work)
download.file(
  paste0(
    "https://codeload.github.com/highcharts/map-collection-dist/tar.gz/",
    revision
  ),
  archive,
  mode = "wb"
)
utils::untar(archive, exdir = work)
root <- file.path(work, paste0("map-collection-dist-", revision))
files <- list.files(
  file.path(root, "countries"),
  pattern = "-all\\.geo\\.json$",
  recursive = TRUE
)
files <- grep("^([a-z]{2})/\\1-all\\.geo\\.json$", files, value = TRUE)
stopifnot(length(files) == 202)
out <- file.path("inst", "maps")
dir.create(file.path(out, "custom"), recursive = TRUE, showWarnings = FALSE)
for (path in files) {
  map <- jsonlite::read_json(file.path(root, "countries", path))
  saveRDS(
    map,
    file.path(out, paste0(dirname(path), ".rds")),
    compress = "xz",
    version = 2
  )
}

for (name in c(
  "world",
  "world-robinson-lowres",
  "europe",
  "south-america",
  "world.topo"
)) {
  suffix <- if (endsWith(name, ".topo")) ".json" else ".geo.json"
  map <- jsonlite::read_json(file.path(root, "custom", paste0(name, suffix)))
  saveRDS(
    map,
    file.path(out, "custom", paste0(name, ".rds")),
    compress = "xz",
    version = 2
  )
}

# The upstream Chile map predates Ñuble. Use the 16 BCN/OCHA ADM1 regions
# distributed by geoBoundaries. Keep the original Highcharts join keys.
source_url <- paste0(
  "https://media.githubusercontent.com/media/wmgeolab/geoBoundaries/9469f09/",
  "releaseData/gbOpen/CHL/ADM1/geoBoundaries-CHL-ADM1_simplified.geojson"
)
input <- file.path(work, "chile.geojson")
output <- file.path(work, "regions.geojson")
download.file(source_url, input, mode = "wb")
status <- system2(
  "npx",
  c(
    "--yes",
    "--package=mapshaper@0.6.113",
    "mapshaper",
    shQuote(input),
    "-simplify",
    "4%",
    "keep-shapes",
    "-o",
    "precision=0.001",
    shQuote(output)
  )
)
stopifnot(status == 0)
chile <- jsonlite::read_json(output)
original <- readRDS(file.path(out, "cl.rds"))
# Ordered by the two-digit Chilean official territorial code (CUT), 01–16.
shape_ids <- paste0(
  "47653553B",
  c(
    "97418467345315",
    "40993810137393",
    "71653813080592",
    "91907313612474",
    "5611469222723",
    "66141875659978",
    "65340542415201",
    "66835736668351",
    "84299910343297",
    "69224850096491",
    "77266651052380",
    "86325292267162",
    "78904739401519",
    "67595840047202",
    "1207481020383",
    "32293817275864"
  )
)
keys <- paste0(
  "cl-",
  c(
    "ta",
    "an",
    "at",
    "co",
    "vs",
    "li",
    "ml",
    "bi",
    "2730",
    "ll",
    "ai",
    "ma",
    "rm",
    "ar",
    "2740",
    "nb"
  )
)
legacy <- lapply(original$features, "[[", "properties")
names(legacy) <- vapply(legacy, "[[", character(1), "hc-key")
ids <- vapply(
  chile$features,
  function(feature) feature$properties$shapeID,
  character(1)
)
stopifnot(
  length(ids) == 16,
  setequal(ids, shape_ids),
  setequal(names(legacy), keys[-16])
)
chile$features <- lapply(seq_along(shape_ids), function(i) {
  feature <- chile$features[[match(shape_ids[i], ids)]]
  properties <- legacy[[keys[i]]]
  if (is.null(properties)) {
    properties <- list(
      name = "Ñuble",
      country = "Chile",
      `hc-key` = "cl-nb",
      `hc-group` = "admin1"
    )
  }
  properties$cut <- sprintf("%02d", i)
  feature$id <- properties$cut
  feature$properties <- properties
  feature
})
chile$title <- "Chile"
chile$copyright <- paste(
  "Regional boundaries: BCN Chile and OCHA ROLAC via geoBoundaries",
  "(CC BY 3.0 IGO), simplified. Join properties: Highcharts / Natural Earth."
)
chile$copyrightShort <- "BCN / OCHA · geoBoundaries"
chile$copyrightUrl <- "https://www.geoboundaries.org/api/current/gbOpen/CHL/ADM1/"
saveRDS(chile, file.path(out, "cl.rds"), compress = "xz", version = 2)
