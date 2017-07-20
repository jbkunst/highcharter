library(tidyverse)
library(highcharter)


cc <- read_delim("2016-01-04 34.77
2016-01-05 34.91
2016-01-06 35.01
2016-01-07 35.33
2016-01-08 35.59
2016-01-11 35.92", delim = " ", col_names = FALSE)

names(cc) <- c("date", "Data")

cc

highchart(type = "stock") %>%
  hc_plotOptions(
    spline = list( 
      lineWidth = 2,
      dataLabels = list(
        enabled = TRUE,
        formatter = JS( '
                        function() {
                        if (this.point.x == this.series.data.length - 1) {
                        return this.y + "%";
                        }
                        return "";
                        }')
        
        ))) %>%
  hc_yAxis_multiples(
    list(top = "0%" , height = "100%", title = list(text = "test"))
  ) %>%  
  hc_add_series(cc$Data, type = "spline", yAxis = 0)

devtools::session_info()
