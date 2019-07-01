highchart() %>% 
  hc_xAxis(categories = citytemp$month) %>% 
  hc_add_series(name = "Tokyo", data = sample(1:12)) %>% 
  hc_credits(
    enabled = TRUE,
    text = "htmlwidgets.org",
    href = "http://www.htmlwidgets.org/"
    )
