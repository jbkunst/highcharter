UKvisits <- data.frame(
  origin = c("France", "Germany", "USA", "Irish Republic", "Netherlands", "Spain", "Italy",
             "Poland", "Belgium", "Australia",  "Other countries", rep("UK", 5)),
  visit = c(rep("UK", 11), "Scotland", "Wales", "Northern Ireland",  "England", "London"),
  weights = c(c(12,10,9,8,6,6,5,4,4,3,33)/100*31.8,  c(2.2,0.9,0.4,12.8,15.5)))

highchartzero() %>% 
  hc_add_series(
    UKvisits, 
    "networkgraph",
    hcaes(from = origin, to = visit, weight = weights),
    layoutAlgorithm = list(enableSimulation = TRUE)
    ) %>% 
  hc_add_dependency("modules/networkgraph.js")



# example 2 ---------------------------------------------------------------
data(package = "igraphdata")

data(karate, package = "igraphdata")

df <- igraph::as_data_frame(karate, what = "edges")

str(df)

highchartzero() %>% 
  hc_add_series(
    df, 
    "networkgraph",
    hcaes(from = from, to = to, weight = weight),
    layoutAlgorithm = list(enableSimulation = TRUE)
  ) %>% 
  hc_add_dependency("modules/networkgraph.js")
