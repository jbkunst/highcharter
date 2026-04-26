# Convert an object to list with identical structure

This functions are similar to
[`rlist::list.parse`](https://rdrr.io/pkg/rlist/man/list.parse.html) but
this removes names. `NA`s are removed for compatibility with
rjson::toJSON.

## Usage

``` r
list_parse(df)

list_parse2(df)
```

## Arguments

- df:

  A data frame to parse to list

## Examples

``` r
x <- data.frame(a = 1:3, type = c("A", "C", "B"), stringsAsFactors = FALSE)
list_parse(x)
#> [[1]]
#> [[1]]$a
#> [1] 1
#> 
#> [[1]]$type
#> [1] "A"
#> 
#> 
#> [[2]]
#> [[2]]$a
#> [1] 2
#> 
#> [[2]]$type
#> [1] "C"
#> 
#> 
#> [[3]]
#> [[3]]$a
#> [1] 3
#> 
#> [[3]]$type
#> [1] "B"
#> 
#> 
list_parse2(x)
#> [[1]]
#> [[1]][[1]]
#> [1] 1
#> 
#> [[1]][[2]]
#> [1] "A"
#> 
#> 
#> [[2]]
#> [[2]][[1]]
#> [1] 2
#> 
#> [[2]][[2]]
#> [1] "C"
#> 
#> 
#> [[3]]
#> [[3]][[1]]
#> [1] 3
#> 
#> [[3]][[2]]
#> [1] "B"
#> 
#> 
```
