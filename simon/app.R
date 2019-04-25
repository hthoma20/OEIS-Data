#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
# number frequency in all sequences
counts <- readRDS(file = "all_counts2")
# the sequences without their name
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
        numericInput("number",
                     "Integer number to check",
                     value = 1),
        
        sliderInput("number.range",
                    "range around selected number to show",
                    min = 0,
                    max = 10000, # number of integers
                    value = 50,
                    step = 1
        ),
        sliderInput("yrange",
                    "Height of Histogram plot for frequency in entire set",
                    min = 10,
                    max = max(counts[,2]), # number of integers
                    value = 500,
                    step = 10
        ),
        
         sliderInput("sequence.range",
                     "range of sequences to count number frequency ",
                     min = 1,
                     max = dim(sequences)[1], #number of sequences
                     value = c(1, 100),
                     step = 10
                     ),
         
         
         sliderInput("show",
                     "Number of entries in table to show",
                     min = 1,
                     max = 200,
                     value = 20)
         
      ),
      
      # Show the plots
      mainPanel(
        plotOutput("Plot1"),
        plotOutput("Plot2"),
        DT::dataTableOutput("Table")
         
      )
   )
)

# Define server logic required to make the plots
freq.server <- function(input, output) {
   
   output$Plot1 <- renderPlot({
      # Counting the occurence of numbers per sequences
      count <- apply(sequences[input$sequence.range[1]:input$sequence.range[2],], MARGIN = 1, 
                     function(x) length(which(x==input$number)))
      plot(count, type = 'h', xlim= input$xrange, 
           main="The selected number counts per sequence",
           xlab = "Index of Sequence (1 = A000001)",
           ylab = "number of occurences"
      )
   })
   output$Plot2 <- renderPlot({
     # showing number occurence
     numbers.show = c(input$number - input$number.range, input$number + input$number.range)
     plot(counts, type = 'h', xlim= numbers.show, ylim = c(0, input$yrange),
          main= "Frequency of numbers in all sequences centered on selected number",
          xlab = "Integer number",
          ylab = "number of occurences in dataset"
     )
   })
   
   # Table to show numbers
   output$Table <- DT::renderDataTable({
     DT::datatable(counts, colnames = c('Integer', 'Occurence'),
                   rownames = FALSE, class = 'cell-border stripe',
                   options = list(orderClasses = TRUE, pageLength = input$show,
                                  dom = 'tp'),
                   filter= "top",
                   caption = "Occurences of Integers in entire table"
     )
   })
}

# Run the application 
shinyApp(ui = freq.ui, server = freq.server)

