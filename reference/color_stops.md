# Function to create `stops` argument in `hc_colorAxis`

Function to create `stops` argument in `hc_colorAxis`

## Usage

``` r
color_stops(n = 10, colors = c("#440154", "#21908C", "#FDE725"))
```

## Arguments

- n:

  A numeric indicating how much quantiles generate.

- colors:

  A character string of colors (ordered)

## Examples

``` r
color_stops(5)
#> [[1]]
#> [[1]][[1]]
#> [1] 0
#> 
#> [[1]][[2]]
#> [1] "#440154"
#> 
#> 
#> [[2]]
#> [[2]][[1]]
#> [1] 0.25
#> 
#> [[2]][[2]]
#> [1] "#324870"
#> 
#> 
#> [[3]]
#> [[3]][[1]]
#> [1] 0.5
#> 
#> [[3]][[2]]
#> [1] "#21908C"
#> 
#> 
#> [[4]]
#> [[4]][[1]]
#> [1] 0.75
#> 
#> [[4]][[2]]
#> [1] "#8FBB58"
#> 
#> 
#> [[5]]
#> [[5]][[1]]
#> [1] 1
#> 
#> [[5]][[2]]
#> [1] "#FDE725"
#> 
#> 
```
