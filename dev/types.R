library(dplyr)
library(stringr)
library(purrr)

n <- 5

set.seed(123)

colors <- c("#d35400", "#2980b9", "#2ecc71", "#f1c40f", "#2c3e50", "#7f8c8d")
colors2 <- c("#000004", "#3B0F70", "#8C2981", "#DE4968", "#FE9F6D", "#FCFDBF")


df <- data.frame(x = seq_len(n) - 1) %>% 
  mutate(
    y = 10 + x + 10 * sin(x),
    y = round(y, 1),
    z = (x*y) - median(x*y),
    e = 10 * abs(rnorm(length(x))) + 2,
    e = round(e, 1),
    low = y - e,
    high = y + e,
    value = y,
    name = sample(fruit[str_length(fruit) <= 5], size = n),
    color = rep(colors, length.out = n),
    segmentColor = rep(colors2, length.out = n)
  )

df

create_hc <- function(t) {
  
  dont_rm_high_and_low <- c("arearange", "areasplinerange",
                            "columnrange", "errorbar")
  
  is_polar <- str_detect(t, "polar")
  
  t <- str_replace(t, "polar", "")
  
  if(!t %in% dont_rm_high_and_low) df <- df %>% select(-e, -low, -high)
  
  
  highchart() %>%
    hc_title(text = paste(ifelse(is_polar, "polar ", ""), t),
             style = list(fontSize = "15px")) %>% 
    hc_chart(type = t,
             polar = is_polar) %>% 
    hc_xAxis(categories = df$name) %>% 
    hc_add_series(df, name = "Fruit Consumption", showInLegend = FALSE) 
  
}

hcs <- c("line", "spline",  "area", "areaspline",
         "column", "bar", "waterfall" , "funnel", "pyramid",
         "pie" , "treemap", "scatter", "bubble",
         "arearange", "areasplinerange", "columnrange", "errorbar",
         "polygon", "polarline", "polarcolumn", "polarcolumnrange",
         "coloredarea", "coloredline")  %>% 
  map(create_hc) 

last(hcs)
