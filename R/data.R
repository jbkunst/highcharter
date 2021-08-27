#' Visual comparison of Mountains Panorama
#'
#' This data comes from the \url{http://www.highcharts.com/} examples:  
#' https://www.highcharts.com/demo/3d-area-multiple
#'
#' @section Variables:
#'
#' \itemize{
#'
#'  \item \code{place}: The place.
#'  \item \code{name}: Name.
#'  \item \code{heigth}: Heigth.
#'
#' }
#'
#' @docType data
#' @name mountains_panorama
#' @usage mountains_panorama
#' @format A \code{data frame} with 91 observations and 3 variables.
"mountains_panorama"

#' City temperatures from a year in wide format
#'
#' This data comes from the \url{http://www.highcharts.com/} examples.
#'
#' @section Variables:
#'
#' \itemize{
#'
#'  \item \code{month}: The months.
#'  \item \code{tokyo}: Tokyo's temperatures.
#'  \item \code{new_york}: New York's temperatures.
#'  \item \code{berlin}: Berlin's temperatures.
#'  \item \code{london}: London's temperatures.
#'
#' }
#'
#' @docType data
#' @name citytemp
#' @usage citytemp
#' @format A \code{data frame} with 12 observations and 5 variables.
"citytemp"

#' City temperatures from a year in long format
#'
#' This data comes from the \url{http://www.highcharts.com/} examples.
#'
#' @section Variables:
#'
#' \itemize{
#'
#'  \item \code{month}: The months.
#'  \item \code{citiy}: City.
#'  \item \code{temp}: Temperatures.
#' }
#'
#' @docType data
#' @name citytemp_long
#' @usage citytemp_long
#' @format A \code{data frame} with 36 observations and 3 variables.
"citytemp_long"


#' Marshall's Favorite Bars
#'
#' Data from How I met Your Mother: Marshall's Favorite Bars.
#'
#' @section Variables:
#'
#' \itemize{
#'
#'  \item \code{bar}: Bar's name.
#'  \item \code{percent}: In percentage of awesomeness
#'
#' }
#'
#' @docType data
#' @name favorite_bars
#' @usage favorite_bars
#' @format A \code{data frame} with 5 observations and 2 variables.
"favorite_bars"

#' Marshall's Favorite Pies
#'
#' Data from How I met Your Mother: Marshall's Favorite Pies
#'
#' @section Variables:
#'
#' \itemize{
#'
#'  \item \code{pie}: Bar's name.
#'  \item \code{percent}: In percentage of tastiness
#'
#' }
#'
#' @docType data
#' @name favorite_pies
#' @usage favorite_pies
#' @format A \code{data frame} with 5 observations and 2 variables.
"favorite_pies"

#' globaltemp
#'
#' Temperature information by years.
#'
#' @section Variables:
#'
#' \itemize{
#'
#'  \item \code{date}: Date.
#'  \item \code{lower}: Minimum temperature.
#'  \item \code{median}: Median temperature.
#'  \item \code{upper}: Maximum temperature.
#' }
#'
#' @docType data
#' @name globaltemp
#' @usage globaltemp
#' @source \url{http://www.climate-lab-book.ac.uk/2016/spiralling-global-temperatures/}
#' @format A \code{data frame} with 1992 observations and 4 variables.
"globaltemp"

#' pokemon
#'
#' Information about 898 pokemon.
#'
#' @docType data
#' @name pokemon
#' @usage pokemon
#' @format A \code{data frame} with 898 observations and 24 variables.
"pokemon"

#' stars
#'
#' A sample using by Nadieh Bremer blocks. \url{http://bl.ocks.org/nbremer/eb0d1fd4118b731d069e2ff98dfadc47}.
#'
#' @section Variables:
#'
#' \itemize{
#'
#'  \item \code{bv}: BV
#'  \item \code{absmag}: Magnitude
#'  \item \code{lum}: Luminosity
#'  \item \code{temp}: Temperature
#'  \item \code{radiussun}: Radius
#'  \item \code{distance}: Distance
#' }
#'
#' @docType data
#' @name stars
#' @usage stars
#' @format A \code{data frame} with 404 observations and 6 variables.
"stars"

#' US Counties unemployment rate
#'
#' This data comes from the highcharts and is used in highmaps examples.
#'
#' @section Variables:
#'
#' \itemize{
#'
#'  \item \code{code}: The county code.
#'  \item `name`: The county name.
#'  \item \code{value}: The unemployment.
#'
#' }
#'
#' @docType data
#' @name unemployment
#' @usage unemployment
#' @format A `data.frame` with 3 variables and 3.216 observations.
"unemployment"

#' US Counties map in Geojson format (list)
#'
#' This data comes from the \url{https://code.highcharts.com/mapdata/countries/us/us-all-all.js}
#' and is used in highmaps examples.
#'
#' @docType data
#' @name uscountygeojson
#' @usage uscountygeojson
#' @format A `list` in geojson format.
"uscountygeojson"

#' US States map in Geojson format (list)
#'
#' This data comes from the \url{https://code.highcharts.com/mapdata/countries/us/us-all.js}
#' and is used in highmaps examples.
#'
#' @docType data
#' @name usgeojson
#' @usage usgeojson
#' @format A `list` in geojson format.
"usgeojson"

#' Vaccines
#'
#' The number of infected people by Measles, measured over 70-some years and across
#' all 50 states. From the WSJ analysis: \url{http://graphics.wsj.com/infectious-diseases-and-vaccines/}
#'
#' @section Variables:
#'
#' \itemize{
#'
#'  \item \code{year}: Year
#'  \item \code{state}: Name of the state
#'  \item \code{count}: Number of cases per 100,000 people. If the value is NA the count was 0.
#'
#' }
#'
#' @docType data
#' @name vaccines
#' @usage vaccines
#' @format A \code{data frame} with 3,876 observations and 3 variables.
"vaccines"

#' Weather
#'
#' Temperature information of San Francisco.
#'
#' @section Variables:
#'
#' \itemize{
#'
#'  \item \code{date}: Day in date format.
#'  \item \code{min_temperaturec}: Minimum temperature.
#'  \item \code{max_temperaturec}: Maximun temperature.
#'  \item \code{mean_temperaturec}: Mean temperature.
#' }
#'
#' @docType data
#' @name weather
#' @usage weather
#' @format A \code{data frame} with 365 observations and 4 variables.
"weather"

#' World map in Geojson format (list)
#'
#' This data comes from the \url{https://code.highcharts.com/mapdata/custom/world.js}
#' and is used in highmaps examples.#'
#'
#' @docType data
#' @name worldgeojson
#' @usage worldgeojson
#' @format A `list` in geojson format.
"worldgeojson"
