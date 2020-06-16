library(shiny)

ui <- fluidPage(
  "Um histograma",
  plotOutput(outputId = "hist1"),
  plotOutput(outputId = "hist2")
)

server <- function(input, output, session) {
  
  output$hist2 <- renderPlot({
    
    hist(mtcars$wt)
    
  })
  
  output$hist1 <- renderPlot({
    
    hist(mtcars$mpg)
    
  })
  
  
}

shinyApp(ui, server)