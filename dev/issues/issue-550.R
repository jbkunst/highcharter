set.seed(2019)
d <- data.frame(
  month = rep(1:120, 50),
  sim = rep(1:50, each = 120),
  n = runif(120 * 50)
)

library(highcharter)


system.time({
  h <- hchart(d, 
              type = 'line', 
              hcaes(y = n,
                    x = month,
                    group = sim)
  ) %>% 
    hc_legend(enabled = FALSE)
  print(h)
})

system.time({
  h <- hchart(d, 
              type = 'line', 
              hcaes(y = n,
                    x = month,
                    group = sim),
              fast = TRUE) %>% 
    hc_legend(enabled = FALSE)
  print(h)
})


# example 2 ---------------------------------------------------------------
library(tidyverse)
library(highcharter)

N <- 100000
NG <- 10


d <- tibble(
  r = round(rnorm(N), 5),
  g = rep(1:NG, length.out = N)
) %>% 
  group_by(g) %>% 
  mutate(r = cumsum(r), id = row_number()) 


# system.time({
#   h <- hchart(d, type = "line",  hcaes(x = id, y = r, group = g)) %>% 
#     hc_legend(enabled = FALSE)
#   print(h)
# })

system.time({
  h <- hchart(d, type = "line",  hcaes(x = id, y = r, group = g), fast = TRUE) %>% 
    hc_legend(enabled = FALSE) %>% 
    hc_tooltip(sort = TRUE, table = TRUE)
  print(h)
})


d2 <- d %>% 
  select(y = r, x = id, group = g)


system.time({
  h <- hchart(d2, type = "line",  hcaes(x = x, y = y, group = group), fast = TRUE) %>% 
    hc_legend(enabled = FALSE) %>% 
    hc_tooltip(sort = TRUE, table = TRUE)
  print(h)
})


