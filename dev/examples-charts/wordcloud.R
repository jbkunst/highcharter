library(rvest)
texts <- read_html("http://www.htmlwidgets.org/develop_intro.html") %>% 
  html_nodes("p") %>% 
  html_text()

data <- texts %>% 
  map(str_to_lower) %>% 
  reduce(str_c) %>% 
  str_split("\\s+") %>% 
  unlist() %>% 
  data_frame(word = .) %>% 
  count(word, sort = TRUE) %>% 
  anti_join(tidytext::stop_words) %>% 
  head(50)

data

hchart(data, "wordcloud", hcaes(name = word, weight = n))
