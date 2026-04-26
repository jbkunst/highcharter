# Auxiliar function to get series and options from tidy frame for hchart.data.frame

This function is used in `hchart.data.frame`.

## Usage

``` r
get_hc_series_from_df(data, type = NULL, ...)
```

## Arguments

- data:

  A `data.frame` object.

- type:

  The type of chart. Possible values are line, scatter, point, column.

- ...:

  Aesthetic mappings as `x y group color low high`.

## Examples

``` r
highcharter:::get_hc_series_from_df(iris, type = "point", x = Sepal.Width)
#> [[1]]
#> [[1]]$type
#> [1] "scatter"
#> 
#> [[1]]$data
#> [[1]]$data[[1]]
#> [[1]]$data[[1]]$Sepal.Length
#> [1] 5.1
#> 
#> [[1]]$data[[1]]$Sepal.Width
#> [1] 3.5
#> 
#> [[1]]$data[[1]]$Petal.Length
#> [1] 1.4
#> 
#> [[1]]$data[[1]]$Petal.Width
#> [1] 0.2
#> 
#> [[1]]$data[[1]]$Species
#> [1] "setosa"
#> 
#> [[1]]$data[[1]]$x
#> [1] 3.5
#> 
#> 
#> [[1]]$data[[2]]
#> [[1]]$data[[2]]$Sepal.Length
#> [1] 4.9
#> 
#> [[1]]$data[[2]]$Sepal.Width
#> [1] 3
#> 
#> [[1]]$data[[2]]$Petal.Length
#> [1] 1.4
#> 
#> [[1]]$data[[2]]$Petal.Width
#> [1] 0.2
#> 
#> [[1]]$data[[2]]$Species
#> [1] "setosa"
#> 
#> [[1]]$data[[2]]$x
#> [1] 3
#> 
#> 
#> [[1]]$data[[3]]
#> [[1]]$data[[3]]$Sepal.Length
#> [1] 4.7
#> 
#> [[1]]$data[[3]]$Sepal.Width
#> [1] 3.2
#> 
#> [[1]]$data[[3]]$Petal.Length
#> [1] 1.3
#> 
#> [[1]]$data[[3]]$Petal.Width
#> [1] 0.2
#> 
#> [[1]]$data[[3]]$Species
#> [1] "setosa"
#> 
#> [[1]]$data[[3]]$x
#> [1] 3.2
#> 
#> 
#> [[1]]$data[[4]]
#> [[1]]$data[[4]]$Sepal.Length
#> [1] 4.6
#> 
#> [[1]]$data[[4]]$Sepal.Width
#> [1] 3.1
#> 
#> [[1]]$data[[4]]$Petal.Length
#> [1] 1.5
#> 
#> [[1]]$data[[4]]$Petal.Width
#> [1] 0.2
#> 
#> [[1]]$data[[4]]$Species
#> [1] "setosa"
#> 
#> [[1]]$data[[4]]$x
#> [1] 3.1
#> 
#> 
#> [[1]]$data[[5]]
#> [[1]]$data[[5]]$Sepal.Length
#> [1] 5
#> 
#> [[1]]$data[[5]]$Sepal.Width
#> [1] 3.6
#> 
#> [[1]]$data[[5]]$Petal.Length
#> [1] 1.4
#> 
#> [[1]]$data[[5]]$Petal.Width
#> [1] 0.2
#> 
#> [[1]]$data[[5]]$Species
#> [1] "setosa"
#> 
#> [[1]]$data[[5]]$x
#> [1] 3.6
#> 
#> 
#> [[1]]$data[[6]]
#> [[1]]$data[[6]]$Sepal.Length
#> [1] 5.4
#> 
#> [[1]]$data[[6]]$Sepal.Width
#> [1] 3.9
#> 
#> [[1]]$data[[6]]$Petal.Length
#> [1] 1.7
#> 
#> [[1]]$data[[6]]$Petal.Width
#> [1] 0.4
#> 
#> [[1]]$data[[6]]$Species
#> [1] "setosa"
#> 
#> [[1]]$data[[6]]$x
#> [1] 3.9
#> 
#> 
#> [[1]]$data[[7]]
#> [[1]]$data[[7]]$Sepal.Length
#> [1] 4.6
#> 
#> [[1]]$data[[7]]$Sepal.Width
#> [1] 3.4
#> 
#> [[1]]$data[[7]]$Petal.Length
#> [1] 1.4
#> 
#> [[1]]$data[[7]]$Petal.Width
#> [1] 0.3
#> 
#> [[1]]$data[[7]]$Species
#> [1] "setosa"
#> 
#> [[1]]$data[[7]]$x
#> [1] 3.4
#> 
#> 
#> [[1]]$data[[8]]
#> [[1]]$data[[8]]$Sepal.Length
#> [1] 5
#> 
#> [[1]]$data[[8]]$Sepal.Width
#> [1] 3.4
#> 
#> [[1]]$data[[8]]$Petal.Length
#> [1] 1.5
#> 
#> [[1]]$data[[8]]$Petal.Width
#> [1] 0.2
#> 
#> [[1]]$data[[8]]$Species
#> [1] "setosa"
#> 
#> [[1]]$data[[8]]$x
#> [1] 3.4
#> 
#> 
#> [[1]]$data[[9]]
#> [[1]]$data[[9]]$Sepal.Length
#> [1] 4.4
#> 
#> [[1]]$data[[9]]$Sepal.Width
#> [1] 2.9
#> 
#> [[1]]$data[[9]]$Petal.Length
#> [1] 1.4
#> 
#> [[1]]$data[[9]]$Petal.Width
#> [1] 0.2
#> 
#> [[1]]$data[[9]]$Species
#> [1] "setosa"
#> 
#> [[1]]$data[[9]]$x
#> [1] 2.9
#> 
#> 
#> [[1]]$data[[10]]
#> [[1]]$data[[10]]$Sepal.Length
#> [1] 4.9
#> 
#> [[1]]$data[[10]]$Sepal.Width
#> [1] 3.1
#> 
#> [[1]]$data[[10]]$Petal.Length
#> [1] 1.5
#> 
#> [[1]]$data[[10]]$Petal.Width
#> [1] 0.1
#> 
#> [[1]]$data[[10]]$Species
#> [1] "setosa"
#> 
#> [[1]]$data[[10]]$x
#> [1] 3.1
#> 
#> 
#> [[1]]$data[[11]]
#> [[1]]$data[[11]]$Sepal.Length
#> [1] 5.4
#> 
#> [[1]]$data[[11]]$Sepal.Width
#> [1] 3.7
#> 
#> [[1]]$data[[11]]$Petal.Length
#> [1] 1.5
#> 
#> [[1]]$data[[11]]$Petal.Width
#> [1] 0.2
#> 
#> [[1]]$data[[11]]$Species
#> [1] "setosa"
#> 
#> [[1]]$data[[11]]$x
#> [1] 3.7
#> 
#> 
#> [[1]]$data[[12]]
#> [[1]]$data[[12]]$Sepal.Length
#> [1] 4.8
#> 
#> [[1]]$data[[12]]$Sepal.Width
#> [1] 3.4
#> 
#> [[1]]$data[[12]]$Petal.Length
#> [1] 1.6
#> 
#> [[1]]$data[[12]]$Petal.Width
#> [1] 0.2
#> 
#> [[1]]$data[[12]]$Species
#> [1] "setosa"
#> 
#> [[1]]$data[[12]]$x
#> [1] 3.4
#> 
#> 
#> [[1]]$data[[13]]
#> [[1]]$data[[13]]$Sepal.Length
#> [1] 4.8
#> 
#> [[1]]$data[[13]]$Sepal.Width
#> [1] 3
#> 
#> [[1]]$data[[13]]$Petal.Length
#> [1] 1.4
#> 
#> [[1]]$data[[13]]$Petal.Width
#> [1] 0.1
#> 
#> [[1]]$data[[13]]$Species
#> [1] "setosa"
#> 
#> [[1]]$data[[13]]$x
#> [1] 3
#> 
#> 
#> [[1]]$data[[14]]
#> [[1]]$data[[14]]$Sepal.Length
#> [1] 4.3
#> 
#> [[1]]$data[[14]]$Sepal.Width
#> [1] 3
#> 
#> [[1]]$data[[14]]$Petal.Length
#> [1] 1.1
#> 
#> [[1]]$data[[14]]$Petal.Width
#> [1] 0.1
#> 
#> [[1]]$data[[14]]$Species
#> [1] "setosa"
#> 
#> [[1]]$data[[14]]$x
#> [1] 3
#> 
#> 
#> [[1]]$data[[15]]
#> [[1]]$data[[15]]$Sepal.Length
#> [1] 5.8
#> 
#> [[1]]$data[[15]]$Sepal.Width
#> [1] 4
#> 
#> [[1]]$data[[15]]$Petal.Length
#> [1] 1.2
#> 
#> [[1]]$data[[15]]$Petal.Width
#> [1] 0.2
#> 
#> [[1]]$data[[15]]$Species
#> [1] "setosa"
#> 
#> [[1]]$data[[15]]$x
#> [1] 4
#> 
#> 
#> [[1]]$data[[16]]
#> [[1]]$data[[16]]$Sepal.Length
#> [1] 5.7
#> 
#> [[1]]$data[[16]]$Sepal.Width
#> [1] 4.4
#> 
#> [[1]]$data[[16]]$Petal.Length
#> [1] 1.5
#> 
#> [[1]]$data[[16]]$Petal.Width
#> [1] 0.4
#> 
#> [[1]]$data[[16]]$Species
#> [1] "setosa"
#> 
#> [[1]]$data[[16]]$x
#> [1] 4.4
#> 
#> 
#> [[1]]$data[[17]]
#> [[1]]$data[[17]]$Sepal.Length
#> [1] 5.4
#> 
#> [[1]]$data[[17]]$Sepal.Width
#> [1] 3.9
#> 
#> [[1]]$data[[17]]$Petal.Length
#> [1] 1.3
#> 
#> [[1]]$data[[17]]$Petal.Width
#> [1] 0.4
#> 
#> [[1]]$data[[17]]$Species
#> [1] "setosa"
#> 
#> [[1]]$data[[17]]$x
#> [1] 3.9
#> 
#> 
#> [[1]]$data[[18]]
#> [[1]]$data[[18]]$Sepal.Length
#> [1] 5.1
#> 
#> [[1]]$data[[18]]$Sepal.Width
#> [1] 3.5
#> 
#> [[1]]$data[[18]]$Petal.Length
#> [1] 1.4
#> 
#> [[1]]$data[[18]]$Petal.Width
#> [1] 0.3
#> 
#> [[1]]$data[[18]]$Species
#> [1] "setosa"
#> 
#> [[1]]$data[[18]]$x
#> [1] 3.5
#> 
#> 
#> [[1]]$data[[19]]
#> [[1]]$data[[19]]$Sepal.Length
#> [1] 5.7
#> 
#> [[1]]$data[[19]]$Sepal.Width
#> [1] 3.8
#> 
#> [[1]]$data[[19]]$Petal.Length
#> [1] 1.7
#> 
#> [[1]]$data[[19]]$Petal.Width
#> [1] 0.3
#> 
#> [[1]]$data[[19]]$Species
#> [1] "setosa"
#> 
#> [[1]]$data[[19]]$x
#> [1] 3.8
#> 
#> 
#> [[1]]$data[[20]]
#> [[1]]$data[[20]]$Sepal.Length
#> [1] 5.1
#> 
#> [[1]]$data[[20]]$Sepal.Width
#> [1] 3.8
#> 
#> [[1]]$data[[20]]$Petal.Length
#> [1] 1.5
#> 
#> [[1]]$data[[20]]$Petal.Width
#> [1] 0.3
#> 
#> [[1]]$data[[20]]$Species
#> [1] "setosa"
#> 
#> [[1]]$data[[20]]$x
#> [1] 3.8
#> 
#> 
#> [[1]]$data[[21]]
#> [[1]]$data[[21]]$Sepal.Length
#> [1] 5.4
#> 
#> [[1]]$data[[21]]$Sepal.Width
#> [1] 3.4
#> 
#> [[1]]$data[[21]]$Petal.Length
#> [1] 1.7
#> 
#> [[1]]$data[[21]]$Petal.Width
#> [1] 0.2
#> 
#> [[1]]$data[[21]]$Species
#> [1] "setosa"
#> 
#> [[1]]$data[[21]]$x
#> [1] 3.4
#> 
#> 
#> [[1]]$data[[22]]
#> [[1]]$data[[22]]$Sepal.Length
#> [1] 5.1
#> 
#> [[1]]$data[[22]]$Sepal.Width
#> [1] 3.7
#> 
#> [[1]]$data[[22]]$Petal.Length
#> [1] 1.5
#> 
#> [[1]]$data[[22]]$Petal.Width
#> [1] 0.4
#> 
#> [[1]]$data[[22]]$Species
#> [1] "setosa"
#> 
#> [[1]]$data[[22]]$x
#> [1] 3.7
#> 
#> 
#> [[1]]$data[[23]]
#> [[1]]$data[[23]]$Sepal.Length
#> [1] 4.6
#> 
#> [[1]]$data[[23]]$Sepal.Width
#> [1] 3.6
#> 
#> [[1]]$data[[23]]$Petal.Length
#> [1] 1
#> 
#> [[1]]$data[[23]]$Petal.Width
#> [1] 0.2
#> 
#> [[1]]$data[[23]]$Species
#> [1] "setosa"
#> 
#> [[1]]$data[[23]]$x
#> [1] 3.6
#> 
#> 
#> [[1]]$data[[24]]
#> [[1]]$data[[24]]$Sepal.Length
#> [1] 5.1
#> 
#> [[1]]$data[[24]]$Sepal.Width
#> [1] 3.3
#> 
#> [[1]]$data[[24]]$Petal.Length
#> [1] 1.7
#> 
#> [[1]]$data[[24]]$Petal.Width
#> [1] 0.5
#> 
#> [[1]]$data[[24]]$Species
#> [1] "setosa"
#> 
#> [[1]]$data[[24]]$x
#> [1] 3.3
#> 
#> 
#> [[1]]$data[[25]]
#> [[1]]$data[[25]]$Sepal.Length
#> [1] 4.8
#> 
#> [[1]]$data[[25]]$Sepal.Width
#> [1] 3.4
#> 
#> [[1]]$data[[25]]$Petal.Length
#> [1] 1.9
#> 
#> [[1]]$data[[25]]$Petal.Width
#> [1] 0.2
#> 
#> [[1]]$data[[25]]$Species
#> [1] "setosa"
#> 
#> [[1]]$data[[25]]$x
#> [1] 3.4
#> 
#> 
#> [[1]]$data[[26]]
#> [[1]]$data[[26]]$Sepal.Length
#> [1] 5
#> 
#> [[1]]$data[[26]]$Sepal.Width
#> [1] 3
#> 
#> [[1]]$data[[26]]$Petal.Length
#> [1] 1.6
#> 
#> [[1]]$data[[26]]$Petal.Width
#> [1] 0.2
#> 
#> [[1]]$data[[26]]$Species
#> [1] "setosa"
#> 
#> [[1]]$data[[26]]$x
#> [1] 3
#> 
#> 
#> [[1]]$data[[27]]
#> [[1]]$data[[27]]$Sepal.Length
#> [1] 5
#> 
#> [[1]]$data[[27]]$Sepal.Width
#> [1] 3.4
#> 
#> [[1]]$data[[27]]$Petal.Length
#> [1] 1.6
#> 
#> [[1]]$data[[27]]$Petal.Width
#> [1] 0.4
#> 
#> [[1]]$data[[27]]$Species
#> [1] "setosa"
#> 
#> [[1]]$data[[27]]$x
#> [1] 3.4
#> 
#> 
#> [[1]]$data[[28]]
#> [[1]]$data[[28]]$Sepal.Length
#> [1] 5.2
#> 
#> [[1]]$data[[28]]$Sepal.Width
#> [1] 3.5
#> 
#> [[1]]$data[[28]]$Petal.Length
#> [1] 1.5
#> 
#> [[1]]$data[[28]]$Petal.Width
#> [1] 0.2
#> 
#> [[1]]$data[[28]]$Species
#> [1] "setosa"
#> 
#> [[1]]$data[[28]]$x
#> [1] 3.5
#> 
#> 
#> [[1]]$data[[29]]
#> [[1]]$data[[29]]$Sepal.Length
#> [1] 5.2
#> 
#> [[1]]$data[[29]]$Sepal.Width
#> [1] 3.4
#> 
#> [[1]]$data[[29]]$Petal.Length
#> [1] 1.4
#> 
#> [[1]]$data[[29]]$Petal.Width
#> [1] 0.2
#> 
#> [[1]]$data[[29]]$Species
#> [1] "setosa"
#> 
#> [[1]]$data[[29]]$x
#> [1] 3.4
#> 
#> 
#> [[1]]$data[[30]]
#> [[1]]$data[[30]]$Sepal.Length
#> [1] 4.7
#> 
#> [[1]]$data[[30]]$Sepal.Width
#> [1] 3.2
#> 
#> [[1]]$data[[30]]$Petal.Length
#> [1] 1.6
#> 
#> [[1]]$data[[30]]$Petal.Width
#> [1] 0.2
#> 
#> [[1]]$data[[30]]$Species
#> [1] "setosa"
#> 
#> [[1]]$data[[30]]$x
#> [1] 3.2
#> 
#> 
#> [[1]]$data[[31]]
#> [[1]]$data[[31]]$Sepal.Length
#> [1] 4.8
#> 
#> [[1]]$data[[31]]$Sepal.Width
#> [1] 3.1
#> 
#> [[1]]$data[[31]]$Petal.Length
#> [1] 1.6
#> 
#> [[1]]$data[[31]]$Petal.Width
#> [1] 0.2
#> 
#> [[1]]$data[[31]]$Species
#> [1] "setosa"
#> 
#> [[1]]$data[[31]]$x
#> [1] 3.1
#> 
#> 
#> [[1]]$data[[32]]
#> [[1]]$data[[32]]$Sepal.Length
#> [1] 5.4
#> 
#> [[1]]$data[[32]]$Sepal.Width
#> [1] 3.4
#> 
#> [[1]]$data[[32]]$Petal.Length
#> [1] 1.5
#> 
#> [[1]]$data[[32]]$Petal.Width
#> [1] 0.4
#> 
#> [[1]]$data[[32]]$Species
#> [1] "setosa"
#> 
#> [[1]]$data[[32]]$x
#> [1] 3.4
#> 
#> 
#> [[1]]$data[[33]]
#> [[1]]$data[[33]]$Sepal.Length
#> [1] 5.2
#> 
#> [[1]]$data[[33]]$Sepal.Width
#> [1] 4.1
#> 
#> [[1]]$data[[33]]$Petal.Length
#> [1] 1.5
#> 
#> [[1]]$data[[33]]$Petal.Width
#> [1] 0.1
#> 
#> [[1]]$data[[33]]$Species
#> [1] "setosa"
#> 
#> [[1]]$data[[33]]$x
#> [1] 4.1
#> 
#> 
#> [[1]]$data[[34]]
#> [[1]]$data[[34]]$Sepal.Length
#> [1] 5.5
#> 
#> [[1]]$data[[34]]$Sepal.Width
#> [1] 4.2
#> 
#> [[1]]$data[[34]]$Petal.Length
#> [1] 1.4
#> 
#> [[1]]$data[[34]]$Petal.Width
#> [1] 0.2
#> 
#> [[1]]$data[[34]]$Species
#> [1] "setosa"
#> 
#> [[1]]$data[[34]]$x
#> [1] 4.2
#> 
#> 
#> [[1]]$data[[35]]
#> [[1]]$data[[35]]$Sepal.Length
#> [1] 4.9
#> 
#> [[1]]$data[[35]]$Sepal.Width
#> [1] 3.1
#> 
#> [[1]]$data[[35]]$Petal.Length
#> [1] 1.5
#> 
#> [[1]]$data[[35]]$Petal.Width
#> [1] 0.2
#> 
#> [[1]]$data[[35]]$Species
#> [1] "setosa"
#> 
#> [[1]]$data[[35]]$x
#> [1] 3.1
#> 
#> 
#> [[1]]$data[[36]]
#> [[1]]$data[[36]]$Sepal.Length
#> [1] 5
#> 
#> [[1]]$data[[36]]$Sepal.Width
#> [1] 3.2
#> 
#> [[1]]$data[[36]]$Petal.Length
#> [1] 1.2
#> 
#> [[1]]$data[[36]]$Petal.Width
#> [1] 0.2
#> 
#> [[1]]$data[[36]]$Species
#> [1] "setosa"
#> 
#> [[1]]$data[[36]]$x
#> [1] 3.2
#> 
#> 
#> [[1]]$data[[37]]
#> [[1]]$data[[37]]$Sepal.Length
#> [1] 5.5
#> 
#> [[1]]$data[[37]]$Sepal.Width
#> [1] 3.5
#> 
#> [[1]]$data[[37]]$Petal.Length
#> [1] 1.3
#> 
#> [[1]]$data[[37]]$Petal.Width
#> [1] 0.2
#> 
#> [[1]]$data[[37]]$Species
#> [1] "setosa"
#> 
#> [[1]]$data[[37]]$x
#> [1] 3.5
#> 
#> 
#> [[1]]$data[[38]]
#> [[1]]$data[[38]]$Sepal.Length
#> [1] 4.9
#> 
#> [[1]]$data[[38]]$Sepal.Width
#> [1] 3.6
#> 
#> [[1]]$data[[38]]$Petal.Length
#> [1] 1.4
#> 
#> [[1]]$data[[38]]$Petal.Width
#> [1] 0.1
#> 
#> [[1]]$data[[38]]$Species
#> [1] "setosa"
#> 
#> [[1]]$data[[38]]$x
#> [1] 3.6
#> 
#> 
#> [[1]]$data[[39]]
#> [[1]]$data[[39]]$Sepal.Length
#> [1] 4.4
#> 
#> [[1]]$data[[39]]$Sepal.Width
#> [1] 3
#> 
#> [[1]]$data[[39]]$Petal.Length
#> [1] 1.3
#> 
#> [[1]]$data[[39]]$Petal.Width
#> [1] 0.2
#> 
#> [[1]]$data[[39]]$Species
#> [1] "setosa"
#> 
#> [[1]]$data[[39]]$x
#> [1] 3
#> 
#> 
#> [[1]]$data[[40]]
#> [[1]]$data[[40]]$Sepal.Length
#> [1] 5.1
#> 
#> [[1]]$data[[40]]$Sepal.Width
#> [1] 3.4
#> 
#> [[1]]$data[[40]]$Petal.Length
#> [1] 1.5
#> 
#> [[1]]$data[[40]]$Petal.Width
#> [1] 0.2
#> 
#> [[1]]$data[[40]]$Species
#> [1] "setosa"
#> 
#> [[1]]$data[[40]]$x
#> [1] 3.4
#> 
#> 
#> [[1]]$data[[41]]
#> [[1]]$data[[41]]$Sepal.Length
#> [1] 5
#> 
#> [[1]]$data[[41]]$Sepal.Width
#> [1] 3.5
#> 
#> [[1]]$data[[41]]$Petal.Length
#> [1] 1.3
#> 
#> [[1]]$data[[41]]$Petal.Width
#> [1] 0.3
#> 
#> [[1]]$data[[41]]$Species
#> [1] "setosa"
#> 
#> [[1]]$data[[41]]$x
#> [1] 3.5
#> 
#> 
#> [[1]]$data[[42]]
#> [[1]]$data[[42]]$Sepal.Length
#> [1] 4.5
#> 
#> [[1]]$data[[42]]$Sepal.Width
#> [1] 2.3
#> 
#> [[1]]$data[[42]]$Petal.Length
#> [1] 1.3
#> 
#> [[1]]$data[[42]]$Petal.Width
#> [1] 0.3
#> 
#> [[1]]$data[[42]]$Species
#> [1] "setosa"
#> 
#> [[1]]$data[[42]]$x
#> [1] 2.3
#> 
#> 
#> [[1]]$data[[43]]
#> [[1]]$data[[43]]$Sepal.Length
#> [1] 4.4
#> 
#> [[1]]$data[[43]]$Sepal.Width
#> [1] 3.2
#> 
#> [[1]]$data[[43]]$Petal.Length
#> [1] 1.3
#> 
#> [[1]]$data[[43]]$Petal.Width
#> [1] 0.2
#> 
#> [[1]]$data[[43]]$Species
#> [1] "setosa"
#> 
#> [[1]]$data[[43]]$x
#> [1] 3.2
#> 
#> 
#> [[1]]$data[[44]]
#> [[1]]$data[[44]]$Sepal.Length
#> [1] 5
#> 
#> [[1]]$data[[44]]$Sepal.Width
#> [1] 3.5
#> 
#> [[1]]$data[[44]]$Petal.Length
#> [1] 1.6
#> 
#> [[1]]$data[[44]]$Petal.Width
#> [1] 0.6
#> 
#> [[1]]$data[[44]]$Species
#> [1] "setosa"
#> 
#> [[1]]$data[[44]]$x
#> [1] 3.5
#> 
#> 
#> [[1]]$data[[45]]
#> [[1]]$data[[45]]$Sepal.Length
#> [1] 5.1
#> 
#> [[1]]$data[[45]]$Sepal.Width
#> [1] 3.8
#> 
#> [[1]]$data[[45]]$Petal.Length
#> [1] 1.9
#> 
#> [[1]]$data[[45]]$Petal.Width
#> [1] 0.4
#> 
#> [[1]]$data[[45]]$Species
#> [1] "setosa"
#> 
#> [[1]]$data[[45]]$x
#> [1] 3.8
#> 
#> 
#> [[1]]$data[[46]]
#> [[1]]$data[[46]]$Sepal.Length
#> [1] 4.8
#> 
#> [[1]]$data[[46]]$Sepal.Width
#> [1] 3
#> 
#> [[1]]$data[[46]]$Petal.Length
#> [1] 1.4
#> 
#> [[1]]$data[[46]]$Petal.Width
#> [1] 0.3
#> 
#> [[1]]$data[[46]]$Species
#> [1] "setosa"
#> 
#> [[1]]$data[[46]]$x
#> [1] 3
#> 
#> 
#> [[1]]$data[[47]]
#> [[1]]$data[[47]]$Sepal.Length
#> [1] 5.1
#> 
#> [[1]]$data[[47]]$Sepal.Width
#> [1] 3.8
#> 
#> [[1]]$data[[47]]$Petal.Length
#> [1] 1.6
#> 
#> [[1]]$data[[47]]$Petal.Width
#> [1] 0.2
#> 
#> [[1]]$data[[47]]$Species
#> [1] "setosa"
#> 
#> [[1]]$data[[47]]$x
#> [1] 3.8
#> 
#> 
#> [[1]]$data[[48]]
#> [[1]]$data[[48]]$Sepal.Length
#> [1] 4.6
#> 
#> [[1]]$data[[48]]$Sepal.Width
#> [1] 3.2
#> 
#> [[1]]$data[[48]]$Petal.Length
#> [1] 1.4
#> 
#> [[1]]$data[[48]]$Petal.Width
#> [1] 0.2
#> 
#> [[1]]$data[[48]]$Species
#> [1] "setosa"
#> 
#> [[1]]$data[[48]]$x
#> [1] 3.2
#> 
#> 
#> [[1]]$data[[49]]
#> [[1]]$data[[49]]$Sepal.Length
#> [1] 5.3
#> 
#> [[1]]$data[[49]]$Sepal.Width
#> [1] 3.7
#> 
#> [[1]]$data[[49]]$Petal.Length
#> [1] 1.5
#> 
#> [[1]]$data[[49]]$Petal.Width
#> [1] 0.2
#> 
#> [[1]]$data[[49]]$Species
#> [1] "setosa"
#> 
#> [[1]]$data[[49]]$x
#> [1] 3.7
#> 
#> 
#> [[1]]$data[[50]]
#> [[1]]$data[[50]]$Sepal.Length
#> [1] 5
#> 
#> [[1]]$data[[50]]$Sepal.Width
#> [1] 3.3
#> 
#> [[1]]$data[[50]]$Petal.Length
#> [1] 1.4
#> 
#> [[1]]$data[[50]]$Petal.Width
#> [1] 0.2
#> 
#> [[1]]$data[[50]]$Species
#> [1] "setosa"
#> 
#> [[1]]$data[[50]]$x
#> [1] 3.3
#> 
#> 
#> [[1]]$data[[51]]
#> [[1]]$data[[51]]$Sepal.Length
#> [1] 7
#> 
#> [[1]]$data[[51]]$Sepal.Width
#> [1] 3.2
#> 
#> [[1]]$data[[51]]$Petal.Length
#> [1] 4.7
#> 
#> [[1]]$data[[51]]$Petal.Width
#> [1] 1.4
#> 
#> [[1]]$data[[51]]$Species
#> [1] "versicolor"
#> 
#> [[1]]$data[[51]]$x
#> [1] 3.2
#> 
#> 
#> [[1]]$data[[52]]
#> [[1]]$data[[52]]$Sepal.Length
#> [1] 6.4
#> 
#> [[1]]$data[[52]]$Sepal.Width
#> [1] 3.2
#> 
#> [[1]]$data[[52]]$Petal.Length
#> [1] 4.5
#> 
#> [[1]]$data[[52]]$Petal.Width
#> [1] 1.5
#> 
#> [[1]]$data[[52]]$Species
#> [1] "versicolor"
#> 
#> [[1]]$data[[52]]$x
#> [1] 3.2
#> 
#> 
#> [[1]]$data[[53]]
#> [[1]]$data[[53]]$Sepal.Length
#> [1] 6.9
#> 
#> [[1]]$data[[53]]$Sepal.Width
#> [1] 3.1
#> 
#> [[1]]$data[[53]]$Petal.Length
#> [1] 4.9
#> 
#> [[1]]$data[[53]]$Petal.Width
#> [1] 1.5
#> 
#> [[1]]$data[[53]]$Species
#> [1] "versicolor"
#> 
#> [[1]]$data[[53]]$x
#> [1] 3.1
#> 
#> 
#> [[1]]$data[[54]]
#> [[1]]$data[[54]]$Sepal.Length
#> [1] 5.5
#> 
#> [[1]]$data[[54]]$Sepal.Width
#> [1] 2.3
#> 
#> [[1]]$data[[54]]$Petal.Length
#> [1] 4
#> 
#> [[1]]$data[[54]]$Petal.Width
#> [1] 1.3
#> 
#> [[1]]$data[[54]]$Species
#> [1] "versicolor"
#> 
#> [[1]]$data[[54]]$x
#> [1] 2.3
#> 
#> 
#> [[1]]$data[[55]]
#> [[1]]$data[[55]]$Sepal.Length
#> [1] 6.5
#> 
#> [[1]]$data[[55]]$Sepal.Width
#> [1] 2.8
#> 
#> [[1]]$data[[55]]$Petal.Length
#> [1] 4.6
#> 
#> [[1]]$data[[55]]$Petal.Width
#> [1] 1.5
#> 
#> [[1]]$data[[55]]$Species
#> [1] "versicolor"
#> 
#> [[1]]$data[[55]]$x
#> [1] 2.8
#> 
#> 
#> [[1]]$data[[56]]
#> [[1]]$data[[56]]$Sepal.Length
#> [1] 5.7
#> 
#> [[1]]$data[[56]]$Sepal.Width
#> [1] 2.8
#> 
#> [[1]]$data[[56]]$Petal.Length
#> [1] 4.5
#> 
#> [[1]]$data[[56]]$Petal.Width
#> [1] 1.3
#> 
#> [[1]]$data[[56]]$Species
#> [1] "versicolor"
#> 
#> [[1]]$data[[56]]$x
#> [1] 2.8
#> 
#> 
#> [[1]]$data[[57]]
#> [[1]]$data[[57]]$Sepal.Length
#> [1] 6.3
#> 
#> [[1]]$data[[57]]$Sepal.Width
#> [1] 3.3
#> 
#> [[1]]$data[[57]]$Petal.Length
#> [1] 4.7
#> 
#> [[1]]$data[[57]]$Petal.Width
#> [1] 1.6
#> 
#> [[1]]$data[[57]]$Species
#> [1] "versicolor"
#> 
#> [[1]]$data[[57]]$x
#> [1] 3.3
#> 
#> 
#> [[1]]$data[[58]]
#> [[1]]$data[[58]]$Sepal.Length
#> [1] 4.9
#> 
#> [[1]]$data[[58]]$Sepal.Width
#> [1] 2.4
#> 
#> [[1]]$data[[58]]$Petal.Length
#> [1] 3.3
#> 
#> [[1]]$data[[58]]$Petal.Width
#> [1] 1
#> 
#> [[1]]$data[[58]]$Species
#> [1] "versicolor"
#> 
#> [[1]]$data[[58]]$x
#> [1] 2.4
#> 
#> 
#> [[1]]$data[[59]]
#> [[1]]$data[[59]]$Sepal.Length
#> [1] 6.6
#> 
#> [[1]]$data[[59]]$Sepal.Width
#> [1] 2.9
#> 
#> [[1]]$data[[59]]$Petal.Length
#> [1] 4.6
#> 
#> [[1]]$data[[59]]$Petal.Width
#> [1] 1.3
#> 
#> [[1]]$data[[59]]$Species
#> [1] "versicolor"
#> 
#> [[1]]$data[[59]]$x
#> [1] 2.9
#> 
#> 
#> [[1]]$data[[60]]
#> [[1]]$data[[60]]$Sepal.Length
#> [1] 5.2
#> 
#> [[1]]$data[[60]]$Sepal.Width
#> [1] 2.7
#> 
#> [[1]]$data[[60]]$Petal.Length
#> [1] 3.9
#> 
#> [[1]]$data[[60]]$Petal.Width
#> [1] 1.4
#> 
#> [[1]]$data[[60]]$Species
#> [1] "versicolor"
#> 
#> [[1]]$data[[60]]$x
#> [1] 2.7
#> 
#> 
#> [[1]]$data[[61]]
#> [[1]]$data[[61]]$Sepal.Length
#> [1] 5
#> 
#> [[1]]$data[[61]]$Sepal.Width
#> [1] 2
#> 
#> [[1]]$data[[61]]$Petal.Length
#> [1] 3.5
#> 
#> [[1]]$data[[61]]$Petal.Width
#> [1] 1
#> 
#> [[1]]$data[[61]]$Species
#> [1] "versicolor"
#> 
#> [[1]]$data[[61]]$x
#> [1] 2
#> 
#> 
#> [[1]]$data[[62]]
#> [[1]]$data[[62]]$Sepal.Length
#> [1] 5.9
#> 
#> [[1]]$data[[62]]$Sepal.Width
#> [1] 3
#> 
#> [[1]]$data[[62]]$Petal.Length
#> [1] 4.2
#> 
#> [[1]]$data[[62]]$Petal.Width
#> [1] 1.5
#> 
#> [[1]]$data[[62]]$Species
#> [1] "versicolor"
#> 
#> [[1]]$data[[62]]$x
#> [1] 3
#> 
#> 
#> [[1]]$data[[63]]
#> [[1]]$data[[63]]$Sepal.Length
#> [1] 6
#> 
#> [[1]]$data[[63]]$Sepal.Width
#> [1] 2.2
#> 
#> [[1]]$data[[63]]$Petal.Length
#> [1] 4
#> 
#> [[1]]$data[[63]]$Petal.Width
#> [1] 1
#> 
#> [[1]]$data[[63]]$Species
#> [1] "versicolor"
#> 
#> [[1]]$data[[63]]$x
#> [1] 2.2
#> 
#> 
#> [[1]]$data[[64]]
#> [[1]]$data[[64]]$Sepal.Length
#> [1] 6.1
#> 
#> [[1]]$data[[64]]$Sepal.Width
#> [1] 2.9
#> 
#> [[1]]$data[[64]]$Petal.Length
#> [1] 4.7
#> 
#> [[1]]$data[[64]]$Petal.Width
#> [1] 1.4
#> 
#> [[1]]$data[[64]]$Species
#> [1] "versicolor"
#> 
#> [[1]]$data[[64]]$x
#> [1] 2.9
#> 
#> 
#> [[1]]$data[[65]]
#> [[1]]$data[[65]]$Sepal.Length
#> [1] 5.6
#> 
#> [[1]]$data[[65]]$Sepal.Width
#> [1] 2.9
#> 
#> [[1]]$data[[65]]$Petal.Length
#> [1] 3.6
#> 
#> [[1]]$data[[65]]$Petal.Width
#> [1] 1.3
#> 
#> [[1]]$data[[65]]$Species
#> [1] "versicolor"
#> 
#> [[1]]$data[[65]]$x
#> [1] 2.9
#> 
#> 
#> [[1]]$data[[66]]
#> [[1]]$data[[66]]$Sepal.Length
#> [1] 6.7
#> 
#> [[1]]$data[[66]]$Sepal.Width
#> [1] 3.1
#> 
#> [[1]]$data[[66]]$Petal.Length
#> [1] 4.4
#> 
#> [[1]]$data[[66]]$Petal.Width
#> [1] 1.4
#> 
#> [[1]]$data[[66]]$Species
#> [1] "versicolor"
#> 
#> [[1]]$data[[66]]$x
#> [1] 3.1
#> 
#> 
#> [[1]]$data[[67]]
#> [[1]]$data[[67]]$Sepal.Length
#> [1] 5.6
#> 
#> [[1]]$data[[67]]$Sepal.Width
#> [1] 3
#> 
#> [[1]]$data[[67]]$Petal.Length
#> [1] 4.5
#> 
#> [[1]]$data[[67]]$Petal.Width
#> [1] 1.5
#> 
#> [[1]]$data[[67]]$Species
#> [1] "versicolor"
#> 
#> [[1]]$data[[67]]$x
#> [1] 3
#> 
#> 
#> [[1]]$data[[68]]
#> [[1]]$data[[68]]$Sepal.Length
#> [1] 5.8
#> 
#> [[1]]$data[[68]]$Sepal.Width
#> [1] 2.7
#> 
#> [[1]]$data[[68]]$Petal.Length
#> [1] 4.1
#> 
#> [[1]]$data[[68]]$Petal.Width
#> [1] 1
#> 
#> [[1]]$data[[68]]$Species
#> [1] "versicolor"
#> 
#> [[1]]$data[[68]]$x
#> [1] 2.7
#> 
#> 
#> [[1]]$data[[69]]
#> [[1]]$data[[69]]$Sepal.Length
#> [1] 6.2
#> 
#> [[1]]$data[[69]]$Sepal.Width
#> [1] 2.2
#> 
#> [[1]]$data[[69]]$Petal.Length
#> [1] 4.5
#> 
#> [[1]]$data[[69]]$Petal.Width
#> [1] 1.5
#> 
#> [[1]]$data[[69]]$Species
#> [1] "versicolor"
#> 
#> [[1]]$data[[69]]$x
#> [1] 2.2
#> 
#> 
#> [[1]]$data[[70]]
#> [[1]]$data[[70]]$Sepal.Length
#> [1] 5.6
#> 
#> [[1]]$data[[70]]$Sepal.Width
#> [1] 2.5
#> 
#> [[1]]$data[[70]]$Petal.Length
#> [1] 3.9
#> 
#> [[1]]$data[[70]]$Petal.Width
#> [1] 1.1
#> 
#> [[1]]$data[[70]]$Species
#> [1] "versicolor"
#> 
#> [[1]]$data[[70]]$x
#> [1] 2.5
#> 
#> 
#> [[1]]$data[[71]]
#> [[1]]$data[[71]]$Sepal.Length
#> [1] 5.9
#> 
#> [[1]]$data[[71]]$Sepal.Width
#> [1] 3.2
#> 
#> [[1]]$data[[71]]$Petal.Length
#> [1] 4.8
#> 
#> [[1]]$data[[71]]$Petal.Width
#> [1] 1.8
#> 
#> [[1]]$data[[71]]$Species
#> [1] "versicolor"
#> 
#> [[1]]$data[[71]]$x
#> [1] 3.2
#> 
#> 
#> [[1]]$data[[72]]
#> [[1]]$data[[72]]$Sepal.Length
#> [1] 6.1
#> 
#> [[1]]$data[[72]]$Sepal.Width
#> [1] 2.8
#> 
#> [[1]]$data[[72]]$Petal.Length
#> [1] 4
#> 
#> [[1]]$data[[72]]$Petal.Width
#> [1] 1.3
#> 
#> [[1]]$data[[72]]$Species
#> [1] "versicolor"
#> 
#> [[1]]$data[[72]]$x
#> [1] 2.8
#> 
#> 
#> [[1]]$data[[73]]
#> [[1]]$data[[73]]$Sepal.Length
#> [1] 6.3
#> 
#> [[1]]$data[[73]]$Sepal.Width
#> [1] 2.5
#> 
#> [[1]]$data[[73]]$Petal.Length
#> [1] 4.9
#> 
#> [[1]]$data[[73]]$Petal.Width
#> [1] 1.5
#> 
#> [[1]]$data[[73]]$Species
#> [1] "versicolor"
#> 
#> [[1]]$data[[73]]$x
#> [1] 2.5
#> 
#> 
#> [[1]]$data[[74]]
#> [[1]]$data[[74]]$Sepal.Length
#> [1] 6.1
#> 
#> [[1]]$data[[74]]$Sepal.Width
#> [1] 2.8
#> 
#> [[1]]$data[[74]]$Petal.Length
#> [1] 4.7
#> 
#> [[1]]$data[[74]]$Petal.Width
#> [1] 1.2
#> 
#> [[1]]$data[[74]]$Species
#> [1] "versicolor"
#> 
#> [[1]]$data[[74]]$x
#> [1] 2.8
#> 
#> 
#> [[1]]$data[[75]]
#> [[1]]$data[[75]]$Sepal.Length
#> [1] 6.4
#> 
#> [[1]]$data[[75]]$Sepal.Width
#> [1] 2.9
#> 
#> [[1]]$data[[75]]$Petal.Length
#> [1] 4.3
#> 
#> [[1]]$data[[75]]$Petal.Width
#> [1] 1.3
#> 
#> [[1]]$data[[75]]$Species
#> [1] "versicolor"
#> 
#> [[1]]$data[[75]]$x
#> [1] 2.9
#> 
#> 
#> [[1]]$data[[76]]
#> [[1]]$data[[76]]$Sepal.Length
#> [1] 6.6
#> 
#> [[1]]$data[[76]]$Sepal.Width
#> [1] 3
#> 
#> [[1]]$data[[76]]$Petal.Length
#> [1] 4.4
#> 
#> [[1]]$data[[76]]$Petal.Width
#> [1] 1.4
#> 
#> [[1]]$data[[76]]$Species
#> [1] "versicolor"
#> 
#> [[1]]$data[[76]]$x
#> [1] 3
#> 
#> 
#> [[1]]$data[[77]]
#> [[1]]$data[[77]]$Sepal.Length
#> [1] 6.8
#> 
#> [[1]]$data[[77]]$Sepal.Width
#> [1] 2.8
#> 
#> [[1]]$data[[77]]$Petal.Length
#> [1] 4.8
#> 
#> [[1]]$data[[77]]$Petal.Width
#> [1] 1.4
#> 
#> [[1]]$data[[77]]$Species
#> [1] "versicolor"
#> 
#> [[1]]$data[[77]]$x
#> [1] 2.8
#> 
#> 
#> [[1]]$data[[78]]
#> [[1]]$data[[78]]$Sepal.Length
#> [1] 6.7
#> 
#> [[1]]$data[[78]]$Sepal.Width
#> [1] 3
#> 
#> [[1]]$data[[78]]$Petal.Length
#> [1] 5
#> 
#> [[1]]$data[[78]]$Petal.Width
#> [1] 1.7
#> 
#> [[1]]$data[[78]]$Species
#> [1] "versicolor"
#> 
#> [[1]]$data[[78]]$x
#> [1] 3
#> 
#> 
#> [[1]]$data[[79]]
#> [[1]]$data[[79]]$Sepal.Length
#> [1] 6
#> 
#> [[1]]$data[[79]]$Sepal.Width
#> [1] 2.9
#> 
#> [[1]]$data[[79]]$Petal.Length
#> [1] 4.5
#> 
#> [[1]]$data[[79]]$Petal.Width
#> [1] 1.5
#> 
#> [[1]]$data[[79]]$Species
#> [1] "versicolor"
#> 
#> [[1]]$data[[79]]$x
#> [1] 2.9
#> 
#> 
#> [[1]]$data[[80]]
#> [[1]]$data[[80]]$Sepal.Length
#> [1] 5.7
#> 
#> [[1]]$data[[80]]$Sepal.Width
#> [1] 2.6
#> 
#> [[1]]$data[[80]]$Petal.Length
#> [1] 3.5
#> 
#> [[1]]$data[[80]]$Petal.Width
#> [1] 1
#> 
#> [[1]]$data[[80]]$Species
#> [1] "versicolor"
#> 
#> [[1]]$data[[80]]$x
#> [1] 2.6
#> 
#> 
#> [[1]]$data[[81]]
#> [[1]]$data[[81]]$Sepal.Length
#> [1] 5.5
#> 
#> [[1]]$data[[81]]$Sepal.Width
#> [1] 2.4
#> 
#> [[1]]$data[[81]]$Petal.Length
#> [1] 3.8
#> 
#> [[1]]$data[[81]]$Petal.Width
#> [1] 1.1
#> 
#> [[1]]$data[[81]]$Species
#> [1] "versicolor"
#> 
#> [[1]]$data[[81]]$x
#> [1] 2.4
#> 
#> 
#> [[1]]$data[[82]]
#> [[1]]$data[[82]]$Sepal.Length
#> [1] 5.5
#> 
#> [[1]]$data[[82]]$Sepal.Width
#> [1] 2.4
#> 
#> [[1]]$data[[82]]$Petal.Length
#> [1] 3.7
#> 
#> [[1]]$data[[82]]$Petal.Width
#> [1] 1
#> 
#> [[1]]$data[[82]]$Species
#> [1] "versicolor"
#> 
#> [[1]]$data[[82]]$x
#> [1] 2.4
#> 
#> 
#> [[1]]$data[[83]]
#> [[1]]$data[[83]]$Sepal.Length
#> [1] 5.8
#> 
#> [[1]]$data[[83]]$Sepal.Width
#> [1] 2.7
#> 
#> [[1]]$data[[83]]$Petal.Length
#> [1] 3.9
#> 
#> [[1]]$data[[83]]$Petal.Width
#> [1] 1.2
#> 
#> [[1]]$data[[83]]$Species
#> [1] "versicolor"
#> 
#> [[1]]$data[[83]]$x
#> [1] 2.7
#> 
#> 
#> [[1]]$data[[84]]
#> [[1]]$data[[84]]$Sepal.Length
#> [1] 6
#> 
#> [[1]]$data[[84]]$Sepal.Width
#> [1] 2.7
#> 
#> [[1]]$data[[84]]$Petal.Length
#> [1] 5.1
#> 
#> [[1]]$data[[84]]$Petal.Width
#> [1] 1.6
#> 
#> [[1]]$data[[84]]$Species
#> [1] "versicolor"
#> 
#> [[1]]$data[[84]]$x
#> [1] 2.7
#> 
#> 
#> [[1]]$data[[85]]
#> [[1]]$data[[85]]$Sepal.Length
#> [1] 5.4
#> 
#> [[1]]$data[[85]]$Sepal.Width
#> [1] 3
#> 
#> [[1]]$data[[85]]$Petal.Length
#> [1] 4.5
#> 
#> [[1]]$data[[85]]$Petal.Width
#> [1] 1.5
#> 
#> [[1]]$data[[85]]$Species
#> [1] "versicolor"
#> 
#> [[1]]$data[[85]]$x
#> [1] 3
#> 
#> 
#> [[1]]$data[[86]]
#> [[1]]$data[[86]]$Sepal.Length
#> [1] 6
#> 
#> [[1]]$data[[86]]$Sepal.Width
#> [1] 3.4
#> 
#> [[1]]$data[[86]]$Petal.Length
#> [1] 4.5
#> 
#> [[1]]$data[[86]]$Petal.Width
#> [1] 1.6
#> 
#> [[1]]$data[[86]]$Species
#> [1] "versicolor"
#> 
#> [[1]]$data[[86]]$x
#> [1] 3.4
#> 
#> 
#> [[1]]$data[[87]]
#> [[1]]$data[[87]]$Sepal.Length
#> [1] 6.7
#> 
#> [[1]]$data[[87]]$Sepal.Width
#> [1] 3.1
#> 
#> [[1]]$data[[87]]$Petal.Length
#> [1] 4.7
#> 
#> [[1]]$data[[87]]$Petal.Width
#> [1] 1.5
#> 
#> [[1]]$data[[87]]$Species
#> [1] "versicolor"
#> 
#> [[1]]$data[[87]]$x
#> [1] 3.1
#> 
#> 
#> [[1]]$data[[88]]
#> [[1]]$data[[88]]$Sepal.Length
#> [1] 6.3
#> 
#> [[1]]$data[[88]]$Sepal.Width
#> [1] 2.3
#> 
#> [[1]]$data[[88]]$Petal.Length
#> [1] 4.4
#> 
#> [[1]]$data[[88]]$Petal.Width
#> [1] 1.3
#> 
#> [[1]]$data[[88]]$Species
#> [1] "versicolor"
#> 
#> [[1]]$data[[88]]$x
#> [1] 2.3
#> 
#> 
#> [[1]]$data[[89]]
#> [[1]]$data[[89]]$Sepal.Length
#> [1] 5.6
#> 
#> [[1]]$data[[89]]$Sepal.Width
#> [1] 3
#> 
#> [[1]]$data[[89]]$Petal.Length
#> [1] 4.1
#> 
#> [[1]]$data[[89]]$Petal.Width
#> [1] 1.3
#> 
#> [[1]]$data[[89]]$Species
#> [1] "versicolor"
#> 
#> [[1]]$data[[89]]$x
#> [1] 3
#> 
#> 
#> [[1]]$data[[90]]
#> [[1]]$data[[90]]$Sepal.Length
#> [1] 5.5
#> 
#> [[1]]$data[[90]]$Sepal.Width
#> [1] 2.5
#> 
#> [[1]]$data[[90]]$Petal.Length
#> [1] 4
#> 
#> [[1]]$data[[90]]$Petal.Width
#> [1] 1.3
#> 
#> [[1]]$data[[90]]$Species
#> [1] "versicolor"
#> 
#> [[1]]$data[[90]]$x
#> [1] 2.5
#> 
#> 
#> [[1]]$data[[91]]
#> [[1]]$data[[91]]$Sepal.Length
#> [1] 5.5
#> 
#> [[1]]$data[[91]]$Sepal.Width
#> [1] 2.6
#> 
#> [[1]]$data[[91]]$Petal.Length
#> [1] 4.4
#> 
#> [[1]]$data[[91]]$Petal.Width
#> [1] 1.2
#> 
#> [[1]]$data[[91]]$Species
#> [1] "versicolor"
#> 
#> [[1]]$data[[91]]$x
#> [1] 2.6
#> 
#> 
#> [[1]]$data[[92]]
#> [[1]]$data[[92]]$Sepal.Length
#> [1] 6.1
#> 
#> [[1]]$data[[92]]$Sepal.Width
#> [1] 3
#> 
#> [[1]]$data[[92]]$Petal.Length
#> [1] 4.6
#> 
#> [[1]]$data[[92]]$Petal.Width
#> [1] 1.4
#> 
#> [[1]]$data[[92]]$Species
#> [1] "versicolor"
#> 
#> [[1]]$data[[92]]$x
#> [1] 3
#> 
#> 
#> [[1]]$data[[93]]
#> [[1]]$data[[93]]$Sepal.Length
#> [1] 5.8
#> 
#> [[1]]$data[[93]]$Sepal.Width
#> [1] 2.6
#> 
#> [[1]]$data[[93]]$Petal.Length
#> [1] 4
#> 
#> [[1]]$data[[93]]$Petal.Width
#> [1] 1.2
#> 
#> [[1]]$data[[93]]$Species
#> [1] "versicolor"
#> 
#> [[1]]$data[[93]]$x
#> [1] 2.6
#> 
#> 
#> [[1]]$data[[94]]
#> [[1]]$data[[94]]$Sepal.Length
#> [1] 5
#> 
#> [[1]]$data[[94]]$Sepal.Width
#> [1] 2.3
#> 
#> [[1]]$data[[94]]$Petal.Length
#> [1] 3.3
#> 
#> [[1]]$data[[94]]$Petal.Width
#> [1] 1
#> 
#> [[1]]$data[[94]]$Species
#> [1] "versicolor"
#> 
#> [[1]]$data[[94]]$x
#> [1] 2.3
#> 
#> 
#> [[1]]$data[[95]]
#> [[1]]$data[[95]]$Sepal.Length
#> [1] 5.6
#> 
#> [[1]]$data[[95]]$Sepal.Width
#> [1] 2.7
#> 
#> [[1]]$data[[95]]$Petal.Length
#> [1] 4.2
#> 
#> [[1]]$data[[95]]$Petal.Width
#> [1] 1.3
#> 
#> [[1]]$data[[95]]$Species
#> [1] "versicolor"
#> 
#> [[1]]$data[[95]]$x
#> [1] 2.7
#> 
#> 
#> [[1]]$data[[96]]
#> [[1]]$data[[96]]$Sepal.Length
#> [1] 5.7
#> 
#> [[1]]$data[[96]]$Sepal.Width
#> [1] 3
#> 
#> [[1]]$data[[96]]$Petal.Length
#> [1] 4.2
#> 
#> [[1]]$data[[96]]$Petal.Width
#> [1] 1.2
#> 
#> [[1]]$data[[96]]$Species
#> [1] "versicolor"
#> 
#> [[1]]$data[[96]]$x
#> [1] 3
#> 
#> 
#> [[1]]$data[[97]]
#> [[1]]$data[[97]]$Sepal.Length
#> [1] 5.7
#> 
#> [[1]]$data[[97]]$Sepal.Width
#> [1] 2.9
#> 
#> [[1]]$data[[97]]$Petal.Length
#> [1] 4.2
#> 
#> [[1]]$data[[97]]$Petal.Width
#> [1] 1.3
#> 
#> [[1]]$data[[97]]$Species
#> [1] "versicolor"
#> 
#> [[1]]$data[[97]]$x
#> [1] 2.9
#> 
#> 
#> [[1]]$data[[98]]
#> [[1]]$data[[98]]$Sepal.Length
#> [1] 6.2
#> 
#> [[1]]$data[[98]]$Sepal.Width
#> [1] 2.9
#> 
#> [[1]]$data[[98]]$Petal.Length
#> [1] 4.3
#> 
#> [[1]]$data[[98]]$Petal.Width
#> [1] 1.3
#> 
#> [[1]]$data[[98]]$Species
#> [1] "versicolor"
#> 
#> [[1]]$data[[98]]$x
#> [1] 2.9
#> 
#> 
#> [[1]]$data[[99]]
#> [[1]]$data[[99]]$Sepal.Length
#> [1] 5.1
#> 
#> [[1]]$data[[99]]$Sepal.Width
#> [1] 2.5
#> 
#> [[1]]$data[[99]]$Petal.Length
#> [1] 3
#> 
#> [[1]]$data[[99]]$Petal.Width
#> [1] 1.1
#> 
#> [[1]]$data[[99]]$Species
#> [1] "versicolor"
#> 
#> [[1]]$data[[99]]$x
#> [1] 2.5
#> 
#> 
#> [[1]]$data[[100]]
#> [[1]]$data[[100]]$Sepal.Length
#> [1] 5.7
#> 
#> [[1]]$data[[100]]$Sepal.Width
#> [1] 2.8
#> 
#> [[1]]$data[[100]]$Petal.Length
#> [1] 4.1
#> 
#> [[1]]$data[[100]]$Petal.Width
#> [1] 1.3
#> 
#> [[1]]$data[[100]]$Species
#> [1] "versicolor"
#> 
#> [[1]]$data[[100]]$x
#> [1] 2.8
#> 
#> 
#> [[1]]$data[[101]]
#> [[1]]$data[[101]]$Sepal.Length
#> [1] 6.3
#> 
#> [[1]]$data[[101]]$Sepal.Width
#> [1] 3.3
#> 
#> [[1]]$data[[101]]$Petal.Length
#> [1] 6
#> 
#> [[1]]$data[[101]]$Petal.Width
#> [1] 2.5
#> 
#> [[1]]$data[[101]]$Species
#> [1] "virginica"
#> 
#> [[1]]$data[[101]]$x
#> [1] 3.3
#> 
#> 
#> [[1]]$data[[102]]
#> [[1]]$data[[102]]$Sepal.Length
#> [1] 5.8
#> 
#> [[1]]$data[[102]]$Sepal.Width
#> [1] 2.7
#> 
#> [[1]]$data[[102]]$Petal.Length
#> [1] 5.1
#> 
#> [[1]]$data[[102]]$Petal.Width
#> [1] 1.9
#> 
#> [[1]]$data[[102]]$Species
#> [1] "virginica"
#> 
#> [[1]]$data[[102]]$x
#> [1] 2.7
#> 
#> 
#> [[1]]$data[[103]]
#> [[1]]$data[[103]]$Sepal.Length
#> [1] 7.1
#> 
#> [[1]]$data[[103]]$Sepal.Width
#> [1] 3
#> 
#> [[1]]$data[[103]]$Petal.Length
#> [1] 5.9
#> 
#> [[1]]$data[[103]]$Petal.Width
#> [1] 2.1
#> 
#> [[1]]$data[[103]]$Species
#> [1] "virginica"
#> 
#> [[1]]$data[[103]]$x
#> [1] 3
#> 
#> 
#> [[1]]$data[[104]]
#> [[1]]$data[[104]]$Sepal.Length
#> [1] 6.3
#> 
#> [[1]]$data[[104]]$Sepal.Width
#> [1] 2.9
#> 
#> [[1]]$data[[104]]$Petal.Length
#> [1] 5.6
#> 
#> [[1]]$data[[104]]$Petal.Width
#> [1] 1.8
#> 
#> [[1]]$data[[104]]$Species
#> [1] "virginica"
#> 
#> [[1]]$data[[104]]$x
#> [1] 2.9
#> 
#> 
#> [[1]]$data[[105]]
#> [[1]]$data[[105]]$Sepal.Length
#> [1] 6.5
#> 
#> [[1]]$data[[105]]$Sepal.Width
#> [1] 3
#> 
#> [[1]]$data[[105]]$Petal.Length
#> [1] 5.8
#> 
#> [[1]]$data[[105]]$Petal.Width
#> [1] 2.2
#> 
#> [[1]]$data[[105]]$Species
#> [1] "virginica"
#> 
#> [[1]]$data[[105]]$x
#> [1] 3
#> 
#> 
#> [[1]]$data[[106]]
#> [[1]]$data[[106]]$Sepal.Length
#> [1] 7.6
#> 
#> [[1]]$data[[106]]$Sepal.Width
#> [1] 3
#> 
#> [[1]]$data[[106]]$Petal.Length
#> [1] 6.6
#> 
#> [[1]]$data[[106]]$Petal.Width
#> [1] 2.1
#> 
#> [[1]]$data[[106]]$Species
#> [1] "virginica"
#> 
#> [[1]]$data[[106]]$x
#> [1] 3
#> 
#> 
#> [[1]]$data[[107]]
#> [[1]]$data[[107]]$Sepal.Length
#> [1] 4.9
#> 
#> [[1]]$data[[107]]$Sepal.Width
#> [1] 2.5
#> 
#> [[1]]$data[[107]]$Petal.Length
#> [1] 4.5
#> 
#> [[1]]$data[[107]]$Petal.Width
#> [1] 1.7
#> 
#> [[1]]$data[[107]]$Species
#> [1] "virginica"
#> 
#> [[1]]$data[[107]]$x
#> [1] 2.5
#> 
#> 
#> [[1]]$data[[108]]
#> [[1]]$data[[108]]$Sepal.Length
#> [1] 7.3
#> 
#> [[1]]$data[[108]]$Sepal.Width
#> [1] 2.9
#> 
#> [[1]]$data[[108]]$Petal.Length
#> [1] 6.3
#> 
#> [[1]]$data[[108]]$Petal.Width
#> [1] 1.8
#> 
#> [[1]]$data[[108]]$Species
#> [1] "virginica"
#> 
#> [[1]]$data[[108]]$x
#> [1] 2.9
#> 
#> 
#> [[1]]$data[[109]]
#> [[1]]$data[[109]]$Sepal.Length
#> [1] 6.7
#> 
#> [[1]]$data[[109]]$Sepal.Width
#> [1] 2.5
#> 
#> [[1]]$data[[109]]$Petal.Length
#> [1] 5.8
#> 
#> [[1]]$data[[109]]$Petal.Width
#> [1] 1.8
#> 
#> [[1]]$data[[109]]$Species
#> [1] "virginica"
#> 
#> [[1]]$data[[109]]$x
#> [1] 2.5
#> 
#> 
#> [[1]]$data[[110]]
#> [[1]]$data[[110]]$Sepal.Length
#> [1] 7.2
#> 
#> [[1]]$data[[110]]$Sepal.Width
#> [1] 3.6
#> 
#> [[1]]$data[[110]]$Petal.Length
#> [1] 6.1
#> 
#> [[1]]$data[[110]]$Petal.Width
#> [1] 2.5
#> 
#> [[1]]$data[[110]]$Species
#> [1] "virginica"
#> 
#> [[1]]$data[[110]]$x
#> [1] 3.6
#> 
#> 
#> [[1]]$data[[111]]
#> [[1]]$data[[111]]$Sepal.Length
#> [1] 6.5
#> 
#> [[1]]$data[[111]]$Sepal.Width
#> [1] 3.2
#> 
#> [[1]]$data[[111]]$Petal.Length
#> [1] 5.1
#> 
#> [[1]]$data[[111]]$Petal.Width
#> [1] 2
#> 
#> [[1]]$data[[111]]$Species
#> [1] "virginica"
#> 
#> [[1]]$data[[111]]$x
#> [1] 3.2
#> 
#> 
#> [[1]]$data[[112]]
#> [[1]]$data[[112]]$Sepal.Length
#> [1] 6.4
#> 
#> [[1]]$data[[112]]$Sepal.Width
#> [1] 2.7
#> 
#> [[1]]$data[[112]]$Petal.Length
#> [1] 5.3
#> 
#> [[1]]$data[[112]]$Petal.Width
#> [1] 1.9
#> 
#> [[1]]$data[[112]]$Species
#> [1] "virginica"
#> 
#> [[1]]$data[[112]]$x
#> [1] 2.7
#> 
#> 
#> [[1]]$data[[113]]
#> [[1]]$data[[113]]$Sepal.Length
#> [1] 6.8
#> 
#> [[1]]$data[[113]]$Sepal.Width
#> [1] 3
#> 
#> [[1]]$data[[113]]$Petal.Length
#> [1] 5.5
#> 
#> [[1]]$data[[113]]$Petal.Width
#> [1] 2.1
#> 
#> [[1]]$data[[113]]$Species
#> [1] "virginica"
#> 
#> [[1]]$data[[113]]$x
#> [1] 3
#> 
#> 
#> [[1]]$data[[114]]
#> [[1]]$data[[114]]$Sepal.Length
#> [1] 5.7
#> 
#> [[1]]$data[[114]]$Sepal.Width
#> [1] 2.5
#> 
#> [[1]]$data[[114]]$Petal.Length
#> [1] 5
#> 
#> [[1]]$data[[114]]$Petal.Width
#> [1] 2
#> 
#> [[1]]$data[[114]]$Species
#> [1] "virginica"
#> 
#> [[1]]$data[[114]]$x
#> [1] 2.5
#> 
#> 
#> [[1]]$data[[115]]
#> [[1]]$data[[115]]$Sepal.Length
#> [1] 5.8
#> 
#> [[1]]$data[[115]]$Sepal.Width
#> [1] 2.8
#> 
#> [[1]]$data[[115]]$Petal.Length
#> [1] 5.1
#> 
#> [[1]]$data[[115]]$Petal.Width
#> [1] 2.4
#> 
#> [[1]]$data[[115]]$Species
#> [1] "virginica"
#> 
#> [[1]]$data[[115]]$x
#> [1] 2.8
#> 
#> 
#> [[1]]$data[[116]]
#> [[1]]$data[[116]]$Sepal.Length
#> [1] 6.4
#> 
#> [[1]]$data[[116]]$Sepal.Width
#> [1] 3.2
#> 
#> [[1]]$data[[116]]$Petal.Length
#> [1] 5.3
#> 
#> [[1]]$data[[116]]$Petal.Width
#> [1] 2.3
#> 
#> [[1]]$data[[116]]$Species
#> [1] "virginica"
#> 
#> [[1]]$data[[116]]$x
#> [1] 3.2
#> 
#> 
#> [[1]]$data[[117]]
#> [[1]]$data[[117]]$Sepal.Length
#> [1] 6.5
#> 
#> [[1]]$data[[117]]$Sepal.Width
#> [1] 3
#> 
#> [[1]]$data[[117]]$Petal.Length
#> [1] 5.5
#> 
#> [[1]]$data[[117]]$Petal.Width
#> [1] 1.8
#> 
#> [[1]]$data[[117]]$Species
#> [1] "virginica"
#> 
#> [[1]]$data[[117]]$x
#> [1] 3
#> 
#> 
#> [[1]]$data[[118]]
#> [[1]]$data[[118]]$Sepal.Length
#> [1] 7.7
#> 
#> [[1]]$data[[118]]$Sepal.Width
#> [1] 3.8
#> 
#> [[1]]$data[[118]]$Petal.Length
#> [1] 6.7
#> 
#> [[1]]$data[[118]]$Petal.Width
#> [1] 2.2
#> 
#> [[1]]$data[[118]]$Species
#> [1] "virginica"
#> 
#> [[1]]$data[[118]]$x
#> [1] 3.8
#> 
#> 
#> [[1]]$data[[119]]
#> [[1]]$data[[119]]$Sepal.Length
#> [1] 7.7
#> 
#> [[1]]$data[[119]]$Sepal.Width
#> [1] 2.6
#> 
#> [[1]]$data[[119]]$Petal.Length
#> [1] 6.9
#> 
#> [[1]]$data[[119]]$Petal.Width
#> [1] 2.3
#> 
#> [[1]]$data[[119]]$Species
#> [1] "virginica"
#> 
#> [[1]]$data[[119]]$x
#> [1] 2.6
#> 
#> 
#> [[1]]$data[[120]]
#> [[1]]$data[[120]]$Sepal.Length
#> [1] 6
#> 
#> [[1]]$data[[120]]$Sepal.Width
#> [1] 2.2
#> 
#> [[1]]$data[[120]]$Petal.Length
#> [1] 5
#> 
#> [[1]]$data[[120]]$Petal.Width
#> [1] 1.5
#> 
#> [[1]]$data[[120]]$Species
#> [1] "virginica"
#> 
#> [[1]]$data[[120]]$x
#> [1] 2.2
#> 
#> 
#> [[1]]$data[[121]]
#> [[1]]$data[[121]]$Sepal.Length
#> [1] 6.9
#> 
#> [[1]]$data[[121]]$Sepal.Width
#> [1] 3.2
#> 
#> [[1]]$data[[121]]$Petal.Length
#> [1] 5.7
#> 
#> [[1]]$data[[121]]$Petal.Width
#> [1] 2.3
#> 
#> [[1]]$data[[121]]$Species
#> [1] "virginica"
#> 
#> [[1]]$data[[121]]$x
#> [1] 3.2
#> 
#> 
#> [[1]]$data[[122]]
#> [[1]]$data[[122]]$Sepal.Length
#> [1] 5.6
#> 
#> [[1]]$data[[122]]$Sepal.Width
#> [1] 2.8
#> 
#> [[1]]$data[[122]]$Petal.Length
#> [1] 4.9
#> 
#> [[1]]$data[[122]]$Petal.Width
#> [1] 2
#> 
#> [[1]]$data[[122]]$Species
#> [1] "virginica"
#> 
#> [[1]]$data[[122]]$x
#> [1] 2.8
#> 
#> 
#> [[1]]$data[[123]]
#> [[1]]$data[[123]]$Sepal.Length
#> [1] 7.7
#> 
#> [[1]]$data[[123]]$Sepal.Width
#> [1] 2.8
#> 
#> [[1]]$data[[123]]$Petal.Length
#> [1] 6.7
#> 
#> [[1]]$data[[123]]$Petal.Width
#> [1] 2
#> 
#> [[1]]$data[[123]]$Species
#> [1] "virginica"
#> 
#> [[1]]$data[[123]]$x
#> [1] 2.8
#> 
#> 
#> [[1]]$data[[124]]
#> [[1]]$data[[124]]$Sepal.Length
#> [1] 6.3
#> 
#> [[1]]$data[[124]]$Sepal.Width
#> [1] 2.7
#> 
#> [[1]]$data[[124]]$Petal.Length
#> [1] 4.9
#> 
#> [[1]]$data[[124]]$Petal.Width
#> [1] 1.8
#> 
#> [[1]]$data[[124]]$Species
#> [1] "virginica"
#> 
#> [[1]]$data[[124]]$x
#> [1] 2.7
#> 
#> 
#> [[1]]$data[[125]]
#> [[1]]$data[[125]]$Sepal.Length
#> [1] 6.7
#> 
#> [[1]]$data[[125]]$Sepal.Width
#> [1] 3.3
#> 
#> [[1]]$data[[125]]$Petal.Length
#> [1] 5.7
#> 
#> [[1]]$data[[125]]$Petal.Width
#> [1] 2.1
#> 
#> [[1]]$data[[125]]$Species
#> [1] "virginica"
#> 
#> [[1]]$data[[125]]$x
#> [1] 3.3
#> 
#> 
#> [[1]]$data[[126]]
#> [[1]]$data[[126]]$Sepal.Length
#> [1] 7.2
#> 
#> [[1]]$data[[126]]$Sepal.Width
#> [1] 3.2
#> 
#> [[1]]$data[[126]]$Petal.Length
#> [1] 6
#> 
#> [[1]]$data[[126]]$Petal.Width
#> [1] 1.8
#> 
#> [[1]]$data[[126]]$Species
#> [1] "virginica"
#> 
#> [[1]]$data[[126]]$x
#> [1] 3.2
#> 
#> 
#> [[1]]$data[[127]]
#> [[1]]$data[[127]]$Sepal.Length
#> [1] 6.2
#> 
#> [[1]]$data[[127]]$Sepal.Width
#> [1] 2.8
#> 
#> [[1]]$data[[127]]$Petal.Length
#> [1] 4.8
#> 
#> [[1]]$data[[127]]$Petal.Width
#> [1] 1.8
#> 
#> [[1]]$data[[127]]$Species
#> [1] "virginica"
#> 
#> [[1]]$data[[127]]$x
#> [1] 2.8
#> 
#> 
#> [[1]]$data[[128]]
#> [[1]]$data[[128]]$Sepal.Length
#> [1] 6.1
#> 
#> [[1]]$data[[128]]$Sepal.Width
#> [1] 3
#> 
#> [[1]]$data[[128]]$Petal.Length
#> [1] 4.9
#> 
#> [[1]]$data[[128]]$Petal.Width
#> [1] 1.8
#> 
#> [[1]]$data[[128]]$Species
#> [1] "virginica"
#> 
#> [[1]]$data[[128]]$x
#> [1] 3
#> 
#> 
#> [[1]]$data[[129]]
#> [[1]]$data[[129]]$Sepal.Length
#> [1] 6.4
#> 
#> [[1]]$data[[129]]$Sepal.Width
#> [1] 2.8
#> 
#> [[1]]$data[[129]]$Petal.Length
#> [1] 5.6
#> 
#> [[1]]$data[[129]]$Petal.Width
#> [1] 2.1
#> 
#> [[1]]$data[[129]]$Species
#> [1] "virginica"
#> 
#> [[1]]$data[[129]]$x
#> [1] 2.8
#> 
#> 
#> [[1]]$data[[130]]
#> [[1]]$data[[130]]$Sepal.Length
#> [1] 7.2
#> 
#> [[1]]$data[[130]]$Sepal.Width
#> [1] 3
#> 
#> [[1]]$data[[130]]$Petal.Length
#> [1] 5.8
#> 
#> [[1]]$data[[130]]$Petal.Width
#> [1] 1.6
#> 
#> [[1]]$data[[130]]$Species
#> [1] "virginica"
#> 
#> [[1]]$data[[130]]$x
#> [1] 3
#> 
#> 
#> [[1]]$data[[131]]
#> [[1]]$data[[131]]$Sepal.Length
#> [1] 7.4
#> 
#> [[1]]$data[[131]]$Sepal.Width
#> [1] 2.8
#> 
#> [[1]]$data[[131]]$Petal.Length
#> [1] 6.1
#> 
#> [[1]]$data[[131]]$Petal.Width
#> [1] 1.9
#> 
#> [[1]]$data[[131]]$Species
#> [1] "virginica"
#> 
#> [[1]]$data[[131]]$x
#> [1] 2.8
#> 
#> 
#> [[1]]$data[[132]]
#> [[1]]$data[[132]]$Sepal.Length
#> [1] 7.9
#> 
#> [[1]]$data[[132]]$Sepal.Width
#> [1] 3.8
#> 
#> [[1]]$data[[132]]$Petal.Length
#> [1] 6.4
#> 
#> [[1]]$data[[132]]$Petal.Width
#> [1] 2
#> 
#> [[1]]$data[[132]]$Species
#> [1] "virginica"
#> 
#> [[1]]$data[[132]]$x
#> [1] 3.8
#> 
#> 
#> [[1]]$data[[133]]
#> [[1]]$data[[133]]$Sepal.Length
#> [1] 6.4
#> 
#> [[1]]$data[[133]]$Sepal.Width
#> [1] 2.8
#> 
#> [[1]]$data[[133]]$Petal.Length
#> [1] 5.6
#> 
#> [[1]]$data[[133]]$Petal.Width
#> [1] 2.2
#> 
#> [[1]]$data[[133]]$Species
#> [1] "virginica"
#> 
#> [[1]]$data[[133]]$x
#> [1] 2.8
#> 
#> 
#> [[1]]$data[[134]]
#> [[1]]$data[[134]]$Sepal.Length
#> [1] 6.3
#> 
#> [[1]]$data[[134]]$Sepal.Width
#> [1] 2.8
#> 
#> [[1]]$data[[134]]$Petal.Length
#> [1] 5.1
#> 
#> [[1]]$data[[134]]$Petal.Width
#> [1] 1.5
#> 
#> [[1]]$data[[134]]$Species
#> [1] "virginica"
#> 
#> [[1]]$data[[134]]$x
#> [1] 2.8
#> 
#> 
#> [[1]]$data[[135]]
#> [[1]]$data[[135]]$Sepal.Length
#> [1] 6.1
#> 
#> [[1]]$data[[135]]$Sepal.Width
#> [1] 2.6
#> 
#> [[1]]$data[[135]]$Petal.Length
#> [1] 5.6
#> 
#> [[1]]$data[[135]]$Petal.Width
#> [1] 1.4
#> 
#> [[1]]$data[[135]]$Species
#> [1] "virginica"
#> 
#> [[1]]$data[[135]]$x
#> [1] 2.6
#> 
#> 
#> [[1]]$data[[136]]
#> [[1]]$data[[136]]$Sepal.Length
#> [1] 7.7
#> 
#> [[1]]$data[[136]]$Sepal.Width
#> [1] 3
#> 
#> [[1]]$data[[136]]$Petal.Length
#> [1] 6.1
#> 
#> [[1]]$data[[136]]$Petal.Width
#> [1] 2.3
#> 
#> [[1]]$data[[136]]$Species
#> [1] "virginica"
#> 
#> [[1]]$data[[136]]$x
#> [1] 3
#> 
#> 
#> [[1]]$data[[137]]
#> [[1]]$data[[137]]$Sepal.Length
#> [1] 6.3
#> 
#> [[1]]$data[[137]]$Sepal.Width
#> [1] 3.4
#> 
#> [[1]]$data[[137]]$Petal.Length
#> [1] 5.6
#> 
#> [[1]]$data[[137]]$Petal.Width
#> [1] 2.4
#> 
#> [[1]]$data[[137]]$Species
#> [1] "virginica"
#> 
#> [[1]]$data[[137]]$x
#> [1] 3.4
#> 
#> 
#> [[1]]$data[[138]]
#> [[1]]$data[[138]]$Sepal.Length
#> [1] 6.4
#> 
#> [[1]]$data[[138]]$Sepal.Width
#> [1] 3.1
#> 
#> [[1]]$data[[138]]$Petal.Length
#> [1] 5.5
#> 
#> [[1]]$data[[138]]$Petal.Width
#> [1] 1.8
#> 
#> [[1]]$data[[138]]$Species
#> [1] "virginica"
#> 
#> [[1]]$data[[138]]$x
#> [1] 3.1
#> 
#> 
#> [[1]]$data[[139]]
#> [[1]]$data[[139]]$Sepal.Length
#> [1] 6
#> 
#> [[1]]$data[[139]]$Sepal.Width
#> [1] 3
#> 
#> [[1]]$data[[139]]$Petal.Length
#> [1] 4.8
#> 
#> [[1]]$data[[139]]$Petal.Width
#> [1] 1.8
#> 
#> [[1]]$data[[139]]$Species
#> [1] "virginica"
#> 
#> [[1]]$data[[139]]$x
#> [1] 3
#> 
#> 
#> [[1]]$data[[140]]
#> [[1]]$data[[140]]$Sepal.Length
#> [1] 6.9
#> 
#> [[1]]$data[[140]]$Sepal.Width
#> [1] 3.1
#> 
#> [[1]]$data[[140]]$Petal.Length
#> [1] 5.4
#> 
#> [[1]]$data[[140]]$Petal.Width
#> [1] 2.1
#> 
#> [[1]]$data[[140]]$Species
#> [1] "virginica"
#> 
#> [[1]]$data[[140]]$x
#> [1] 3.1
#> 
#> 
#> [[1]]$data[[141]]
#> [[1]]$data[[141]]$Sepal.Length
#> [1] 6.7
#> 
#> [[1]]$data[[141]]$Sepal.Width
#> [1] 3.1
#> 
#> [[1]]$data[[141]]$Petal.Length
#> [1] 5.6
#> 
#> [[1]]$data[[141]]$Petal.Width
#> [1] 2.4
#> 
#> [[1]]$data[[141]]$Species
#> [1] "virginica"
#> 
#> [[1]]$data[[141]]$x
#> [1] 3.1
#> 
#> 
#> [[1]]$data[[142]]
#> [[1]]$data[[142]]$Sepal.Length
#> [1] 6.9
#> 
#> [[1]]$data[[142]]$Sepal.Width
#> [1] 3.1
#> 
#> [[1]]$data[[142]]$Petal.Length
#> [1] 5.1
#> 
#> [[1]]$data[[142]]$Petal.Width
#> [1] 2.3
#> 
#> [[1]]$data[[142]]$Species
#> [1] "virginica"
#> 
#> [[1]]$data[[142]]$x
#> [1] 3.1
#> 
#> 
#> [[1]]$data[[143]]
#> [[1]]$data[[143]]$Sepal.Length
#> [1] 5.8
#> 
#> [[1]]$data[[143]]$Sepal.Width
#> [1] 2.7
#> 
#> [[1]]$data[[143]]$Petal.Length
#> [1] 5.1
#> 
#> [[1]]$data[[143]]$Petal.Width
#> [1] 1.9
#> 
#> [[1]]$data[[143]]$Species
#> [1] "virginica"
#> 
#> [[1]]$data[[143]]$x
#> [1] 2.7
#> 
#> 
#> [[1]]$data[[144]]
#> [[1]]$data[[144]]$Sepal.Length
#> [1] 6.8
#> 
#> [[1]]$data[[144]]$Sepal.Width
#> [1] 3.2
#> 
#> [[1]]$data[[144]]$Petal.Length
#> [1] 5.9
#> 
#> [[1]]$data[[144]]$Petal.Width
#> [1] 2.3
#> 
#> [[1]]$data[[144]]$Species
#> [1] "virginica"
#> 
#> [[1]]$data[[144]]$x
#> [1] 3.2
#> 
#> 
#> [[1]]$data[[145]]
#> [[1]]$data[[145]]$Sepal.Length
#> [1] 6.7
#> 
#> [[1]]$data[[145]]$Sepal.Width
#> [1] 3.3
#> 
#> [[1]]$data[[145]]$Petal.Length
#> [1] 5.7
#> 
#> [[1]]$data[[145]]$Petal.Width
#> [1] 2.5
#> 
#> [[1]]$data[[145]]$Species
#> [1] "virginica"
#> 
#> [[1]]$data[[145]]$x
#> [1] 3.3
#> 
#> 
#> [[1]]$data[[146]]
#> [[1]]$data[[146]]$Sepal.Length
#> [1] 6.7
#> 
#> [[1]]$data[[146]]$Sepal.Width
#> [1] 3
#> 
#> [[1]]$data[[146]]$Petal.Length
#> [1] 5.2
#> 
#> [[1]]$data[[146]]$Petal.Width
#> [1] 2.3
#> 
#> [[1]]$data[[146]]$Species
#> [1] "virginica"
#> 
#> [[1]]$data[[146]]$x
#> [1] 3
#> 
#> 
#> [[1]]$data[[147]]
#> [[1]]$data[[147]]$Sepal.Length
#> [1] 6.3
#> 
#> [[1]]$data[[147]]$Sepal.Width
#> [1] 2.5
#> 
#> [[1]]$data[[147]]$Petal.Length
#> [1] 5
#> 
#> [[1]]$data[[147]]$Petal.Width
#> [1] 1.9
#> 
#> [[1]]$data[[147]]$Species
#> [1] "virginica"
#> 
#> [[1]]$data[[147]]$x
#> [1] 2.5
#> 
#> 
#> [[1]]$data[[148]]
#> [[1]]$data[[148]]$Sepal.Length
#> [1] 6.5
#> 
#> [[1]]$data[[148]]$Sepal.Width
#> [1] 3
#> 
#> [[1]]$data[[148]]$Petal.Length
#> [1] 5.2
#> 
#> [[1]]$data[[148]]$Petal.Width
#> [1] 2
#> 
#> [[1]]$data[[148]]$Species
#> [1] "virginica"
#> 
#> [[1]]$data[[148]]$x
#> [1] 3
#> 
#> 
#> [[1]]$data[[149]]
#> [[1]]$data[[149]]$Sepal.Length
#> [1] 6.2
#> 
#> [[1]]$data[[149]]$Sepal.Width
#> [1] 3.4
#> 
#> [[1]]$data[[149]]$Petal.Length
#> [1] 5.4
#> 
#> [[1]]$data[[149]]$Petal.Width
#> [1] 2.3
#> 
#> [[1]]$data[[149]]$Species
#> [1] "virginica"
#> 
#> [[1]]$data[[149]]$x
#> [1] 3.4
#> 
#> 
#> [[1]]$data[[150]]
#> [[1]]$data[[150]]$Sepal.Length
#> [1] 5.9
#> 
#> [[1]]$data[[150]]$Sepal.Width
#> [1] 3
#> 
#> [[1]]$data[[150]]$Petal.Length
#> [1] 5.1
#> 
#> [[1]]$data[[150]]$Petal.Width
#> [1] 1.8
#> 
#> [[1]]$data[[150]]$Species
#> [1] "virginica"
#> 
#> [[1]]$data[[150]]$x
#> [1] 3
#> 
#> 
#> 
#> 
```
