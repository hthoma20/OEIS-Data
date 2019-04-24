#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
#library(rstudioapi)
#setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
#setwd('../')
#setwd('/run/media/qi/data/bigData/oeis/Qi')
source('../cluster_words.r')


# Define UI for application that draws a histogram
word.ui <- fluidPage(
   
   # Application title
   titlePanel("Visualization of Words in Sequence Comments Clustered by Sequence Frquency Similarity"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         sliderInput("k",
                     "Number of clusters:",
                     min = 2,
                     max = 200,
                     value = 60)
         ,selectInput('search',
                     'Search for word:',
                     wordlist,
                     selected = 'pi'),
         htmlOutput('found')
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         uiOutput("plots")
      )
   )
)

# Define server logic required to draw a histogram
word.server <- function(input, output) {
  plotCount <- reactive({
    req(input$k)
    as.numeric(input$k)
  })
  plotHeight <- reactive(300*ceiling(plotCount()/3))
  
  output$found <- renderUI({
    if(input$search %in% wordlist){
      wordnum <- which(wordlist == input$search)
      HTML(paste(head(wordlist[order(dis.mat[wordnum,])], n=50), sep = '<br>'))
    }
  })
  
  numcolors <- 3
  output$wordclouds <- renderPlot({
    req(plotCount())
    k = plotCount()
    par(mfrow=c(ceiling(k/3), 3))
    clus <- cutree(hitre, k=k)
    
    for (i in 1:k) {
      wordclus <- freq[freq$word %in% wordlist[clus==i]]
      wordclus <- wordclus[order(wordclus$oeis, decreasing = F)]
      pal <- rep(brewer.pal(numcolors+1, 'Blues')[-1], each = ceiling(100 / numcolors))[100:1]
      wordcloud::wordcloud(wordclus$word, wordclus$oeis,#*wordclus$brown, 
                           colors = rep_len(pal, nrow(wordclus)), 
                           ordered.colors = T, random.order = F, max.words = 30)
    }
  })
  
  output$plots <- renderUI({
    plotOutput("wordclouds", height = plotHeight())
  })
}

# Run the application 
#shinyApp(ui = ui, server = server)

