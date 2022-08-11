#' ## venn
#' 

highchart() %>% 
  hc_chart(type = "venn") %>% 
  hc_add_series(
    dataLabels = list(style = list(fontSize = "20px")),
    name = "Venn Diagram",
    data = list(
      list(
        name = "People who are<br>breaking my heart.",
        sets = list("A"), value = 5
        ),
      list(
        name = "People who are shaking<br> my confidence daily.",
        sets = list("B"), value = 5
        ),
      list(
        name = "Cecilia", sets = list("B", "A"), value = 1)
      )
  )

highchart() %>% 
  hc_chart(type = "venn") %>% 
  hc_add_series(
    name = "Euler Diagram",
    dataLabels = list(style = list(fontSize = "20px")),
    data = list(
      list(sets = list("A"), name = "Animals", value = 5),
      list(sets = list("B"), name = "Four Legs", value = 1),
      list(sets = list("B", "A"), value = 1),
      list(sets = list("C"), name = "Mineral", value = 2)
    )
  )
