library(purrr)

data <- tbl_df(data)

data %>% count(group)

xuniques <- sort(unique(data$x))
maxx <- max(data$x)

length(xuniques)

dataadd <- map_df(unique(data$group), function(g){ # g <- "rx=Lev, adhere=1"
  
  datag <- filter(data, group == g)
  xgrup <- datag$x
  xlack <- setdiff(xuniques, xgrup)
  xgrup <- unique(c(0L, xgrup, maxx))
  
  map_df(2:length(xgrup), function(place) { # place <- 12
    
    xlp <- xlack[xgrup[place- 1] < xlack & xlack < xgrup[place]]
    
    if(length(xlp) == 0)
      return(NULL)
    
    daux <- datag %>% filter(x == xgrup[place- 1]) %>% select(-x)
    
    if(nrow(daux) > 0) {
      return(cbind(data_frame(x = xlp), daux))
    } else {
      NULL
    }
    
  })
  
  
})


data <- bind_rows(data, dataadd)
distinct(bind_rows(data, dataadd))
