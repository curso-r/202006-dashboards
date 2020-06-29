library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "IMDB"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Informações gerais", tabName = "info"),
      menuItem("Orçamentos", tabName = "orcamento"),
      menuItem("Receitas", tabName = "receitas")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "info",
        h1("Informações gerais"),
        infoBoxOutput(
          outputId = "num_filmes"
        ),
        infoBoxOutput(
          outputId = "num_diretores"
        ),
        # tags$img(src = ""),
        infoBoxOutput(
          outputId = "num_atores"
        )
        # imageOutput("imagem")
      ),
      tabItem(
        tabName = "orcamento",
        h1("Analisando orçamentos"),
        br(),
        box(
          width = 12,
          title = "Seletor de gênero",
          solidHeader = TRUE,
          status = "warning",
          fluidRow(
            column(
              width = 4,
              selectInput(
                inputId = "genero",
                label = "Selecione um gênero",
                choices = c("Action", "Comedy", "Romance")
              )
            ),
            column(
              width = 4,
              selectInput(
                inputId = "genero2",
                label = "Selecione um gênero",
                choices = c("Action", "Comedy", "Romance")
              )
            ),
            column(
              width = 4,
              sliderInput(
                inputId = "anos",
                label = "Escolha um período",
                min = 1916,
                max = 2016,
                value = c(2000, 2010)
              )
            )
          )
        ),
        box(
          width = 12,
          footer = "Fonte: curso-r",
          plotOutput("serie_orcamento")
        )
      ),
      tabItem(
        tabName = "receitas",
        h1("Analisando receitas")
      )
    )
  )
)

server <- function(input, output, session) {
  
  imdb <- readr::read_rds("../dados/imdb.rds")
  
  output$num_filmes <- renderInfoBox({
    infoBox(
      title = "Número de filmes",
      value = nrow(imdb),
      fill = TRUE,
      color = "red",
      icon = shiny::icon("hashtag")
    )
  })
  
  output$num_diretores <- renderInfoBox({
    
    num_dir <- imdb %>% 
      pull(diretor) %>% 
      unique() %>% 
      length()
    
    infoBox(
      title = "Número de diretores",
      value = num_dir,
      fill = TRUE,
      color = "red",
      icon = shiny::icon("hashtag")
    )
  })
  
  output$num_atores <- renderInfoBox({
    
    num_atores <- imdb %>%
      select(starts_with("ator")) %>%
      pivot_longer(cols = ator_1:ator_3) %>%
      pull(value) %>%
      unique() %>%
      length()
    
    infoBox(
      title = "Número de atores",
      value = num_atores,
      fill = TRUE,
      color = "red",
      icon = shiny::icon("hashtag")
    )
  })
  
  # output$imagem <- renderImage({
  #   list(src = "")
  # })
  
  output$serie_orcamento <- renderPlot({
    imdb %>% 
      filter(
        str_detect(generos, input$genero),
        ano %in% input$anos[1]:input$anos[2]
      ) %>% 
      group_by(ano) %>% 
      summarise(
        orcamento_medio = mean(orcamento, na.rm = TRUE)
      ) %>% 
      ggplot() +
      geom_line(aes(x = ano, y = orcamento_medio))
    
  })
  
}


shinyApp(ui, server)