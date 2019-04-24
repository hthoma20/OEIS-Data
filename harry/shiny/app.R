#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

source("../network_dashboard.r")


# Define UI for application that draws a histogram
network.ui <- fluidPage(
   
   # Application title
   titlePanel("Degrees of Separation Between Contributors"),
   
   fluidRow(
      column(4, plotOutput("netPlot")),
      column(8, plotOutput("distPlot"))
   ),
   
   fluidRow(
      column(4, br(), wellPanel(
          selectInput("v1_select", label = "Choose a user", 
                                   choices = V(user_network),
                                   selected= 1),
          selectInput("v2_select", label = "Choose another user",
                                   choices = V(user_network),
                                   selected= 1013)
      )),
      column(8, plotOutput("pathPlot"))
   )
)

# Define server logic required to draw a histogram
network.server <- function(input, output) {
   output$distPlot <- renderPlot({
      plot(mean_distances, main= "User connections fall off slowly later in the OEIS",
                           xlab= "Thousand Sequences",
                           ylab= "Average distance between users")
     
      abline(mean_distance_fit, col= "red")
   })
   
   output$netPlot <- renderPlot({
      plot(user_subnetwork, main= "A subgraph of the OEIS User Network")
   })
   
   output$pathPlot <- renderPlot({
      v1 <- V(user_network)[as.integer(input$v1_select)]
      v2 <- V(user_network)[as.integer(input$v2_select)]
      
      short_path <- shortest_paths(user_network, v1, v2)
      path_graph <- induced_subgraph(user_network, short_path[1]$vpath[[1]])
      
      plot(path_graph,
           main= paste("The shortest path from", names(v1), "to", names(v2), "in the OEIS"),
           edge.label= paste('A', edge_attr(path_graph, 'X1'), sep=""),
           edge.label.color= 'black')
   })
}

# Run the application 
#shinyApp(ui = network.ui, server = network.server)

