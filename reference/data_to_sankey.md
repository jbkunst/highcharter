# Count links between consecutive columns for a Sankey chart

Count links between consecutive columns for a Sankey chart

## Usage

``` r
data_to_sankey(data = NULL)
```

## Arguments

- data:

  A data frame with one column per stage, in traversal order. Numeric
  columns with more than ten distinct finite values are grouped by
  quintiles. Tied cut points produce fewer groups.

## Value

A tibble with `from`, `to`, `weight` (number of transitions) and a
unique link `id`. Links with a missing endpoint are omitted. Fewer than
two columns produce an empty tibble with the same columns.

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
