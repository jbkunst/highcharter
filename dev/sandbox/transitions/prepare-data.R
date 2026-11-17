# Data preparation for the homepage. Only base R and jsonlite are required.
# Cached API responses are local build artifacts; the prepared CSVs are versioned.
fetch_wdi <- function(path, cache_file, refresh = FALSE) {
  if (!file.exists(cache_file) || refresh) {
    dir.create(dirname(cache_file), recursive = TRUE, showWarnings = FALSE)
    url <- paste0("https://api.worldbank.org/v2/", path)
    message("Downloading World Bank data: ", url)
    temp <- tempfile(tmpdir = dirname(cache_file), fileext = ".json")
    on.exit(unlink(temp), add = TRUE)
    old_timeout <- getOption("timeout")
    options(timeout = max(90, old_timeout))
    on.exit(options(timeout = old_timeout), add = TRUE)
    utils::download.file(
      url,
      temp,
      method = "libcurl",
      mode = "wb",
      quiet = TRUE,
      headers = c("User-Agent" = "highcharter website data preparation")
    )
    response <- jsonlite::read_json(temp)
    if (
      length(response) != 2L ||
        is.null(response[[1]]$pages) ||
        response[[1]]$pages != 1L
    ) {
      stop("Unexpected or paginated World Bank response: ", url)
    }
    file.copy(temp, cache_file, overwrite = TRUE)
  }
  jsonlite::read_json(cache_file)
}

