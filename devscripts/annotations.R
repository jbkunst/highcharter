n <- 50
df <- data.frame(x = rnorm(n), y = rnorm(n))
ds <- list_parse2(df)

df2 <- data.frame(x = c(1, -1, -1, 1)*2,
                  y = c(1, 1, -1, -1)*2,
                  text = paste("Quadrant", letters[1:4]))

ds2 <- list_parse(df2)


highchart() %>% 
  hc_add_theme(hc_theme_538()) %>% 
  hc_add_series(data = ds, name = "data", type = "scatter") %>% 
  hc_add_series(data = ds2,
                name = "annotations",
                type = "scatter",
                color = "transparent",
                showInLegend = FALSE,
                enableMouseTracking = FALSE,
                dataLabels = list(enabled = TRUE, y = 10, format = "{point.text}",
                                  style = list(fontSize = "20px",
                                               color =  'rgba(0,0,0,0.70)')))
