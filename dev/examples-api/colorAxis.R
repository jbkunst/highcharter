hchart(iris, "point", hcaes(Sepal.Length, Sepal.Width)) %>% 
  hc_colorAxis(
    minColor = "gray",
    maxColor = "yellow"
  )


hchart(iris, "point", hcaes(Sepal.Length, Sepal.Width, group = Species)) %>% 
  hc_colorAxis(
    minColor = "gray",
    maxColor = "yellow"
  )




require("viridisLite")

hc <- hchart(volcano)
hc


n <- 5

stops <- data.frame(
  q = 0:n/n,
  c = substring(viridis(n + 1), 0, 7),
  stringsAsFactors = FALSE
  )

stops <- list_parse2(stops)

hc %>% 
  hc_colorAxis(stops = stops, max = 200)
