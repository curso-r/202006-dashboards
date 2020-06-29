library(shiny)

ui <- fluidPage(
  selectInput(
    inputId = "select",
    label = "Selecione uma opcão",
    choices = c("mpg", "cyl")
  ),
  plotOutput("plot")
)

server <- function(input, output, session) {
  output$plot <- renderPlUTot({
    mtcars %>% 
      ggplot(aes_string(x = input$select, y = "wt")) +
      geom_point()
  })
}

shinyApp(ui, server)


