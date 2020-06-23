library(shiny)
library(shinydashboard)

tagList(
  selectInput(
    inputId = "var1",
    label = "Selecione uma variável!!!!!!",
    choices = names(mtcars[,-1])
  ),
)

ui <- dashboardPage(
  skin = "purple",
  dashboardHeader(
    title = "IMDB"
  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Informações gerais", tabName = "info"),
      menuItem("Orçamentos", tabName = "orcamentos"),
      menuItem("Receitas", tabName = "receitas")
    )
  ),
  dashboardBody(
    selectInput(
      inputId = "var1",
      label = "Selecione uma variável!!!!!!",
      choices = names(mtcars[,-1])
    ),
    tabItems(
      tabItem(
        tabName = "info",
        fluidRow(
          column(
            width = 4,
            offset = 4,
            h2("Informações gerais dos filmes"),
            selectInput(
              inputId = "var2",
              label = "Selecione uma variável",
              choices = names(mtcars[,-1])
            )
          )
        )
      ),
      tabItem(
        tabName = "orcamentos",
        fluidRow(
          column(
            width = 12,
            h2("Analisando os orçamentos")
          )
        ),
        fluidRow(
          column(
            width = 12,
            box(
              width = 6,
              title = "Meu primeiro box",
              solidHeader = TRUE,
              collapsible = TRUE,
              status = "success",
              column(
                width = 6,
                selectInput(
                  inputId = "var2",
                  label = "Selecione uma variável",
                  choices = names(mtcars[,-1])
                )
              )
            ),
            tabBox(
              tabPanel("Aba 1", "Elementos da aba 1"),
              tabPanel("Aba 2", "Elementos da aba 2"),
              tabPanel("Aba 3", "Elementos da aba 3"),
              side = "right"
            )
          )
        )
      ),
      tabItem(
        tabName = "receitas",
        h2("Analisando as receitas")
      )
    )
  )
)

server <- function(input, output, session) {

}

shinyApp(ui, server)