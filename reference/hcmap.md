# Shortcut for create map from <https://code.highcharts.com/mapdata/> collection.

Shortcut for create map from <https://code.highcharts.com/mapdata/>
collection.

## Usage

``` r
hcmap(
  map = "custom/world",
  download_map_data = getOption("highcharter.download_map_data"),
  data = NULL,
  value = NULL,
  joinBy = NULL,
  ...
)
```

## Arguments

- map:

  String indicating what map to chart, a list from
  <https://code.highcharts.com/mapdata/>. See examples.

- download_map_data:

  A logical value whether to download (add as a dependency) the map.
  Default `TRUE` via `getOption("highcharter.download_map_data")`.

- data:

  Optional data to make a choropleth, in case of use the joinBy and
  value are needed.

- value:

  A string value with the name of the variable to chart.

- joinBy:

  What property to join the `map` and `df`.

- ...:

  Additional shared arguments for the data series
  (<https://api.highcharts.com/highcharts/series>).

## Examples

``` r
options(highcharter.download_map_data = TRUE)

# hcmap(nullColor = "#DADADA")
# hcmap(nullColor = "#DADADA", download_map_data = FALSE)

require(dplyr)
data("USArrests", package = "datasets")
USArrests <- mutate(USArrests, "woe-name" = rownames(USArrests))

# hcmap(
#   map = "countries/us/us-all", data = USArrests,
#   joinBy = "woe-name", value = "UrbanPop", name = "Urban Population"
# )

# download_map_data = FALSE
# hcmap(
#    map = "countries/us/us-all", data = USArrests,
#   joinBy = "woe-name", value = "UrbanPop", name = "Urban Population",
#   download_map_data = FALSE
# )
```
