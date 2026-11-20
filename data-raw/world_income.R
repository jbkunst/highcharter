# Rebuild the offline World Development Indicators snapshot from the package root.
api <- "https://api.worldbank.org/v2/country"
countries <- jsonlite::fromJSON(paste0(api, "?format=json&per_page=400"))[[2]]
countries <- countries[countries$region$id != "NA", ]
economies <- data.frame(
  iso3 = countries$id,
  country = countries$name,
  region = countries$region$value
)

indicator <- function(code, column) {
  url <- paste0(
    api,
    "/all/indicator/",
    code,
    "?format=json&per_page=1000&date=2024:2025"
  )
  result <- jsonlite::fromJSON(url)
  stopifnot(result[[1]]$pages == 1)
  data <- result[[2]][c("countryiso3code", "date", "value")]
  names(data) <- c("iso3", "year", column)
  data
}

income <- indicator("NY.GNP.PCAP.CD", "gni_per_capita")
people <- indicator("SP.POP.TOTL", "population")
world_income <- merge(
  economies,
  merge(income, people, by = c("iso3", "year")),
  by = "iso3"
)
world_income$year <- as.integer(world_income$year)
world_income <- world_income[order(world_income$iso3, world_income$year), ]
row.names(world_income) <- NULL
stopifnot(!anyDuplicated(world_income[c("iso3", "year")]))
save(world_income, file = "data/world_income.rda", compress = "xz", version = 2)
