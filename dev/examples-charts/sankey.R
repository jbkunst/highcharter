UKvisits <- data.frame(
  origin = c("France", "Germany", "USA", "Irish Republic", "Netherlands", "Spain", "Italy",
           "Poland", "Belgium", "Australia",  "Other countries", rep("UK", 5)),
  visit = c(rep("UK", 11), "Scotland", "Wales", "Northern Ireland",  "England", "London"),
  weights = c(c(12,10,9,8,6,6,5,4,4,3,33)/100*31.8,  c(2.2,0.9,0.4,12.8,15.5)))

hchart(UKvisits, "sankey", hcaes(from = origin, to = visit, weight = weights))

energy <- paste0(
  "https://cdn.rawgit.com/christophergandrud/networkD3/",
  "master/JSONdata/energy.json"
) %>% 
  jsonlite::fromJSON()

dfnodes <- energy$nodes %>% 
  map_df(as.data.frame) %>% 
  mutate(id = row_number() - 1)

dflinks <- tbl_df(energy$links)

dflinks <- dflinks %>% 
  left_join(dfnodes %>% rename(from = value), by = c("source" = "id")) %>% 
  left_join(dfnodes %>% rename(to = value), by = c("target" = "id")) 

hchart(dflinks, "sankey", hcaes(from = from, to = to, weight = value))
