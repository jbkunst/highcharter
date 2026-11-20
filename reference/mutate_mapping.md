# Apply point mappings to a data frame

Apply point mappings to a data frame

## Usage

``` r
mutate_mapping(data, mapping, drop = FALSE)
```

## Arguments

- data:

  A data frame.

- mapping:

  A mapping from
  [`hcaes()`](https://jkunst.com/highcharter/reference/hcaes.md) or
  [`hcaes_string()`](https://jkunst.com/highcharter/reference/hcaes_string.md).

- drop:

  If `TRUE`, keep only the mapped columns, in mapping order.

## Examples

``` r
cars <- head(mtcars, 3)
mapping <- hcaes(wt, mpg, group = factor(cyl), name = rownames(cars))
mutate_mapping(cars, mapping)
#>                mpg cyl disp  hp drat    wt  qsec vs am gear carb     x    y
#> Mazda RX4     21.0   6  160 110 3.90 2.620 16.46  0  1    4    4 2.620 21.0
#> Mazda RX4 Wag 21.0   6  160 110 3.90 2.875 17.02  0  1    4    4 2.875 21.0
#> Datsun 710    22.8   4  108  93 3.85 2.320 18.61  1  1    4    1 2.320 22.8
#>               group          name
#> Mazda RX4         6     Mazda RX4
#> Mazda RX4 Wag     6 Mazda RX4 Wag
#> Datsun 710        4    Datsun 710
mutate_mapping(cars, mapping, drop = TRUE)
#>                   x    y group          name
#> Mazda RX4     2.620 21.0     6     Mazda RX4
#> Mazda RX4 Wag 2.875 21.0     6 Mazda RX4 Wag
#> Datsun 710    2.320 22.8     4    Datsun 710
```
