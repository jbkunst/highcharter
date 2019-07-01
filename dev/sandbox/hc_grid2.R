library(dplyr)
data(diamonds, package = "ggplot2")
diamonds <- sample_n(diamonds, 1000)
options(highcharter.theme = hc_theme_smpl())

df <- diamonds %>%
  group_by(cut) %>% 
  do(sprk = hcboxplot(.$price, by = .$color,
                      outliers = FALSE, name = first(.$cut)))

htmltools::browsable(hw_grid(df$sprk))


df <- diamonds %>%
  group_by(cut) %>% 
  do(sprk = hchart(density(.$price), area = TRUE))

htmltools::browsable(hw_grid(df$sprk, ncol = 1, rowheight = 300))


df <- diamonds %>%
  select(-color) %>% 
  group_by(cut) %>% 
  do(sprk = hchart(., "scatter", x = carat, y = price, group = clarity))

htmltools::browsable(hw_grid(df$sprk, rowheight = 400))

gr <- hw_grid(df$sprk, rowheight = 400)

htmlwidgets:::print.htmlwidget(gr)
