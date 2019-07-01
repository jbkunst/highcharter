#' From https://gist.github.com/jcheng5/c084a59717f18e947a17955007dc5f92
library(highcharter)
library(htmltools)

hc <- highchart() %>% 
  hc_chart(type = "column") %>% 
  hc_title(text = "MyGraph") %>% 
  hc_add_series(data = c(4, 14, 18, 5, 6, 5, 14, 15, 18)) %>%
  hc_add_series(data = c(6, 5, 14, 15, 18, 4, 14, 18, 5)) %>% 
  hc_xAxis(categories = list(
    list(
      name =  "Fruit",
      categories = list("Apple", "Banana", "Orange")
    ),
    list(
      name =  "Vegetable",
      categories = list("Carrot", "Potato", "Tomato")
    ),
    list(
      name = "Fish",
      categories = list("Cod", "Salmon", "Tuna")
    )
  ))

hc

dep <-  htmlDependency(
  name = "grouped-categories",
  version = "1.1.0",
  src = c(
    href = "http://blacklabel.github.io/grouped_categories"
  ),
  stylesheet = "css/styles.css",
  script = "grouped-categories.js"
)

hc$dependencies <- c(hc$dependencies, list(dep))

hc
