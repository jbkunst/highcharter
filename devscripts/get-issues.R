rm(list = ls())
library("dplyr")
library("purrr")
library("httr")

issues <- GET("https://api.github.com/repos/jbkunst/highcharter/issues",
              query = list(state = "closed", milestone = 3)) %>% 
  content() 

names(issues)

jsonview::json_tree_view(issues)

dfissues <- map_df(issues, function(x){
  data_frame(
    title = x$title,
    number = x$number,
    desc = substr(x$body, 0, 100)
  )
}) 

dfissues <- dfissues %>% 
  mutate(
    md_text = paste(
      "*",
      title ,
      " DESC ",
      desc,
      sprintf("(#%s).", number),
      "\n\n"
      )
    )


cat(dfissues$md_text)

