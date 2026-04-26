# Commons HOW TOs

This is a set of example to show (and remember) who to do usual needs.

Let’s set charts to work with.

``` r
library(highcharter)
library(dplyr)
data(penguins, package = "palmerpenguins")

set.seed(123)

penguins <- palmerpenguins::penguins
penguins <- penguins |> 
  filter(complete.cases(penguins)) |> 
  group_by(species) |> 
  sample_n(25) |> 
  ungroup() |> 
  select(flipper_length_mm, bill_length_mm, species)

glimpse(penguins)
```

    ## Rows: 75
    ## Columns: 3
    ## $ flipper_length_mm <int> 184, 191, 202, 190, 201, 193, 208, 190, 192, 196, 19…
    ## $ bill_length_mm    <dbl> 34.4, 41.4, 41.4, 36.0, 41.5, 37.8, 40.8, 38.1, 37.3…
    ## $ species           <fct> Adelie, Adelie, Adelie, Adelie, Adelie, Adelie, Adel…

``` r
hc <- hchart(penguins, "scatter", hcaes(x = flipper_length_mm, y = bill_length_mm, group = species)) 
hc
```

And:

``` r
preguins_grouped <- penguins |> 
  group_by(species) |> 
  summarise(flipper_length_mm_mean = mean(flipper_length_mm))

glimpse(preguins_grouped)
```

    ## Rows: 3
    ## Columns: 2
    ## $ species                <fct> Adelie, Chinstrap, Gentoo
    ## $ flipper_length_mm_mean <dbl> 191.16, 194.68, 216.00

``` r
hc2 <- hchart(preguins_grouped, "column", hcaes(x = species, y = flipper_length_mm_mean))
hc2
```

## Disabled inactive state

By default, when you hover over a series all the rest are hiding using
opacity. To avoid this behaviour you can set `opactiy = 1` in the
`series.states.inactive`:

``` r
hc |>
  hc_plotOptions(
    series = list(states = list(inactive = list(opacity = 1)))
    )
```

More info:
<https://api.highcharts.com/highcharts/plotOptions.series.states.inactive>.

Example:
<https://jsfiddle.net/gh/get/library/pure/highcharts/highcharts/tree/master/samples/highcharts/plotoptions/series-states-inactive->

## Axis Label Custom Order

Remember `hc2`. If we want a new order we can give the explicit order
using `hc_xAxis`:

``` r
lvls <- preguins_grouped |> 
  mutate(
    species = forcats::fct_relevel(species, "Gentoo", after  = 0)
  ) |> 
  pull(species) |> 
  levels()

hchart(preguins_grouped, "column", hcaes(x = species, y = flipper_length_mm_mean)) |> 
  hc_xAxis(categories = lvls)
```
