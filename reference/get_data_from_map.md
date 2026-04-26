# Helper function to get the data inside the map data The urls are listed in <https://code.highcharts.com/mapdata/>.

Helper function to get the data inside the map data The urls are listed
in <https://code.highcharts.com/mapdata/>.

## Usage

``` r
get_data_from_map(mapdata)
```

## Arguments

- mapdata:

  A list obtained from
  [`download_map_data`](https://jkunst.com/highcharter/reference/download_map_data.md).

## See also

[`download_map_data`](https://jkunst.com/highcharter/reference/download_map_data.md)

## Examples

``` r
if (FALSE) { # \dontrun{
dta <- download_map_data("https://code.highcharts.com/mapdata/countries/us/us-ca-all.js")
get_data_from_map(dta)
} # }
```
