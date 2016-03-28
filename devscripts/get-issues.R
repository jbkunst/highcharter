rm(list = ls())
library("dplyr")
library("purrr")
library("httr")

issues <- GET("https://api.github.com/repos/jbkunst/highcharter/issues",
              query = list(state = "closed", milestone = 1)) %>% 
  content() 

names(issues)

jsonview::json_tree_view(issues)

dfissues <- map_df(issues, function(x){
  data_frame(
    x$title,
    x$number,
    substr(x$body, 0, 100)
  )
})

dfissues
