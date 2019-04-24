#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

setwd('../harry/shiny/')
source('app.R')

setwd('../../Qi/app/')
source('app.R')

setwd('../../simon')
source('app.r')

ui <- fluidPage(
  tabsetPanel(
    tabPanel("Word Cloud", fluid = TRUE, word.ui),
    tabPanel("Contributors Network", fluid = TRUE, network.ui),
    tabPanel("Integer Frequencies", fluid = TRUE, freq.ui),
    id = 'tabs'
  ), plotOutput('test')
)

server <- function(input, output) {
  word.server(input, output)
  network.server(input, output)
  freq.server(input, output)
}

# Run the application 
shinyApp(ui = ui, server = server)

