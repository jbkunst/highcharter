# List installed maps

List installed maps

## Usage

``` r
hc_maps()
```

## Value

A character vector of map identifiers accepted by
[`hcmap()`](https://jkunst.com/highcharter/reference/hcmap.md). Country
maps use two-letter codes. World and regional maps use collection paths.

## Examples

``` r
head(hc_maps())
#> [1] "ad" "ae" "af" "ag" "al" "am"
grep("^custom/", hc_maps(), value = TRUE)
#> [1] "custom/europe"                "custom/south-america"        
#> [3] "custom/world-robinson-lowres" "custom/world"                
#> [5] "custom/world.topo.json"      
```
