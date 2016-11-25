library(highcharter)

x <- cor(mtcars)

hchart(x)

hchart(x) %>% 
  hc_legend(layout = "vertical",
            align = "right",
            verticalAlign = "top")


hchart(x) %>% 
  hc_plotOptions(
    series = list(
      dataLabels = list(
        enabled = TRUE,
        formatter = JS("function(){
                       return Highcharts.numberFormat(this.point.value, 2);
                       }")
        )
      )
    )


hchart(volcano)
