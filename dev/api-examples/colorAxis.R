hc <- hchart(volcano)

hc

hc %>% 
  hc_colorAxis(
    minColor = "#FFFFFF",
    maxColor = "#434348"
    )

hc %>% 
  hc_colorAxis(
    minColor = "#FFFFFF",
    maxColor = "#434348",
    type = "logarithmic"
    )


require("viridisLite")

n <- 5

stops <- data.frame(
  q = 0:n/n,
  c = substring(viridis(n + 1), 0, 7),
  stringsAsFactors = FALSE
  )

stops <- list_parse2(stops)

hc %>% 
  hc_colorAxis(stops = stops, max = 200)
