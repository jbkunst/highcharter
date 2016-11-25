server = function(input, output, session) {
  
  values <- reactiveValues()
  values$Validate=0
  onclick("demobtn",values$Validate <- runif(1, 1, 10000))
  
  # Load the Data
  SPY <- getSymbols("SPY", from="2006-01-01", auto.assign=FALSE)
  SPY <- adjustOHLC(SPY)
  SPY.SMA.10 <- SMA(Cl(SPY), n=10)
  SPY.SMA.200 <- SMA(Cl(SPY), n=200)
  SPY.RSI.14 <- RSI(Cl(SPY), n=14)
  SPY.RSI.SellLevel <- xts(rep(70, NROW(SPY)), index(SPY))
  SPY.RSI.BuyLevel <- xts(rep(30, NROW(SPY)), index(SPY))
  
  
  # During initialization of the chart, sample and push only weekly data
  SPY<-c(SPY[.indexwday(SPY)==1],SPY[.indexwday(SPY)==5])
  SPY.SMA.10<-c(SPY.SMA.10[.indexwday(SPY.SMA.10)==1],SPY.SMA.10[.indexwday(SPY.SMA.10)==5])
  SPY.SMA.200<-c(SPY.SMA.200[.indexwday(SPY.SMA.200)==1],SPY.SMA.200[.indexwday(SPY.SMA.200)==5])
  SPY.RSI.14<-c(SPY.RSI.14[.indexwday(SPY.RSI.14)==1],SPY.RSI.14[.indexwday(SPY.RSI.14)==5])
  SPY.RSI.SellLevel<-c(SPY.RSI.SellLevel[.indexwday(SPY.RSI.SellLevel)==1],SPY.RSI.14[.indexwday(SPY.RSI.14)==5])
  SPY.RSI.BuyLevel<-c(SPY.RSI.BuyLevel[.indexwday(SPY.RSI.BuyLevel)==1],SPY.RSI.14[.indexwday(SPY.RSI.14)==5])
  
  # When user zooms-in (period < 365 days) load the entire data
  observeEvent(input$zoomstart,{
    if (is.null(input$zoomend)==FALSE){
      enddt<<-input$zoomend
      startdt<<-input$zoomstart
      SPY <- getSymbols("SPY", from="2006-01-01", auto.assign=FALSE)
      SPY <- adjustOHLC(SPY)
      SPY.SMA.10 <- SMA(Cl(SPY), n=10)
      SPY.SMA.200 <- SMA(Cl(SPY), n=200)
      SPY.RSI.14 <- RSI(Cl(SPY), n=14)
      SPY.RSI.SellLevel <- xts(rep(70, NROW(SPY)), index(SPY))
      SPY.RSI.BuyLevel <- xts(rep(30, NROW(SPY)), index(SPY))
      # shinyjs::html(id="DataPull", "-")
    } 
    values$Validate <- runif(1, 1, 10000)
  })
  
  
  hc_yAxis_multiples <- function(hc, ...) {
    
    hc$x$hc_opts$yAxis <- list(...)
    
    hc
  }
  
  
  output$hcontainer <- renderHighchart({
    values$Validate
    
    if (values$Validate==0)
      return()
    
    highchart() %>% 
      # create axis :)
      hc_yAxis_multiples(
        list(title = list(text = NULL), height = "65%", top = "0%"),
        list(title = list(text = NULL), height = "10%", top = "72.5%", opposite = TRUE),
        list(title = list(text = NULL), height = "15%", top = "85%")
      ) %>% 
      # series :D
      hc_add_series_ohlc(SPY, yAxis = 0, name = "SPY",smoothed=TRUE,forced=TRUE,groupPixelWidth=240) %>% 
      hc_add_series_xts(SPY$SPY.Volume, color = "gray", yAxis = 1, name = "Volume", type = "column",forced=TRUE,groupPixelWidth=240) %>% 
      hc_add_series_xts(SPY.RSI.14, yAxis = 2, name = "Osciallator",forced=TRUE,groupPixelWidth=240) %>% 
      hc_add_series_xts(SPY.RSI.SellLevel, color = "red", yAxis = 2, name = "Sell level", enableMouseTracking = FALSE,forced=TRUE,groupPixelWidth=240) %>% 
      hc_add_series_xts(SPY.RSI.BuyLevel, color = "blue", yAxis = 2, name = "Buy level", enableMouseTracking = FALSE,forced=TRUE,groupPixelWidth=240) %>% 
      # I <3 themes
      hc_add_theme(hc_theme_538())%>%
      hc_chart(zoomType = "xy") %>%
      hc_xAxis(
        events = list(
          setExtremes = JS('function(event){
                           document.getElementById("ZoomFlag").innerHTML = "Yes";
  }'),
        afterSetExtremes = JS('function(event){
                              if (document.getElementById("ZoomST").innerHTML!="-") {
                              var start = document.getElementById("ZoomST").innerHTML;
                              var end = document.getElementById("ZoomEND").innerHTML;
                              } else  {
                              var start = this.getExtremes()["min"];
                              var end = this.getExtremes()["max"];   
                              }
                              var timeDiff = Math.abs(parseInt(end) - parseInt(start));
                              var diffDays = Math.ceil(timeDiff / (1000 * 3600 * 24));
                              
                              if (document.getElementById("ZoomFlag").innerHTML=="Yes" && diffDays<365) {
                              if (document.getElementById("DataPull").innerHTML=="-"){
                              alert("Hello");
                              document.getElementById("DataPull").innerHTML="PullIt";
                              //document.getElementById("ZoomFlag").innerHTML = "-";
                              alert(document.getElementById("DataPull").innerHTML);
                              document.getElementById("ZoomST").innerHTML= this.getExtremes()["min"];
                              document.getElementById("ZoomEND").innerHTML= this.getExtremes()["max"];
                              alert(document.getElementById("ZoomST").innerHTML);
                              clearTimeout();
                              setTimeout(function(){
                              Shiny.onInputChange("zoomstart", start)
                              Shiny.onInputChange("zoomend", end)
                              }, 1);
                              } else {    clearTimeout();
                              document.getElementById("ZoomFlag").innerHTML = "-";
                              document.getElementById("ZoomST").innerHTML= "-";
                              document.getElementById("ZoomEND").innerHTML = "-";
                              alert(document.getElementById("ZoomFlag").innerHTML);
                              alert("This is when we need to chart to set extremes");
                              setTimeout(function(){
                              Highcharts.charts[0].xAxis[0].setExtremes(start,end);
                              }, 1);
                              }
                              } else {
                              alert(document.getElementById("ZoomFlag").innerHTML);
                              }
        }')
                      )
      )%>%
  hc_rangeSelector(buttons=list(
    list(type= 'month',count= 1,text= '1m'),
    list(type= 'month',count= 3,text= '3m'),
    list(type= 'month',count= 6,text= '6m'),
    list(type= 'ytd', text= 'YTD'),
    list(type= 'year',count= 1,text= '1Y'),
    list(type= 'year',count= 3,text= '3Y'),
    list(type= 'year',count= 5,text= '5Y'),
    list(type= 'year',count= 7,text= '7Y'),
    list(type= 'all',text= 'All')
  ))
})


}
