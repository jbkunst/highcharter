highcharts_demo() %>% 
  hc_chart(backgroundColor = "#161C20") %>% 
  hc_xAxis(
    gridLineColor = "#424242", gridLineWidth =  1,
    minorGridLineColor = "#424242", minoGridLineWidth =  0.5,
    tickColor = "#424242", minorTickColor = "#424242",
    lineColor = "#424242"
  ) %>% 
  hc_yAxis(
    gridLineColor = "#424242", gridLineWidth =  1,
    minorGridLineColor = "#424242", minoGridLineWidth =  0.5,
    tickColor = "#424242", minorTickColor = "#424242",
    lineColor = "#424242"
  ) %>% 
  hc_legend(
    itemStyle = list(
      color = "#424242"
    )
  ) %>% 
  hc_add_theme(hc_theme_smpl())
