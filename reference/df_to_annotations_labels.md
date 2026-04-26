# Function to create annotations arguments from a data frame

Function to create annotations arguments from a data frame

## Usage

``` r
df_to_annotations_labels(df, xAxis = 0, yAxis = 0)
```

## Arguments

- df:

  A data frame with `x`, `y` and `text` columns names.

- xAxis:

  Index (js 0-based) of the x axis to put the annotations.

- yAxis:

  Index (js 0-based) of the y axis to put the annotations.

## Examples

``` r
df <- data.frame(text = c("hi", "bye"), x = c(0, 1), y = c(1, 0))

df_to_annotations_labels(df)
#> [[1]]
#> [[1]]$text
#> [1] "hi"
#> 
#> [[1]]$point
#> [[1]]$point$x
#> [1] 0
#> 
#> [[1]]$point$y
#> [1] 1
#> 
#> [[1]]$point$xAxis
#> [1] 0
#> 
#> [[1]]$point$yAxis
#> [1] 0
#> 
#> 
#> 
#> [[2]]
#> [[2]]$text
#> [1] "bye"
#> 
#> [[2]]$point
#> [[2]]$point$x
#> [1] 1
#> 
#> [[2]]$point$y
#> [1] 0
#> 
#> [[2]]$point$xAxis
#> [1] 0
#> 
#> [[2]]$point$yAxis
#> [1] 0
#> 
#> 
#> 
```
