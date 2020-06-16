library(shiny)

ui <- fluidPage(
  "Um histograma",
  selectInput(
    inputId = "variavel1",
    label = "Selecione uma variável para o primeiro histograma",
    choices = names(mtcars),
    selected = "wt"
  ),
  selectInput(
    inputId = "variavel2",
    label = "Selecione uma variável para o segundo histograma",
    choices = names(mtcars)
  ),
  plotOutput(outputId = "hist1"),
  plotOutput(outputId = "hist2")
)

server <- function(input, output, session) {
  
  output$hist1 <- renderPlot({
    
    hist(mtcars[,input$variavel1])
    
  })
  
  output$hist2 <- renderPlot({
    
    hist(mtcars[,input$variavel2])
    
  })
  
}

shinyApp(ui, server)