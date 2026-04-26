# Function to create `dataClasses` argument in `hc_colorAxis`

Function to create `dataClasses` argument in `hc_colorAxis`

## Usage

``` r
color_classes(breaks = NULL, colors = c("#440154", "#21908C", "#FDE725"))
```

## Arguments

- breaks:

  A numeric vector

- colors:

  A character string of colors (ordered)

## Examples

``` r
color_classes(c(0, 10, 20, 50))
#> [[1]]
#> [[1]]$from
#> [1] 0
#> 
#> [[1]]$to
#> [1] 10
#> 
#> [[1]]$color
#> [1] "#440154"
#> 
#> 
#> [[2]]
#> [[2]]$from
#> [1] 10
#> 
#> [[2]]$to
#> [1] 20
#> 
#> [[2]]$color
#> [1] "#21908C"
#> 
#> 
#> [[3]]
#> [[3]]$from
#> [1] 20
#> 
#> [[3]]$to
#> [1] 50
#> 
#> [[3]]$color
#> [1] "#FDE725"
#> 
#> 
```
