library("rvest")
library("dplyr")
library("stringr")
library("sp")
library("purrr")


airports <- read_html("http://www.mapsofworld.com/usa/states/california/california-airports.html") %>% 
  html_table() %>% 
  .[[3]] %>% 
  tbl_df()


airports$Coordinates %>% 
  str_split(" ") %>% 
  str_extract_all("\\d+") %>% 
  map_df(function(e){
    data_frame(x = paste0(e[1], "d", e[2], "'", e[3], "\"", " ", "N"),
               y = paste0(e[4], "d", e[5], "'", e[6], "\"", " ", "W")) %>% 
      mutate(lon = x %>% char2dms %>% as.numeric,
             lat = y %>% char2dms %>% as.numeric)
  })

coords <- airports$Coordinates %>% 
  map_df(function(c){
    #c <- sample(airports$Coordinates, size = 1)
    d <- unlist(str_split(c, " ")) 
    
    d %>% 
      str_extract_all("\\d+") %>% 
      map_chr(function(x){
        paste0(x[1], "d", x[2], "'", x[3], "\"")
      }) %>% 
      paste(str_extract_all(c2, "\\w$")) %>% 
      data_frame(x = .[1], y = .[2])
  })


"32-14-23 N" %>%
  sub('-', 'd', .) %>%
  sub('-', '\'', .) %>%
  sub(' ', '" ', .) %>%
  char2dms %>%
  as.numeric
