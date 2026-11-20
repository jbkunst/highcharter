# WHO/UNICEF Estimates of National Immunization Coverage, 2025 revision.
url <- "https://data.unicef.org/wp-content/uploads/2025/07/wuenic2025rev_web-update.xlsx"
workbook <- tempfile(fileext = ".xlsx")
download.file(url, workbook, mode = "wb")
estimates <- readxl::read_excel(
  workbook,
  sheet = "country",
  range = readxl::cell_cols("A:F")
)
unlink(workbook)

countries <- c("AUS", "BRA", "CHL", "DEU", "IND", "JPN", "KEN", "MEX", "ZAF")
years <- 2000:2025
coverage <- subset(
  estimates,
  iso3c %in% countries & vaccine == "mcv1" & year %in% years,
  select = c(iso3c, country, year, coverage)
)
names(coverage)[1] <- "iso3"
coverage <- coverage[order(coverage$iso3, coverage$year), ]

stopifnot(
  nrow(coverage) == length(countries) * length(years),
  !anyDuplicated(coverage[c("iso3", "year")]),
  all(coverage$coverage >= 0 & coverage$coverage <= 100, na.rm = TRUE)
)
write.csv(
  coverage,
  "vignettes/data/measles-coverage.csv",
  row.names = FALSE,
  quote = FALSE,
  na = ""
)
