UKvisits <- data.frame(
  origin = c(
    "France",
    "Germany",
    "USA",
    "Irish Republic",
    "Netherlands",
    "Spain",
    "Italy",
    "Poland",
    "Belgium",
    "Australia",
    "Other countries",
    rep("UK", 5)
  ),
  visit = c(
    rep("UK", 11),
    "Scotland",
    "Wales",
    "Northern Ireland",
    "England",
    "London"
  ),
  weights = c(
    c(12, 10, 9, 8, 6, 6, 5, 4, 4, 3, 33) / 100 * 31.8,
    c(2.2, 0.9, 0.4, 12.8, 15.5)
  )
)

hchart(UKvisits,
       "sankey",
       hcaes(from = origin, to = visit, weight = weights))

data(diamonds, package = "ggplot2")

diamonds2 <- dplyr::select(diamonds, cut, color, clarity)

data_to_sankey(diamonds2)

hchart(data_to_sankey(diamonds2), "sankey", name = "diamonds")
