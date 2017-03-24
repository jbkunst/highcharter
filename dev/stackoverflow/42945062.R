library(highcharter)
library(dplyr)

years <- 5
nx <- 5
ny <- 6
df <- data.frame(year = rep(c(2016 + 1:years - 1), each = nx * ny),
                 xVar = rep(1:nx, times = years * ny),
                 yVar = rep(1:ny, times = years * nx),
                 heatVar = rnorm(years * nx * ny))

df_start <- df %>% 
  arrange(year) %>% 
  distinct(xVar, yVar, .keep_all = TRUE)

df_seqc <- df %>% 
  group_by(xVar, yVar) %>% 
  do(sequence = list_parse(select(., x = xVar, y = yVar, value = heatVar)))

data <- left_join(df_start, df_seqc)  
data

hchart(data, type = "heatmap", hcaes(x = xVar, y = yVar, value = heatVar))

hchart(data, type = "heatmap", hcaes(x = xVar, y = yVar, value = heatVar)) %>%
  hc_motion(enabled = TRUE, series = 0, startIndex = 0,
            labels = unique(df$year)) %>% 
  hc_legend(layout = "vertical", verticalAlign = "top", align = "right")



