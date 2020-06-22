library(shiny)

ui <- fluidPage(
  "Histograma da distribuição normal",
  sliderInput(
    inputId = "num",
    label = "Selecione o tamanho da amostra",
    min = 1,
    max = 1000, 
    value = 100
  ),
  textInput(inputId = "titulo", label = "Título do gráfico"),
  actionButton(inputId = "atualizar", "Gerar gráfico"),
  plotOutput(outputId = "hist"),
  "Tabela com sumário",
  tableOutput(outputId = "sumario")
)

server <- function(input, output, session) {
  
  amostra <- eventReactive(input$atualizar, {
    rnorm(input$num)
  })
  
  meu_titulo <- eventReactive(input$atualizar, {
    input$titulo
  })
  
  output$hist <- renderPlot({
    hist(amostra(), main = meu_titulo())
  })
  
  output$sumario <- renderTable({
    data.frame(
      media = mean(amostra()),
      dp = sd(amostra()),
      min = min(amostra()),
      max = max(amostra())
    )
  })
  
}

shinyApp(ui, server)