library(highcharter)
tmp_dtf <- data.frame( TimePeriod=  as.Date(c('2014-09-01','2015-09-01','2016-09-01')),
                       Year = c(2014,2015,2016),
                       Variable = 'Overnight trips',
                       Value=c(31409141, 35557245, 37553039) ,
                       CAGR = c(NA, 13.2, 5.6)) 

tmp_value <- c(31.4, 35.6, 37.6)

### only show % in dataLabel if value not null
fn <- "function(){
if (this.y != null) {
  return this.y +'%';
} else {
  return null;}
}"

## create the highchart
hc <- highchart() %>%
  hc_chart( style =  list( fontFamily = "Calibri" ), zoomType = 'xy') %>%
  hc_yAxis_multiples( list( opposite = T, title = list(text='Annual change'), labels = list( format = '{value}%'), min = 0, max = 50),
                      list( title =list(text='Value'),  min = 0, labels = list( format =  '{value}M' ) ))  %>%
  hc_add_series(data = tmp_value, ## different rounding rule for different variables 
                dataLabels = list(enabled = T),
                name = 'Value',
                showInLegend = F,
                color =  "#006272",
                type = "line",
                yAxis = 1) %>%
  hc_add_series(data =  tmp_dtf$CAGR , 
                dataLabels = list(enabled = T, 
                                  formatter = JS(fn)#,
                                  #format = '{y}%'
                ),
                name = 'Annual change',
                showInLegend = F,
                color =  "#006272",
                type = "column",
                yAxis = 0,
                tooltip = list(valueSuffix = '%'),
                pointWidth = 40) %>%
  #hc_add_series( type = 'line', data = round(tmp_dtf$Value) ) %>%
  hc_title( text = 'Overnight trips' ) %>%
  hc_xAxis( categories = tmp_dtf$Year, crosshair = T ) %>%
  hc_tooltip( shared = T ) %>%
  hc_exporting( enabled = T ) 

hc

export_hc(hc, filename = '~/test' )
