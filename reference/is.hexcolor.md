# Check if a string vector is in hexadecimal color format

Check if a string vector is in hexadecimal color format

## Usage

``` r
is.hexcolor(x)
```

## Arguments

- x:

  A string vectors

## Examples

``` r
x <- c("#f0f0f0", "#FFf", "#99990000", "#00FFFFFF")

is.hexcolor(x)
#> [1] TRUE TRUE TRUE TRUE
```
