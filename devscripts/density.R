x <- rnorm(10000)
y <- rexp(10000)

hcdensity(x) %>%
  hc_add_series_density(y)

# and
hcdensity(density(x)) %>% # not the correct usage but its possible.
  hc_add_series_density(density(y))

# or
hchart(density(x)) %>%
  hc_add_series_density(density(y))

highcharter:::hchart.density


inherits(density(x), "density")
inherits(x, "numeric")

hchart(hist(x, probability = TRUE)) %>% 
  hc_add_series_density(y)
  
