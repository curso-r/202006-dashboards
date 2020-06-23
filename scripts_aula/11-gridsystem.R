quadrado <- function(text = "") {
  div(
    style = "background: purple; height: 100px; text-align: center; color: white; font-size: 24px;", 
    text
  )
}

ui <- fluidPage(
  fluidRow(
    column(
      width = 4,
      quadrado(1),
      quadrado(2)
    )
  ),
  fluidRow(
    column(
      width = 12,
      quadrado(3)
    )
  )
)

server <- function(input, output, session) {}

shinyApp(ui, server)