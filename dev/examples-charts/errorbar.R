#' ## errorbar
example_dat <- tibble(
  Type = c("Human", "High-Elf", "Orc"), 
  key = c("World1", "World2", "World3")
  ) %>% 
  expand.grid() %>% 
  mutate(mean = runif(9, 5, 7)) %>% 
  mutate(sd = runif(9, 0.5, 1)) 

hchart(
  example_dat, 
  "column",
  hcaes(x = key, y = mean, group = Type),
  id = c("a", "b", "c")
  ) %>%
  
  hc_add_series(
    example_dat,
    "errorbar", 
    hcaes(y = mean, x = key, low = mean - sd, high = mean + sd, group = Type),
    linkedTo = c("a", "b", "c"),
    enableMouseTracking = TRUE,
    showInLegend = FALSE
    ) %>% 
  
  hc_plotOptions(
    errorbar = list(
      color = "black", 
      # whiskerLength = 1,
      stemWidth = 1
    ) 
  ) 
