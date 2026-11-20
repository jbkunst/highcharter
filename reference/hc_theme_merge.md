# Merge chart themes

Merge chart themes

## Usage

``` r
hc_theme_merge(...)
```

## Arguments

- ...:

  Themes built with
  [`hc_theme()`](https://jkunst.com/highcharter/reference/hc_theme.md).
  Later arguments take precedence.

## Value

An `hc_theme` object.

## Examples

``` r
hc_theme_merge(hc_theme("ft"), hc_theme(chart = list(backgroundColor = "white")))
#> $colors
#> [1] "#0F5499" "#EB5E8D" "#70DCE6" "#9DBF57" "#208FCE" "#7F062E" "#C2B7AF"
#> [8] "#CE3140"
#> 
#> $plotOptions
#> $plotOptions$bar
#> $plotOptions$bar$colors
#> [1] "#1E558C" "#94D2E6" "#1E8FCC" "#B3325D" "#FF75A3" "#D9CCC3" "#AECC70"
#> [8] "#F34D5B"
#> 
#> 
#> $plotOptions$column
#> $plotOptions$column$colors
#> [1] "#1E558C" "#94D2E6" "#1E8FCC" "#B3325D" "#FF75A3" "#D9CCC3" "#AECC70"
#> [8] "#F34D5B"
#> 
#> 
#> 
#> $chart
#> $chart$backgroundColor
#> [1] "white"
#> 
#> $chart$style
#> $chart$style$fontFamily
#> [1] "Arial, sans-serif"
#> 
#> 
#> 
#> $title
#> $title$align
#> [1] "left"
#> 
#> $title$style
#> $title$style$color
#> [1] "#33302E"
#> 
#> $title$style$fontWeight
#> [1] "bold"
#> 
#> 
#> 
#> $subtitle
#> $subtitle$align
#> [1] "left"
#> 
#> $subtitle$style
#> $subtitle$style$color
#> [1] "#33302E"
#> 
#> 
#> 
#> $xAxis
#> $xAxis$lineColor
#> [1] "#CCC1B7"
#> 
#> $xAxis$tickLength
#> [1] 0
#> 
#> $xAxis$labels
#> $xAxis$labels$style
#> $xAxis$labels$style$color
#> [1] "#33302E"
#> 
#> 
#> 
#> 
#> $yAxis
#> $yAxis$gridLineColor
#> [1] "#CCC1B7"
#> 
#> $yAxis$labels
#> $yAxis$labels$style
#> $yAxis$labels$style$color
#> [1] "#33302E"
#> 
#> 
#> 
#> 
#> $legend
#> $legend$align
#> [1] "left"
#> 
#> $legend$itemStyle
#> $legend$itemStyle$color
#> [1] "#33302E"
#> 
#> 
#> 
#> attr(,"class")
#> [1] "hc_theme"
```
