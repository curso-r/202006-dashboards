library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "Teste"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Teste", tabName = "teste")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem("teste")
    )
  )
)

server <- function(input, output, session) {

  output$imagem <- renderImage({
    
    list(
      src = "", # url da imagem
      alt = "" # texto associado a imagem (descrição)
    )
    
  })
  
}

shinyApp(ui, server)



# Pasta temporária

caminho <- tempdir()

readr::write_csv(mtcars, paste0(caminho, "/mtcars.csv"))

readr::read_csv("/var/folders/j7/ywl_7qj92c77rt6gfm5zvgmw0000gn/T//Rtmpm9CqRE/mtcars.csv")
