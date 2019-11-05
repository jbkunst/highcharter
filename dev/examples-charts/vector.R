x <- seq(5, 100, by = 5)

df <- expand.grid(x = x, y = x) %>% 
  mutate(
    l = 200 - (x + y),
    d = (x + y)/200 * 360
  )

hchart(df, "vector", hcaes(x, y, length = l, direction = d),
       color = "black", name = "Sample vector field")  %>% 
  hc_yAxis(min = 0, max = 100)
