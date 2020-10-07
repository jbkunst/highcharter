# Download AAPL quotes from Yahoo.
aapl <- quantmod::getSymbols("AAPL",
  src = "yahoo",
  from = "2020-01-01",
  auto.assign = FALSE
)

# Add some NA with SMA.
aapl$SMA <- runMean(aapl$AAPL.Close, 20)

#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Highcharter Shiny snippet."),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      "Here goes your sidebar."
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      highcharter::highchartOutput("distPlot", height = "auto")
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  output$distPlot <- highcharter::renderHighchart({
    hc <- highcharter::highchart(type = "stock", height = 500) %>%
      highcharter::hc_title(text = "RJSON test") %>%
      highcharter::hc_add_series(aapl, yAxis = 0, showInLegend = FALSE) %>%
      highcharter::hc_add_series(aapl$SMA, yAxis = 0, showInLegend = TRUE)
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
