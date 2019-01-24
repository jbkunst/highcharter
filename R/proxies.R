#' Proxy
#' 
#' highcharter proxy example.
#' 
#' @param proxy An object of class \code{highchartProxy} as returned by \code{\link{highchartProxy}}.
#' @param ... Whatever, this is not being used.
#' 
#' @examples 
#' library(shiny)
#' 
#' data("diamonds", package = "ggplot2")
#' 
#' ui <- fluidPage(
#'   actionButton("polar", "Polar"),
#'   highchartOutput("hc")
#' )
#' 
#' server <- function(input, output, session){
#'   output$hc <- renderHighchart({
#'     hchart(diamonds$price, color = "#B71C1C", name = "Price") %>% 
#'       hc_title(text = "You can zoom me")
#'   })
#'   
#'   observeEvent(input$polar, {
#'     highchartProxy("hc") %>% 
#'       hc_hide(
#'         list(chart = list(polar = TRUE))
#'       )
#'   })
#' }
#' 
#' if(interactive()) shinyApp(ui, server)
#' 
#' @export
hc_hide <- function(proxy, ...){
  
  if (!"highchartProxy" %in% class(proxy)) 
    stop("must pass highchartProxy object", call. = FALSE)
  
  data <- list(
    id = proxy$id,
    opt = list(...)
  )
  
  proxy$session$sendCustomMessage("highchart_hide", data)
  
  return(proxy)
}
