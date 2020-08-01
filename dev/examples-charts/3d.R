data = data.frame(
  name = c('a', 'b', 'c', 'd', 'e', 'f'),
  y = c(4668, 3152, 1530, 452, 103, 104)
)

hc <- highchart() %>%
  hc_chart(type="pie") %>%
  hc_add_series(
    data = list_parse(data),
    innerSize = '50%'
  ) %>%
  hc_plotOptions(
    pie = list(
      dataLabels =
        list(enabled = TRUE,
             distance = '-25%',
             allowOverlap = FALSE)
    )
  )

hc
