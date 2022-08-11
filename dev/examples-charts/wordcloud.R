#' ## wordcloud
#' 
library(rvest)
library(tidytext)

data <- read_html("http://www.htmlwidgets.org/develop_intro.html") |> 
  html_nodes("p") |> 
  html_text() |> 
  map(str_to_lower) |> 
  reduce(str_c) |> 
  str_split("\\s+") |> 
  unlist() |> 
  tibble() |> 
  setNames("word") |> 
  count(word, sort = TRUE) |> 
  anti_join(tidytext::stop_words, by = "word") |> 
  head(60)

dplyr::glimpse(data)

hchart(data, "wordcloud", hcaes(name = word, weight = log(n)))
