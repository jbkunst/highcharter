#' ## Word cloud
#'
#' Count words in the installed descriptions of three R packages. Each word's
#' weight is the number of times it appears across the descriptions.
packages <- c("highcharter", "htmlwidgets", "knitr")
descriptions <- vapply(
  packages,
  utils::packageDescription,
  character(1),
  fields = "Description"
)
words <- unlist(strsplit(tolower(descriptions), "[^a-z]+"))
stopwords <- c(
  "that",
  "this",
  "with",
  "from",
  "into",
  "which",
  "using",
  "such",
  "also",
  "their"
)
counts <- sort(
  table(words[nchar(words) > 3 & !words %in% stopwords]),
  decreasing = TRUE
)
terms <- data.frame(word = names(counts), count = as.integer(counts))

hchart(
  head(terms, 45),
  "wordcloud",
  hcaes(name = word, weight = count),
  name = "Occurrences",
  rotation = list(from = 0, to = 0),
  minFontSize = 10,
  maxFontSize = 42
) |>
  hc_colors(c("#134e4a", "#216c79", "#3375a0", "#8a572a", "#854665")) |>
  hc_title(text = "The words behind three R packages") |>
  hc_tooltip(pointFormat = "{point.weight} occurrences") |>
  hc_size(height = 340)
