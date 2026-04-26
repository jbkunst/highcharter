# Modify data frame according to mapping

Modify data frame according to mapping

## Usage

``` r
mutate_mapping(data, mapping, drop = FALSE)
```

## Arguments

- data:

  A data frame object.

- mapping:

  A mapping from `hcaes` function.

- drop:

  A logical argument to you drop variables or not. Default is `FALSE`

## Examples

``` r
df <- head(mtcars)
mutate_mapping(data = df, mapping = hcaes(x = cyl, y = wt + cyl, group = gear))
#>                    mpg cyl disp  hp drat    wt  qsec vs am gear carb x      y
#> Mazda RX4         21.0   6  160 110 3.90 2.620 16.46  0  1    4    4 6  8.620
#> Mazda RX4 Wag     21.0   6  160 110 3.90 2.875 17.02  0  1    4    4 6  8.875
#> Datsun 710        22.8   4  108  93 3.85 2.320 18.61  1  1    4    1 4  6.320
#> Hornet 4 Drive    21.4   6  258 110 3.08 3.215 19.44  1  0    3    1 6  9.215
#> Hornet Sportabout 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2 8 11.440
#> Valiant           18.1   6  225 105 2.76 3.460 20.22  1  0    3    1 6  9.460
#>                   group
#> Mazda RX4             4
#> Mazda RX4 Wag         4
#> Datsun 710            4
#> Hornet 4 Drive        3
#> Hornet Sportabout     3
#> Valiant               3
mutate_mapping(data = df, mapping = hcaes(x = cyl, y = wt), drop = TRUE)
#>                   x     y
#> Mazda RX4         6 2.620
#> Mazda RX4 Wag     6 2.875
#> Datsun 710        4 2.320
#> Hornet 4 Drive    6 3.215
#> Hornet Sportabout 8 3.440
#> Valiant           6 3.460
```
