# Helper function to get the data inside the map data

Helper function to get the data inside the map data

## Usage

``` r
get_data_from_map(mapdata)
```

## Arguments

- mapdata:

  A GeoJSON FeatureCollection or a TopoJSON Topology read as an R list.
  For TopoJSON, the first object's geometry collection supplies the
  properties, matching the layer drawn by
  [`hcmap()`](https://jkunst.com/highcharter/reference/hcmap.md).

## Value

A tibble of feature properties, including any keys used by `joinBy`.

## See also

[`hcmap()`](https://jkunst.com/highcharter/reference/hcmap.md),
[`download_map_data()`](https://jkunst.com/highcharter/reference/download_map_data.md)

## Examples

``` r
path <- system.file("maps/custom/world-robinson-lowres.rds", package = "highcharter")
head(get_data_from_map(readRDS(path)))
#> # A tibble: 6 × 14
#>   `hc-group` `hc-middle-x` `hc-middle-y` `hc-key` `hc-a2` name         labelrank
#>   <chr>              <dbl>         <dbl> <chr>    <chr>   <chr>        <chr>    
#> 1 admin0              0.48          0.51 fo       FO      Faroe Islan… 6        
#> 2 admin0              0.61          0.67 us       US      United Stat… 2        
#> 3 admin0              0.28          0.05 fr       FR      France       2        
#> 4 admin0              0.45          0.5  cn       CN      China        2        
#> 5 admin0              0.45          0.49 pt       PT      Portugal     2        
#> 6 admin0              0.83          0.54 sw       SW      Serranilla … 5        
#> # ℹ 7 more variables: `country-abbrev` <chr>, subregion <chr>,
#> #   `region-wb` <chr>, `iso-a3` <chr>, `iso-a2` <chr>, `woe-id` <chr>,
#> #   continent <chr>
```
