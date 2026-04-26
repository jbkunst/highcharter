# Create vector of color from vector

Create vector of color from vector

## Usage

``` r
colorize(x, colors = c("#440154", "#21908C", "#FDE725"))
```

## Arguments

- x:

  A numeric, character or factor object.

- colors:

  A character string of colors (ordered) to colorize `x`

## Examples

``` r
colorize(runif(10))
#>  [1] "#3C2060" "#FDE725" "#6AAD69" "#34406C" "#440154" "#248085" "#399980"
#>  [8] "#2C6079" "#9BC052" "#CCD33B"

colorize(LETTERS[rbinom(20, 5, 0.5)], c("#FF0000", "#00FFFF"))
#>  [1] "#3FBFBF" "#FF0000" "#FF0000" "#BF3F3F" "#BF3F3F" "#BF3F3F" "#BF3F3F"
#>  [8] "#FF0000" "#BF3F3F" "#00FFFF" "#BF3F3F" "#7F7F7F" "#7F7F7F" "#BF3F3F"
#> [15] "#00FFFF" "#7F7F7F" "#FF0000" "#7F7F7F" "#7F7F7F" "#7F7F7F"
```
