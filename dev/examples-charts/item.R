# "['The Left', 69, '#BE3075', 'DIE LINKE'],
# ['Social Democratic Party', 153, '#EB001F', 'SPD'],
# ['Alliance 90/The Greens', 67, '#64A12D', 'GRÜNE'],
# ['Free Democratic Party', 80, '#FFED00', 'FDP'],
# ['Christian Democratic Union', 200, '#000000', 'CDU'],
# ['Christian Social Union in Bavaria', 46, '#008AC5', 'CSU'],
# ['Alternative for Germany', 94, '#009EE0', 'AfD']" %>% 
#   str_split("\n") %>% 
#   unlist() %>% 
#   str_remove()

# 
#  %>% 
#   hchart("item", hcaes(name = Species, y = n, label = Species)) %>% 
#   hc_chart(type = "item")

# library(tidyverse)
# 
# highchartzero() %>% 
#   hc_add_dependency("modules/item-series.js") %>% 
#   hc_add_series(count(iris, Species), "item",  hcaes(name = Species, y = n, label = Species))


highchart() %>% 
  # hc_add_dependency("modules/item-series.js") %>% 
  hc_add_series(count(iris, Species), "item",  hcaes(name = Species, y = n, label = Species))
