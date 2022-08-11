#' ## vector
#' 
#' 
x <- seq(5, 95, by = 5)

df <- expand.grid(x = x, y = x) %>% 
  mutate(
    length = 200 - (x + y),
    direction = (x + y)/200 * 360
  )

hchart(
  df,
  "vector",
  hcaes(x, y, length = length, direction = direction),
  color = "black", 
  name = "Sample vector field"
  )  %>% 
  hc_yAxis(min = 0, max = 100)
