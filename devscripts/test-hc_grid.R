
library("highcharter")
library("dplyr", quietly = TRUE)
rm(list = ls())
data(economics_long, package = "ggplot2")

#' # Example I

grid <- hc_grid(
  hchart(mtcars %>% dist()),
  hchart(mtcars %>% dist() %>% hclust() %>% as.dendrogram()),
  hchart(mtcars %>% dist() %>% hclust() %>% ape::as.phylo()),
  ncol = 3
)

grid
# htmltools::browsable(grid2)

#' # Example II
#' 

df_with_charts2 <- economics_long %>% 
  group_by(variable) %>% 
  do(hc = {
    hc_add_series_times_values(highchart(height = 150), .$date, .$value, name =  unique(.$variable)) %>%
      hc_title(text = unique(.$variable)) %>% 
      hc_add_theme(hc_theme_ft())
  })


charts2 <- df_with_charts2$hc 

hc_grid(charts2, ncol = 2, nrow = 3)
# htmltools::browsable(charts2)



#' # Example III
df_with_charts <- economics_long %>% 
  group_by(variable) %>% 
  do(hc = hchart(.$value, name = unique(.$variable))) 

charts <- df_with_charts$hc

hc_grid(charts, ncol = 5)
# htmltools::browsable(charts) # in console


