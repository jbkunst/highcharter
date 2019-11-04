df <- data.frame(
  stringsAsFactors = FALSE,
  name = c("The Left", "Social Democratic Party",
           "Alliance 90/The Greens", "Free Democratic Party",
           "Christian Democratic Union", "Christian Social Union in Bavaria",
           "Alternative for Germany"),
  count = c(69, 153, 67, 80, 200, 46, 94),
  col = c("#BE3075", "#EB001F", "#64A12D", "#FFED00", "#000000",
          "#008AC5", "#009EE0"),
  abbrv = c("DIE LINKE", "SPD", "GRÜNE", "FDP", "CDU", "CSU", "AfD")
  )

hchart(df, "item", hcaes(name = name, y = count, label = abbrv, color = col), 
       name = "Representatives") %>% 
  hc_plotOptions(
    series = list(
      dataLabels = list(
        enabled = TRUE,
        format = "{point.label}"
        ),
      center = list('50%', '60%'),
      size = '100%',
      startAngle = -100,
      endAngle = 100
    )
  ) %>% 
  hc_legend(
    enabled = TRUE,
    labelFormat = "{name} <span style='opacity: 0.4'>{y}</span>"
  )
