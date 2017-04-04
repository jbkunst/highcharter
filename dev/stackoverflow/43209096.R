highchart() %>% 
  hc_chart(type = "line") %>% 
  hc_yAxis(max = 12, min = 0) %>%
  hc_xAxis(categories = c(1, 1.7, 1, 0)) %>% 
  hc_add_series(data = list(
    list(sequence = c(1,1,1,1)),
    list(sequence = c(NA,2,2,2)),
    list(sequence = c(NA,NA,5,5)),
    list(sequence = c(NA,NA,NA,10))
  )) %>% 
  hc_motion(enabled = TRUE, labels = 1:4, series = 0)


df <- data.frame(xx=c(1, 1.7, 1, 0), yy=c(1, 2, 5, 10))


sequences <- map(seq(1:nrow(df)), function(i){ i <- 3
  
  df %>% 
    mutate(x = ifelse(row_number() > i, NA, xx)) %>% 
    mutate(y = ifelse(row_number() > i, NA, yy)) %>% 
    select(x, y)

})

highchart() %>% 
  hc_xAxis(categories = c(1, 1.7, 1, 0)) %>% 
  hc_add_series(data = list(sequence = sequences)) %>% 
  hc_motion(labels = 1:4, series = 0)

