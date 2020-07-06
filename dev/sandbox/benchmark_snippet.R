library(microbenchmark)
library(quantmod)
library(magrittr)

options(highcharter.verbose = TRUE)
options(highcharter.debug = FALSE)
options(highcharter.rjson = TRUE)

aapl <- quantmod::getSymbols("AAPL",
  src = "yahoo",
  from = "2020-01-01",
  auto.assign = FALSE
)

# Add some NA with SMA.
aapl$SMA <- runMean(aapl$AAPL.Close, 20)

to_benchmark <- function() {
  hc <- highcharter::highchart(type = "stock", height = 500) %>%
    highcharter::hc_title(text = "RJSON test") %>%
    highcharter::hc_add_series(aapl, yAxis = 0, showInLegend = FALSE) %>%
    highcharter::hc_add_series(aapl$SMA, yAxis = 0, showInLegend = TRUE)
  return(hc)
}

# Chart with a data.frame
df <- data.frame(zoo::index(aapl), coredata(aapl))
hc_df <- function() {
  hc <- highcharter::highchart() %>%
    highcharter::hc_title(text = "RJSON test") %>%
    highcharter::hc_add_series(df$SMA, yAxis = 0, showInLegend = TRUE)
  return(hc)
}

hc <- to_benchmark()
 
res <- microbenchmark(
  rjson::toJSON(hc),
  shiny:::toJSON(hc),
  times = 10
)

print(res)


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
  titlePanel("Old Faithful Geyser Data"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      sliderInput("bins",
                  "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30)
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
    to_benchmark()
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
