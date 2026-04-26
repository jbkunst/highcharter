# Transform colors from hexadecimal format to rgba hc notation

Transform colors from hexadecimal format to rgba hc notation

## Usage

``` r
hex_to_rgba(x, alpha = 1)
```

## Arguments

- x:

  colors in hexadecimal format

- alpha:

  alpha

## Examples

``` r
hex_to_rgba(x <- c("#440154", "#21908C", "#FDE725", "red"))
#> [1] "rgba(68,1,84,1)"    "rgba(33,144,140,1)" "rgba(253,231,37,1)"
#> [4] "rgba(255,0,0,1)"   
```
