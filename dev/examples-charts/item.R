df <- data.frame(
  stringsAsFactors = FALSE,
  name = c("The Left", "Social Democratic Party",
           "Alliance 90/The Greens", "Free Democratic Party",
           "Christian Democratic Union", "Christian Social Union in Bavaria",
           "Alternative for Germany"),
  count = c(69, 153, 67, 80, 200, 46, 94),
  col = c("#BE3075", "#EB001F", "#64A12D", "#FFED00",
          "#000000", "#008AC5", "#009EE0"),
  abbrv = c("DIE LINKE", "SPD", "GRÜNE", "FDP", "CDU", "CSU", "AfD")
  )

hchart(
  df, "item", hcaes(name = name, y = count, label = abbrv),
  marker = list(symbol = "square"),
  name = "Representatives",
  showInLegend = TRUE
)

hchart(
  df,
  "item", 
  hcaes(name = name, y = count, label = abbrv, color = col),
  name = "Representatives",
  showInLegend = TRUE,
  size = "100%",
  center = list("50%", "75%"),
  startAngle = -100,
  endAngle  = 100
  ) %>% 
  hc_title(text = "Item chart with different layout") %>% 
  hc_legend(labelFormat = '{name} <span style="opacity: 0.4">{y}</span>')
