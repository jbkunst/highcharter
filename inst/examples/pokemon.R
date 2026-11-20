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

label_style <- list(fontFamily = "Shadows Into Light", fontSize = "15px")

hchart(
  nodes,
  type = "treemap",
  name = "All Pokémon",
  allowTraversingTree = TRUE,
  breadcrumbs = list(
    buttonTheme = list(style = label_style),
    separator = list(style = label_style)
  ),
  dataLabels = list(
    style = c(
      label_style,
      list(fontWeight = "normal", color = "contrast", textOutline = "none")
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
  hc_tooltip(style = label_style) |>
  hc_size(height = 480)
