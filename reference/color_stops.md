# Create color stops for `hc_colorAxis`

Create color stops for `hc_colorAxis`

## Usage

``` r
color_stops(
  n = 10,
  colors = c("#440154", "#21908C", "#FDE725"),
  positions = NULL
)
```

## Arguments

- n:

  Number of stops. Defaults to 10 for an evenly spaced gradient, or to
  the length of `positions` when supplied.

- colors:

  Character vector of colors in gradient order.

- positions:

  Optional numeric vector of positions from 0 to 1 in nondecreasing
  order, one per color. Each color is used as supplied. By default,
  colors are interpolated at evenly spaced positions, with a single stop
  placed at zero.

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
color_stops(colors = c("navy", "gold", "red"), positions = c(0, 0.3, 1))
#> [[1]]
#> [[1]][[1]]
#> [1] 0
#> 
#> [[1]][[2]]
#> [1] "navy"
#> 
#> 
#> [[2]]
#> [[2]][[1]]
#> [1] 0.3
#> 
#> [[2]][[2]]
#> [1] "gold"
#> 
#> 
#> [[3]]
#> [[3]][[1]]
#> [1] 1
#> 
#> [[3]][[2]]
#> [1] "red"
#> 
#> 
```
