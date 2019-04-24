#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

counts <- readRDS(file = "all_counts2")
sequences <- readRDS(file = "sequences")
library(shiny)
library(DT)
# Define UI for application that draws a histogram
freq.ui <- fluidPage(
   
   # Application title
   titlePanel("OEIS"),
   
   # Sidebar  
   sidebarLayout(
      sidebarPanel(
        
         sliderInput("xrange",
                     "range of sequences to check ",
                     min = 1,
                     max = dim(sequences)[1], #number of sequences
                     value = c(1, 100)),
         
         numericInput("number",
                      "Integer number to check",
                      #min = min(unlisted.sequences),
                      #max = max(unlisted.sequences),
                      value = 1),
         
         sliderInput("show",
                     "Number of entries in table to show",
                     min = 1,
                     max = 200,
                     value = 20)
         
      ),
      
      
      # Show the plots
      mainPanel(
        plotOutput("Plot"),
        DT::dataTableOutput("Table")
         
      )
   )
)

# Define server logic required to make the plots
freq.server <- function(input, output) {
   
   output$Plot <- renderPlot({

      count <- apply(sequences[input$xrange[1]:input$xrange[2],], MARGIN = 1, 
                     function(x) length(which(x==input$number)))
      plot(count, type = 'h', xlim= input$xrange, 
           main="The checked number counts per sequence",
           xlab = "Index of Sequence (1 = A000001)",
           ylab = "number of occurences"
      )
   })
   output$Table <- DT::renderDataTable({
     DT::datatable(counts, colnames = c('Integer', 'Occurence'),
                   rownames = FALSE, class = 'cell-border stripe',
                   options = list(orderClasses = TRUE, pageLength = input$show,
                                  dom = 't'),
                   filter= "top",
                   caption = "Occurences of Integers in entire table"
     )
   })
}

# Run the application 
shinyApp(ui = freq.ui, server = freq.server)

