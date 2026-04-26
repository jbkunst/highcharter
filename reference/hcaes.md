# Define aesthetic mappings. Similar in spirit to `ggplot2::aes`

Define aesthetic mappings. Similar in spirit to
[`ggplot2::aes`](https://ggplot2.tidyverse.org/reference/aes.html)

## Usage

``` r
hcaes(x, y, ...)
```

## Arguments

- x, y, ...:

  List of name value pairs giving aesthetics to map to variables. The
  names for x and y aesthetics are typically omitted because they are so
  common; all other aesthetics must be named.

## Examples

``` r
hcaes(x = xval, color = colorvar, group = grvar)
#> $x
#> xval
#> 
#> $color
#> colorvar
#> 
#> $group
#> grvar
#> 
#> attr(,"class")
#> [1] "hcaes"  "uneval"
```
