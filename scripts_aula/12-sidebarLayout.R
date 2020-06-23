library(shiny)

ui <- fluidPage(
  titlePanel(title = "Título do aplicativo"),
  sidebarLayout(
    sidebarPanel(
      width = 3,
      fluidRow(h2("Título da barra lateral")),
      fluidRow(
        column(
          width = 6,
          sliderInput(
            "num1",
            "Número de observações:",
            min = 0,
            max = 1000,
            value = 500
          )
        ),
        column(
          width = 6,
          sliderInput(
            "num1",
            "Número de observações:",
            min = 0,
            max = 1000,
            value = 500
          )
        )
      ),
      fluidRow(
        sliderInput(
          "num3",
          "Número de observações:",
          min = 0,
          max = 1000,
          value = 500
        )
      )
    ),
    mainPanel(
      width = 9,
      fluidRow(
        column(
          width = 6,
          h3("Título do corpo do aplicativo"),
          mainPanel(
            plotOutput("hist1")
          )
        ),
        column(
          width = 6,
          h3("Título do corpo do aplicativo"),
          mainPanel(
            plotOutput("hist2")
          )
        )
      )
    )
  )
)

server <- function(input, output, session) {
  
  output$hist1 <- renderPlot({
    amostra <- rnorm(input$num1)
    hist(amostra)
  })
  
  output$hist2 <- renderPlot({
    amostra <- rnorm(input$num1)
    hist(amostra)
  })
  
}

shinyApp(ui, server)