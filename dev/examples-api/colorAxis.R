hchart(iris, "point", hcaes(Sepal.Length, Sepal.Width)) %>% 
  hc_colorAxis(
    minColor = "gray",
    maxColor = "yellow"
  )


hchart(iris, "point", hcaes(Sepal.Length, Sepal.Width, group = Species)) %>% 
  hc_colorAxis(
    minColor = "red",
    maxColor = "black"
  )

hchart(iris, "point", hcaes(Sepal.Length, Sepal.Width, colorValue = Sepal.Width*Sepal.Width)) %>% 
  hc_colorAxis(
    minColor = "red",
    maxColor = "black"
  )


hc <- hchart(volcano)

n <- 5

stops <- data.frame(
  q = 0:n/n,
  c = c("#440154", "#414487", "#2A788E", "#22A884", "#7AD151", "#FDE725"),
  stringsAsFactors = FALSE
  )

stops <- list_parse2(stops)

hc %>% 
  hc_colorAxis(stops = stops, max = 200)
