highchart() %>% 
  hc_add_series(
    data = c(7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6),
    type = "column"
    ) %>% 
  hc_title(
    text = "This is a title with <i>margin</i> and <b>Strong or bold text</b>",
    margin = 20,
    align = "left",
    style = list(color = "#22A884", useHTML = TRUE)
    )
