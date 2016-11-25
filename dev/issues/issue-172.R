library(highcharter)
library(purrr)
library(dplyr)
library(htmltools)

Category <- c("Furniture","Furniture","Furniture","Furniture",
              "Office Supplies","Office Supplies", "Office Supplies", "Office Supplies",
              "Office Supplies", "Office Supplies", "Office Supplies", "Office Supplies",
              "Office Supplies", "Technology","Technology","Technology","Technology")

SubCategory <- c("Bookcases","Chairs","Furnishings","Tables","Appliances","Art","Binders","Envelopes", 
                 "Fasteners","Labels","Paper","Storage",  "Supplies", "Accessories","Copiers","Machines",
                 "Phones")

sales <- c(889222.51,920892.65,239840.16,445823.93,614737.91,225594.68,281494.68,104903.88,50156.06,44269.30,
           150113.36,692903.08,152196.19,463383.33,965899.78,458655.43,1005525.38)

mydf <- data.frame(Category,SubCategory,sales, color = colorize(Category))

categories_grouped <- map(unique(Category), function(x){
  list(
    name = x,
    categories = SubCategory[Category == x]
  )
})

hc <- highchart() %>% 
  hc_chart(type = "bar") %>% 
  hc_xAxis(categories = categories_grouped) %>% 
  hc_add_series(data = list_parse(select(mydf, y = sales, color = color)),
                showInLegend = FALSE)

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


