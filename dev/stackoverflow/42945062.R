#+ warning=FALSE,message=FALSE
library(highcharter)
library(dplyr)
library(purrr)
  
years <- 10
nx <- 5
ny <- 6
df <- data_frame(year = rep(c(2016 + 1:years - 1), each = nx * ny),
                 xVar = rep(1:nx, times = years * ny),
                 yVar = rep(1:ny, times = years * nx))

df <- df %>% 
  group_by(xVar, yVar) %>% 
  mutate(heatVar = cumsum(rnorm(length(year))))

df_start <- df %>% 
  arrange(year) %>% 
  distinct(xVar, yVar, .keep_all = TRUE)
df_start

df_seqc <- df %>% 
  group_by(xVar, yVar) %>% 
  do(sequence = list_parse(select(., value = heatVar)))
df_seqc

data <- left_join(df_start, df_seqc)  
data

limits <- (unlist(data$sequence)) %>% 
{ c(min(.), max(.))}
limits

hc1 <- hchart(data, type = "heatmap", hcaes(x = xVar, y = yVar, value = heatVar))

hc2 <- hchart(data, type = "heatmap", hcaes(x = xVar, y = yVar, value = heatVar)) %>%
  hc_motion(enabled = TRUE, series = 0, startIndex = 0,
            labels = unique(df$year)) %>% 
  hc_legend(layout = "vertical", verticalAlign = "top", align = "right") %>% 
  hc_colorAxis(min = limits[1], max = limits[2])

hc2
