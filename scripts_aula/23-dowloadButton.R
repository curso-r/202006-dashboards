library(shiny)

ui <- fluidPage(
  downloadButton(
    outputId = "download",
    label = "Download da base"
  )
)

server <- function(input, output, session) {
  
  output$download <- downloadHandler(
    filename = "a.R",
    content = function(file) {
      file.copy(
        from = "02-output.R",
        to = file,
      )
    }
  )
}

shinyApp(ui, server)