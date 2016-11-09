# require(devtools)
# install_github('likert', 'jbryer')
# install.packages("likert")
rm(list = ls())
library(highcharter)
library(likert)
library(tidyverse)
ls("package:likert")

data(pisaitems)

items28 <- pisaitems[, substr(names(pisaitems), 1, 5) == "ST24Q"]
items28 <- plyr::rename(items28, c(ST24Q01 = "I read only if I have to.", ST24Q02 = "Reading is one of my favorite hobbies.", 
                             ST24Q03 = "I like talking about books with other people.", ST24Q04 = "I find it hard to finish books.", ST24Q05 = "I feel happy if I receive a book as a present.", 
                             ST24Q06 = "For me, reading is a waste of time.", ST24Q07 = "I enjoy going to a bookstore or a library.", ST24Q08 = "I read only to get information that I need.", 
                             ST24Q09 = "I cannot sit still and read for more than a few minutes.", ST24Q10 = "I like to express my opinions about books I have read.", 
                             ST24Q11 = "I like to exchange books with my friends"))

items29 <- pisaitems[, substr(names(pisaitems), 1, 5) == "ST25Q"]
names(items29) <- c("Magazines", "Comic books", "Fiction", "Non-fiction books", "Newspapers")



object <- likert(items28)
object <- likert(items29)


hclikert <- function(object){
  
  results <- object$results
  lvls <- object$levels
  center <- (object$nlevels - 1)/2 + 1
  items <- unique(object$results$Item)
  
  data <- object$results %>% 
    tbl_df() %>% 
    gather(key, value, -Item) %>% 
    mutate(id = str_to_id(key),
           linkedTo = NA,
           value2 = value,
           value2 = ifelse(key %in% lvls[1:length(lvls) < center], -1*value, value))
  
  
  # exist center/neutral. In this case force a center (disagree)
  if(object$nlevels %% 2 == 1) {
    
    dataneutral <- data %>% 
      filter(key == lvls[center])
    
    data <- data %>% 
      filter(key != lvls[center])
    
    dataneutral2 <- bind_rows(
      dataneutral %>%
        mutate(value2 = value2/2, id = str_to_id(lvls[center])),
      dataneutral %>%
        select(-id) %>% 
        mutate(value2 =-value2/2, key = paste0(lvls[center], 2), linkedTo = str_to_id(lvls[center]))
    )
    
    data <- bind_rows(data, dataneutral2)
    
  }
  
  
  # to hc opts
  index <- seq(1, object$nlevels)
  index[index >= center] <- rev(index[index >= center])
  index
  
  if(object$nlevels %% 2 == 1) {
    index <- c(index, index[center])
  }
  
  
  series <- data %>% 
    mutate(key = factor(key, levels = lvls)) %>% 
    group_by(name = key, id, linkedTo) %>% 
    do(data = list_parse(select(., name = Item, y = value2))) %>% 
    ungroup() %>% 
    mutate(index = index,
           legendIndex = seq(1, nrow(.)),
           color = ifelse(!is.na(linkedTo), linkedTo, id),
           color = colorize(color))
  series 
  
  highchart() %>% 
    hc_chart(type = "bar") %>% 
    hc_plotOptions(series = list(stacking = "normal", borderWidth = 0)) %>% 
    hc_xAxis(type = "categorical", categories = items) %>% 
    hc_add_series_list(list_parse(series))
  
}

hclikert(likert(items28))
hclikert(likert(items29))
