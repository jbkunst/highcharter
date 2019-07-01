rm(list = ls())
library(tidyverse)
library(httr)

issues <- GET("https://api.github.com/repos/jbkunst/highcharter/issues",
              query = list(state = "closed", milestone = 6)) %>% 
  content() 

names(issues)

# jsonview::json_tree_view(issues)
dfissues <- map_df(issues, function(x){
  data_frame(
    title = stringr::str_trim(x$title),
    number = x$number,
    desc = substr(x$body, 0, 120),
    categories = x$labels %>% map("name") %>% reduce(str_c, sep = " ", collapse = ", ")
  )
}) 

dfissues <- arrange(dfissues, categories)

dfissues %>% 
  count(categories)

dfissues <- dfissues %>% 
  mutate(
    md_text = paste(
      "*",
      categories, 
      title ,
      " DESC ",
      desc,
      sprintf("(#%s).", number),
      "\n\n"
      )
    )

cat(dfissues$md_text)

