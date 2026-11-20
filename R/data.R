#' World income and population in 2024 and 2025
#'
#' An offline snapshot of World Development Indicators for 217 economies.
#' Regional and global aggregates are excluded. Missing estimates are NA.
#' @format A data frame with 434 rows and six columns:
#' \describe{
#'   \item{iso3, country, region}{World Bank three-letter economy code, name and region.}
#'   \item{year}{Calendar year.}
#'   \item{gni_per_capita}{Gross national income per capita, Atlas method, in current US dollars.}
#'   \item{population}{Total population in people.}
#' }
#' @source World Bank, [income](https://data.worldbank.org/indicator/NY.GNP.PCAP.CD)
#'   and [population](https://data.worldbank.org/indicator/SP.POP.TOTL), November 2026 snapshot.
"world_income"

#' Daily temperatures in four cities in 2025
#'
#' ERA5 reanalysis at the coordinates of Berlin, Nairobi, Santiago and Tokyo.
#' Daily summaries follow each city's local time.
#' @format A data frame with 1,460 rows. `city` and `date` identify each day.
#'   `temp_min`, `temp_mean` and `temp_max` are daily air temperatures at 2 m in degrees Celsius.
#' @source [Open-Meteo Historical Weather API](https://open-meteo.com/en/docs/historical-weather-api),
#'   based on ERA5, Copernicus Climate Change Service, \doi{10.24381/cds.adbb2d47}.
"city_weather"

#' Pokémon types and base stats
#'
#' A fixed collection of 898 Pokémon (IDs 1 to 898). Height is in decimetres
#' and weight is in hectograms. Includes types, stats, colors and artwork links.
#' @format A data frame with 898 rows and 24 columns.
#' @source [PokéAPI](https://pokeapi.co/) and Bulbapedia.
"pokemon"
