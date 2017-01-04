library(highcharter)
library(dplyr)
library(purrr)

set.seed(123)

n <- 10
 
df <- data_frame(
  lat = runif(n, -180, 180),
  lon = runif(n, -180, 180),
  z =  round(runif(n)*10) + 1,
  color = colorize(lat)
  )

sequences <- map2(1:n, df$z, function(x, y){ ifelse(x == 1:n, y, 0) })

df <- mutate(df, sequence = sequences)

df

hcmap() %>% 
  hc_add_series(data = df, type = "mapbubble",
                minSize = 0, maxSize = 15) %>% 
  hc_motion(enabled = TRUE, series = 1, labels = 1:n,
            loop = TRUE, autoPlay = TRUE, 
            updateInterval = 1000, magnet = list(step =  1))
