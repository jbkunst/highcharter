rm(list = ls())
library(highcharter)
library(tidyverse)
library(magrittr)
# example by @dimitris1ps
# https://dimitris1ps.github.io/hc_motion/

n <- 20
set.seed(123)
colors <- c("#d35400", "#2980b9", "#2ecc71", "#f1c40f", "#7f8c8d")
segments <- c("SegA", "SegB", "SegC", "SegD", "SegE")

seg <- data_frame(x = sample(0:30, n)) %>% 
  mutate(y = 10 + sample(0:20, n) + 0.2 * sin(sample(50:150, n)),
         y = round(y, 1),
         z = rep(sample(round((x*y) - median(x*y),2), length(segments)), n/length(segments)),
         name = rep(segments, n/length(segments)), color = rep(colors, length.out = n))

seg

seg <- seg %>% 
  group_by(name) %>% 
  mutate(key = 1,
         key = cumsum(key),
         x = cumsum(x),
         y = cumsum(y)) %>% 
  ungroup() %>%
  mutate(x = x/key,
         y = y/key)

seg

seg1 <- seg %>% filter(key==1) %>% select(-key)
seg2 <- seg %>%
  group_by(name) %>%
  do(sequence = list_parse(select(., x = x, y = y, z = z, color = color)))

seg2 %>% 
  pull(sequence) %>% 
  first()
  

bubble <- left_join(seg1, seg2, by = "name")

####################
dfs <- lapply(unique(seg$name), function(x){
  df <- seg[seg$name==x, ] %>% select(xx=x, yy=y, name, color)
  df$key <- 0
  df <- lapply(1:dim(df)[1], function(y){ df$key <- df$key+y; df}) %>% do.call(rbind, .)
  df %<>% group_by(key, name, color) %>% mutate(key2=1, key2=cumsum(key2)) %>% ungroup %>% 
    mutate(yy=ifelse(key<key2, NA, yy))
  
  df1 <- df %>% filter(key==1) %>% select(-key)
  df2 <- df %>% group_by(key2) %>% do(sequence = list_parse(select(., y = yy, color=color))) %>% ungroup
  df <- left_join(df1, df2, by="key2")
  df %<>% select(xx, yy, name, color, sequence)
  df
})



hchart(bubble[, -6], type = "bubble", hcaes(x = x, y = y, size = z, color=color))

hchart(bubble, type = "bubble", hcaes(x = x, y = y, size = z, color=color)) %>% 
  hc_motion(enabled = TRUE, series = 0, startIndex = 0, labels = paste("<br>Some Label", 1:4)) %>% 
  hc_xAxis(min=4, max=26) %>% hc_yAxis(min=10, max=30)


highchart() %>%
  hc_add_series(data = data.frame(x = c(8, 4, 10, 11), y = c(28.2, 27.1, 24.7, 21.475)),
                type = "line", hcaes(x = x, y = y))


highchart() %>%
  hc_add_series(data = dfs[[1]], type = "line", hcaes(x = xx, y = yy)) %>% 
  hc_motion(enabled = TRUE, series = 0, startIndex = 0,
            labels = paste("<br>Some Label", 1:4)) %>% 
  hc_xAxis(min = 4, max = 12) %>%
  hc_yAxis(min = 20, max = 30)


# highchart() %>% 
hchart(bubble, type = "bubble", hcaes(x = x, y = y, size = z, color=color)) %>%
  hc_add_series(data = dfs[[1]], type = "line", hcaes(x = xx, y = yy, color=color),
                dashStyle='dot',  marker=list(radius=3), color=dfs[[1]]$color[1]) %>%
  hc_add_series(data = dfs[[2]], type = "line", hcaes(x = xx, y = yy, color=color),
                dashStyle='dot',  marker=list(radius=3), color=dfs[[2]]$color[1]) %>%
  hc_add_series(data = dfs[[3]], type = "line", hcaes(x = xx, y = yy, color=color),
                dashStyle='dot',  marker=list(radius=3), color=dfs[[3]]$color[1]) %>%
  hc_add_series(data = dfs[[4]], type = "line", hcaes(x = xx, y = yy, color=color),
                dashStyle='dot',  marker=list(radius=3), color=dfs[[4]]$color[1]) %>%
  hc_add_series(data = dfs[[5]], type = "line", hcaes(x = xx, y = yy, color=color),
                dashStyle='dot',  marker=list(radius=3), color=dfs[[5]]$color[1]) %>%
  hc_motion(enabled = TRUE, series = c(0, 1, 2, 3, 4, 5), 
            startIndex = 0, labels = paste("<br>Some Label", 1:4)) %>% 
  hc_xAxis(min=floor(min(seg$x)-2), max=ceiling(max(seg$x)+2)) %>% 
  hc_yAxis(min=floor(min(seg$y)-2), max=ceiling(max(seg$y)+2))


dfs[[1]] %>% 
  pull(sequence) %>% 
  last()
