df <- data.frame(
  from = c("Brazil", "Brazil", "Poland"),
  to = c("Portugal", "Spain", "England")
)

hchart(df, "organization", hcaes(from = from, to = to)) %>% 
  hc_chart(inverted = TRUE)
