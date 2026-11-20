#' ## Word cloud
#'
#' Count words across the chart descriptions in R's installed graphics manual.
manual <- tools::Rd_db("graphics")
descriptions <- vapply(
  manual,
  function(topic) {
    description <- Filter(
      function(x) identical(attr(x, "Rd_tag"), "\\description"),
      topic
    )
    paste(unlist(description), collapse = " ")
  },
  character(1)
)

words <- unlist(strsplit(tolower(descriptions), "[^a-z]+"))
stopwords <- c(
  "this",
  "that",
  "with",
  "from",
  "which",
  "given",
  "used",
  "using",
  "will",
  "function",
  "functions",
  "specified",
  "their",
  "other",
  "these"
)
counts <- sort(
  table(words[nchar(words) > 3 & !words %in% stopwords]),
  decreasing = TRUE
)
terms <- head(
  data.frame(name = names(counts), weight = as.integer(counts)),
  160
)

hchart(
  terms,
  "wordcloud",
  name = "Mentions",
  placementStrategy = "center",
  spiral = "rectangular",
  rotation = list(from = -45, to = 45, orientations = 5),
  minFontSize = 8,
  maxFontSize = 42,
  style = list(fontFamily = "Georgia, serif", fontWeight = "bold")
) |>
  hc_colors(c("#143f50", "#276774", "#347c74", "#9a5435", "#614876")) |>
  hc_title(text = "The language of R graphics") |>
  hc_tooltip(
    valueDecimals = 0,
    pointFormat = "{point.weight:,.0f} mentions in the graphics manual"
  ) |>
  hc_size(height = 420)
