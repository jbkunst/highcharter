library(tidyverse)
library(rvest)

icons <- readLines("https://raw.githubusercontent.com/onface/font-awesome/master/less/variables.less")
icons <- icons[str_detect(icons, "@fa-var")]

iconsnames <- str_extract(icons, ".*:")
iconsnames <- str_replace_all(iconsnames, "@fa-var-|:", "")

iconcode <-  str_extract(icons, ":.*$")
iconcode <-  str_extract(iconcode, "[[:alnum:]]+")

icons <- read_html("https://fontawesome.com/v4.7.0/cheatsheet/") %>% 
  html_nodes("div.col-md-4.col-sm-6.col-lg-3")

dficons <- purrr::map_df(icons, function(divico){ # divico <- sample(icons, size = 1)[[1]]
  txt <- html_text(divico)
  data_frame(class = str_extract(txt, "fa-.*"),
             name = str_replace(class, "fa-", ""),
             unicode = str_extract(txt, "\\[.*\\]") %>% str_replace_all("\\[|\\]", ""))
}) 

fontawesomeicos <- tibble(name = iconsnames, code = iconcode) %>% 
  left_join(dficons, by = "name")

saveRDS(fontawesomeicos, file = "inst/extdata/faicos.rds", compress = "xz")
