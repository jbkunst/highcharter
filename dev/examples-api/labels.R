highchart() %>%
  hc_add_series(data = sample(1:12)) %>% 
  hc_labels(
    items = list(
      list(
        html = "<p>Some <b>important</b><br>text</p>" ,
        style = list(
          left = "150%",
          top = "150%"
        )
      )
    )
  )

