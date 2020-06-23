library(shiny)

ui <- navbarPage(
  title = "Shiny com navbarPage",
  tabPanel(
    title = "Análise descritiva",
    selectInput(
      inputId = "var",
      label = "Selecione uma variável",
      choices = names(mtcars[,-1])
    ),
    selectInput(
      inputId = "var2",
      label = "Selecione uma variável",
      choices = names(mtcars[,-1])
    ),
    plotOutput("grafico_disp")
  ),
  navbarMenu(
    title = "Resultados dos modelos",
    tabPanel(
      "Regressão linear",
      selectInput(
        inputId = "var3",
        label = "Selecione uma variável",
        choices = names(mtcars[,-1])
      ),
      plotOutput("grafico_disp2")
    ),
    tabPanel(
      "Árvores de decisão",
      fluidPage(
        titlePanel("Resultados"),
        sidebarPanel(
          selectInput(
            inputId = "var4",
            label = "Selecione uma variável",
            choices = names(mtcars[,-1])
          )
        ),
        mainPanel(
          plotOutput("grafico_disp3")
        )
      )
    ),
    tabPanel("Florestas aleatórias")
  )
)

server <- function(input, output, session) {
  output$grafico_disp <- renderPlot({
    mtcars %>% 
      select(mpg, xvar = input$var) %>% 
      ggplot(aes(x = xvar, y = mpg)) +
      geom_point() +
      labs(x = input$var)
  })
  
  output$grafico_disp2 <- renderPlot({
    mtcars %>% 
      select(mpg, xvar = input$var3) %>% 
      ggplot(aes(x = xvar)) +
      geom_histogram() +
      labs(x = input$var)
  })
  
  output$grafico_disp3 <- renderPlot({
    mtcars %>% 
      select(mpg, xvar = input$var3) %>% 
      ggplot(aes(x = xvar)) +
      geom_histogram() +
      labs(x = input$var)
  })
  
}

shinyApp(ui, server)