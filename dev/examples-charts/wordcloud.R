#' ## Word cloud
#'
#' Count words in the installed descriptions of three R packages. Each word's
#' weight is the number of times it appears across the descriptions.
packages <- c("highcharter", "htmlwidgets", "knitr")
descriptions <- vapply(packages, utils::packageDescription, character(1),
                       fields = "Description")
words <- unlist(strsplit(tolower(descriptions), "[^a-z]+"))
counts <- sort(table(words[nchar(words) > 3]), decreasing = TRUE)
terms <- data.frame(word = names(counts), count = as.integer(counts))

hchart(terms, "wordcloud", hcaes(name = word, weight = count))
