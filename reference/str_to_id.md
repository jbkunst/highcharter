# String to 'id' format

Turn a string to `id` format used in treemaps.

## Usage

``` r
str_to_id(x)

str_to_id_vec(x)
```

## Arguments

- x:

  A vector string.

## Examples

``` r
str_to_id(" A string _ with sd / sdg    Underscores \   ")
#> [1] "a_string_with_sd_sdg_underscores"
```
