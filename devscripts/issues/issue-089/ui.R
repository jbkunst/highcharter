library(highcharter)
library(quantmod)
library(shinyBS)
library(shiny)
library(shinyjs)

shinyUI(fluidPage(
  useShinyjs(),
  bsButton("demobtn",type="action", label = NULL,class="btn-group btn-group-xs",icon=icon("plus")),
  column(3,HTML('<div id="ZoomST" style:>-</div>')),
  column(3,HTML('<div id="ZoomEND">-</div>')),
  column(3,HTML('<div id="ZoomFlag">-</div>')),
  column(3,HTML('<div id="DataPull">-</div>')),
  highchartOutput("hcontainer",height = "800px")  
))
