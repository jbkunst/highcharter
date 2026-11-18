#' ## Venn intersections
#'
#' These illustrative counts describe overlapping skills among 100 analysts.
#' Pairwise intersections include the ten analysts who use all three tools.

skills <- tibble::tibble(
  sets = list(
    list("R"),
    list("Python"),
    list("SQL"),
    list("R", "Python"),
    list("R", "SQL"),
    list("Python", "SQL"),
    list("R", "Python", "SQL")
  ),
  name = c(
    "R",
    "Python",
    "SQL",
    "R and Python",
    "R and SQL",
    "Python and SQL",
    "All three"
  ),
  value = c(57, 48, 45, 20, 22, 18, 10)
) |>
  dplyr::mutate(label = ifelse(lengths(sets) == 1L, name, as.character(value)))

hchart(
  skills,
  "venn",
  name = "Analysts",
  opacity = 1,
  borderColor = "#ffffff",
  borderWidth = 2,
  dataLabels = list(
    format = "{point.label}",
    style = list(
      fontSize = "11px",
      color = "#ffffff",
      fontWeight = "normal",
      textOutline = "2px #253238"
    )
  )
) |>
  hc_colors(c("#216595", "#367444", "#936816")) |>
  hc_tooltip(pointFormat = "{point.name}: {point.value} analysts") |>
  hc_caption(
    text = "Illustrative skills of 100 analysts; intersection counts include all three tools.",
    style = list(fontSize = "11px")
  ) |>
  hc_size(height = 310)