prepare_home_data <- function(
  refresh = FALSE,
  start_year = 2005L,
  rebuild = FALSE
) {
  data_dir <- file.path("dev", "sandbox", "transitions", "data")
  cache_dir <- file.path("dev", "highcharts-bundle", "preview", "wdi-cache")
  snapshot_file <- file.path(data_dir, "countries.csv")
  history_file <- file.path(data_dir, "exports.csv")
  metadata_file <- file.path(data_dir, "metadata.json")
  if (
    !refresh &&
      !rebuild &&
      all(file.exists(c(snapshot_file, history_file, metadata_file)))
  ) {
    saved <- jsonlite::read_json(metadata_file, simplifyVector = TRUE)
    if (identical(saved$schema_version, 3L) && saved$start_year == start_year) {
      return(list(
        countries = utils::read.csv(snapshot_file, fileEncoding = "UTF-8"),
        history = utils::read.csv(history_file),
        metadata = saved
      ))
    }
  }

  current_year <- as.integer(format(Sys.Date(), "%Y"))
  indicators <- c(
    population = "SP.POP.TOTL",
    life = "SP.DYN.LE00.IN",
    income = "NY.GDP.PCAP.PP.KD",
    urban = "SP.URB.TOTL.IN.ZS",
    exports = "TX.VAL.MRCH.CD.WT",
    imports = "TM.VAL.MRCH.CD.WT"
  )
  geography <- fetch_wdi(
    "country/all?format=json&per_page=400",
    file.path(cache_dir, "economies.json"),
    refresh
  )
  economy_rows <- Filter(
    function(x) x$region$value != "Aggregates",
    geography[[2]]
  )
  economies <- data.frame(
    iso3 = vapply(economy_rows, function(x) x$id, character(1)),
    name = vapply(economy_rows, function(x) x$name, character(1))
  )
  world <- jsonlite::read_json(file.path(
    "dev",
    "examples-charts",
    "data",
    "maps",
    "custom-world.topo.json"
  ))
  features <- world$objects$default$geometries
  continents <- data.frame(
    iso3 = vapply(features, function(x) x$properties[["iso-a3"]], character(1)),
    continent = vapply(
      features,
      function(x) x$properties$continent,
      character(1)
    )
  )
  continents <- continents[!duplicated(continents$iso3), ]
  # Natural Earth's "Seven seas" group is not a continent. Keep these island
  # economies in the same six-region cohort used by every homepage panel.
  island_regions <- c(MDV = "Asia", MUS = "Africa", SYC = "Africa")
  for (iso3 in names(island_regions)) {
    continents$continent[continents$iso3 == iso3] <- island_regions[[iso3]]
  }
  economies <- merge(economies, continents, by = "iso3")

  panels <- list()
  source_dates <- list()
  for (variable in names(indicators)) {
    indicator <- indicators[[variable]]
    years <- if (variable == "exports") {
      seq.int(start_year, current_year)
    } else {
      seq.int(current_year - 3L, current_year)
    }
    # Short ranges avoid slow, very large indicator responses from the API.
    ranges <- split(years, ceiling(seq_along(years) / 5L))
    responses <- lapply(ranges, function(range) {
      period <- paste0(min(range), ":", max(range))
      path <- paste0(
        "country/all/indicator/",
        indicator,
        "?source=2&format=json&date=",
        period,
        "&per_page=20000"
      )
      fetch_wdi(
        path,
        file.path(
          cache_dir,
          paste0(
            variable,
            "-",
            min(range),
            "-",
            max(range),
            ".json"
          )
        ),
        refresh
      )
    })
    rows <- unlist(lapply(responses, `[[`, 2L), recursive = FALSE)
    panel <- data.frame(
      iso3 = vapply(rows, function(x) x$countryiso3code, character(1)),
      year = as.integer(vapply(rows, function(x) x$date, character(1))),
      value = vapply(
        rows,
        function(x) if (is.null(x$value)) NA_real_ else x$value,
        numeric(1)
      )
    )
    names(panel)[3] <- variable
    panels[[variable]] <- panel
    source_dates[[variable]] <- responses[[1]][[1]]$lastupdated
  }
  wide <- Reduce(
    function(x, y) merge(x, y, by = c("iso3", "year"), all = TRUE),
    panels
  )
  country_panel <- merge(wide, economies, by = "iso3")
  coverage <- lapply(
    sort(
      unique(country_panel$year[country_panel$year >= current_year - 3L]),
      decreasing = TRUE
    ),
    function(year) {
      rows <- country_panel[country_panel$year == year, ]
      valid <- stats::complete.cases(rows[names(indicators)]) &
        rows$income > 0 &
        rows$population > 0 &
        rows$exports > 0 &
        rows$imports > 0
      data.frame(
        year = year,
        economies = sum(valid),
        population = sum(rows$population[valid])
      )
    }
  )
  coverage <- do.call(rbind, coverage)
  message("Comparable-country coverage by year:")
  print(utils::head(coverage, 5))
  candidates <- coverage[coverage$economies >= 150L, ]
  if (!nrow(candidates)) {
    stop("No recent year has adequate comparable coverage.")
  }
  year <- max(candidates$year)
  snapshot <- country_panel[country_panel$year == year, ]
  snapshot <- snapshot[stats::complete.cases(snapshot[names(indicators)]), ]
  snapshot <- snapshot[
    snapshot$income > 0 &
      snapshot$population > 0 &
      snapshot$exports > 0 &
      snapshot$imports > 0,
  ]
  history <- country_panel[
    country_panel$year <= year,
    c("iso3", "year", "exports")
  ]
  complete_history <- vapply(
    split(history, history$iso3),
    function(x) {
      nrow(x) == year - start_year + 1L && all(is.finite(x$exports))
    },
    logical(1)
  )
  snapshot <- snapshot[
    snapshot$iso3 %in% names(complete_history)[complete_history],
  ]
  history <- history[history$iso3 %in% snapshot$iso3, ]
  snapshot$gdp <- snapshot$income * snapshot$population
  snapshot$exports_pc <- snapshot$exports / snapshot$population
  snapshot$imports_pc <- snapshot$imports / snapshot$population
  snapshot$trade_balance <- 100 *
    (snapshot$exports - snapshot$imports) /
    (snapshot$exports + snapshot$imports)
  rownames(snapshot) <- NULL
  message(
    "Selected ",
    year,
    ": ",
    nrow(snapshot),
    " economies; Russia included: ",
    "RUS" %in% snapshot$iso3
  )
  world_population <- panels$population$population[
    panels$population$iso3 == "WLD" & panels$population$year == year
  ]
  metadata <- list(
    schema_version = 3L,
    year = year,
    start_year = start_year,
    economies = nrow(snapshot),
    prepared = as.character(Sys.Date()),
    source = "World Bank WDI, source 2",
    indicators = as.list(indicators),
    source_updated = source_dates,
    coverage = coverage,
    world_population_coverage = sum(snapshot$population) / world_population,
    excluded = setdiff(economies$iso3, snapshot$iso3),
    units = list(
      income = "PPP, constant 2021 international dollars per person",
      exports = "Current US dollars",
      imports = "Current US dollars",
      exports_pc = "Current US dollars per person",
      imports_pc = "Current US dollars per person",
      trade_balance = "100 * (exports - imports) / (exports + imports)",
      urban = "Percent of population"
    )
  )
  dir.create(data_dir, recursive = TRUE, showWarnings = FALSE)
  utils::write.csv(
    snapshot,
    snapshot_file,
    row.names = FALSE,
    na = "",
    fileEncoding = "UTF-8"
  )
  utils::write.csv(history, history_file, row.names = FALSE, na = "")
  jsonlite::write_json(
    metadata,
    metadata_file,
    auto_unbox = TRUE,
    pretty = TRUE
  )
  list(countries = snapshot, history = history, metadata = metadata)
}
