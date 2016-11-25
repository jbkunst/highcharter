l1 <- list(a = 1, b = list(x = 1, y = 1))
l2 <- list(a = 2, b = list(z = 2))
l3 <- list(a = 2, b = list(x = 3))

rlist::list.merge(l1,l2,l3)

library("magrittr")
library("rlist")

hc <- highchart() 
hc <- hc %>% hc_title(text = "foo")

hc$x$hc_opts

hc <- hc %>% hc_title(style = list(color = "red"))
hc$x$hc_opts

hc






