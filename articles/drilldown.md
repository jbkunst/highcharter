# Drilldown

Drilldown is the concept of inspecting increasingly high resolution data
through clicking on chart items like columns, points or pie slices.

## Gapminder population

``` r

library(dplyr)
library(forcats)
library(purrr)
library(stringr)

data(gapminder, package = "gapminder")

gapminder2007 <- gapminder |>
  filter(year == max(year)) |>
  select(-year) |>
  mutate(pop = pop / 1e6) |>
  arrange(desc(pop))

gapminder_column <- gapminder2007 |>
  group_by(continent) |>
  summarise(
    lifeExp = weighted.mean(lifeExp, pop),
    gdpPercap = weighted.mean(gdpPercap, pop),
    pop = sum(pop)
  ) |>
  mutate_if(is.numeric, round) |>
  arrange(desc(pop)) |>
  mutate(continent = fct_inorder(continent))

gapminder_column
```

    ## # A tibble: 5 × 4
    ##   continent lifeExp gdpPercap   pop
    ##   <fct>       <dbl>     <dbl> <dbl>
    ## 1 Asia           69      5432  3812
    ## 2 Africa         55      2561   930
    ## 3 Americas       75     21603   899
    ## 4 Europe         78     25244   586
    ## 5 Oceania        81     32885    25

``` r

gapminder_drilldown <- gapminder2007 |>
  group_nest(continent) |>
  mutate(
    id = continent,
    type = "column",
    # in the drilldown we'll give the mapping via creating the columns
    data = map(data, mutate, name = country, y = pop),
    data = map(data, list_parse)
  )

gapminder_drilldown
```

    ## # A tibble: 5 × 4
    ##   continent data        id       type  
    ##   <fct>     <list>      <fct>    <chr> 
    ## 1 Africa    <list [52]> Africa   column
    ## 2 Americas  <list [25]> Americas column
    ## 3 Asia      <list [33]> Asia     column
    ## 4 Europe    <list [30]> Europe   column
    ## 5 Oceania   <list [2]>  Oceania  column

The data is ready. Now, in this example due the continents and countries
have the sames values (pop, lifeExp, …) we can use the same
`pointFormat` for the tooltips:

``` r

x <- c("Population (MM)", "Life expectancy at birth", "GDP per capita (US$)")
y <- c("{point.pop}", "{point.lifeExp}", "$ {point.gdpPercap}")

tt <- tooltip_table(x, y)

hchart(
  gapminder_column,
  "column",
  hcaes(x = continent, y = pop, name = continent, drilldown = continent),
  name = "Population",
  colorByPoint = TRUE
) |>
  hc_drilldown(
    allowPointDrilldown = TRUE,
    series = list_parse(gapminder_drilldown)
  ) |>
  hc_tooltip(
    pointFormat = tt, # "{point.name} {point.pop}"
    useHTML = TRUE,
    valueDecimals = 0
  ) |>
  hc_yAxis(
    title = list(text = "Population in millions (log scale)"),
    type = "logarithmic",
    minorTickInterval = 'auto'
  ) |>
  hc_xAxis(
    title = ""
  )
```

For a geographic example, [click Chile to explore its
regions](https://jkunst.com/highcharter/articles/maps.html#drill-down-from-south-america-to-chile).

## Pokémon types

Click a primary type to explore its secondary types. Area shows the
number of Pokémon.

``` r

library(highcharter)
library(dplyr)

counts <- pokemon |>
  count(type_1, type_2, type_1_color, name = "n") |>
  mutate(type_2 = coalesce(type_2, paste("Only", type_1)))

nodes <- data_to_hierarchical(counts, c(type_1, type_2), n)
palette <- setNames(pokemon$type_1_color, pokemon$type_1)
nodes <- lapply(nodes, function(node) {
  if (node$level == 1L) {
    node$color <- unname(palette[node$name])
  }
  node$name <- tools::toTitleCase(node$name)
  node
})

hchart(
  nodes,
  type = "treemap",
  name = "All Pokémon",
  allowTraversingTree = TRUE,
  dataLabels = list(
    style = list(
      fontFamily = "Shadows Into Light",
      fontWeight = "normal",
      fontSize = "15px",
      color = "contrast",
      textOutline = "none"
    )
  ),
  layoutAlgorithm = "squarified",
  levelIsConstant = FALSE,
  levels = list(list(level = 1, dataLabels = list(enabled = TRUE)))
) |>
  hc_title(
    text = "Pokémon by type",
    style = list(fontFamily = "Shadows Into Light", fontWeight = "normal")
  ) |>
  hc_size(height = 480)
```
