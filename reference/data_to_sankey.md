# Helper to transform data frame for sankey highcharts format

Helper to transform data frame for sankey highcharts format

## Usage

``` r
data_to_sankey(data = NULL)
```

## Arguments

- data:

  A data frame

## Examples

``` r
if (FALSE) { # \dontrun{
library(dplyr)
data(diamonds, package = "ggplot2")

diamonds2 <- select(diamonds, cut, color, clarity)

data_to_sankey(diamonds2)

hchart(data_to_sankey(diamonds2), "sankey", name = "diamonds")
} # }
```
