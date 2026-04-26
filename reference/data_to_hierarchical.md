# Helper to transform data frame for treemap/sunburst highcharts format

Helper to transform data frame for treemap/sunburst highcharts format

## Usage

``` r
data_to_hierarchical(
  data,
  group_vars,
  size_var,
  colors = getOption("highcharter.color_palette")
)
```

## Arguments

- data:

  data frame containing variables to organize each level of the treemap.

- group_vars:

  Variables to generate treemap levels.

- size_var:

  Variable to aggregate.

- colors:

  Color to chart every item in the first level.

## Examples

``` r
if (FALSE) { # \dontrun{

library(dplyr)
data(gapminder, package = "gapminder")

gapminder_2007 <- gapminder::gapminder |>
  filter(year == max(year)) |>
  mutate(pop_mm = round(pop / 1e6))

dout <- data_to_hierarchical(gapminder_2007, c(continent, country), pop_mm)

hchart(dout, type = "sunburst")

hchart(dout, type = "treemap")
} # }
```
