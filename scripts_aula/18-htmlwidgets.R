library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "IMDB"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Informações gerais", tabName = "info"),
      menuItem("Bilheteria", tabName = "bilheteria"),
      menuItem("Filmes", tabName = "filmes")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "info",
        h1("Informações gerais dos filmes"),
        br(),
        fluidRow(
          infoBoxOutput(
            outputId = "num_filmes",
            width = 4
          ),
          infoBoxOutput(
            outputId = "num_diretores",
            width = 4
          ),
          infoBoxOutput(
            outputId = "num_atores",
            width = 4
          )
        ),
        h3("Top 10 lucros"),
        br(),
        fluidRow(
          column(
            width = 12,
            reactable::reactableOutput("tabela_lucros")
          )
        )
      ),
      tabItem(
        tabName = "bilheteria",
        h1("Analisando os orçamentos"),
        br(),
        box(
          width = 12,
          uiOutput("ui_genero")
        ),
        box(
          width = 6,
          plotOutput("serie_orcamento")
        ),
        box(
          width = 6,
          plotly::plotlyOutput("serie_receita")
        )
      ),
      tabItem(tabName = "filmes")
    )
  )
)

server <- function(input, output, session) {
  
  imdb <- read_rds("../dados/imdb.rds")
  
  output$ui_genero <- renderUI({
    generos <- imdb$generos %>% 
      paste(collapse = "|") %>% 
      stringr::str_split("\\|") %>% 
      unlist() %>% 
      unique() %>% 
      sort()
    
    selectInput(
      inputId = "generos",
      label = "Selecione um gênero",
      choices = generos
    )
  })
  
  output$serie_orcamento <- renderPlot({
    
    req(input$generos)
    
    imdb %>% 
      filter(str_detect(generos, input$generos)) %>% 
      group_by(ano) %>% 
      summarise(orcamento_medio = mean(orcamento, na.rm = TRUE)) %>% 
      filter(!is.na(orcamento_medio)) %>% 
      ggplot(aes(x = ano, y = orcamento_medio)) +
      geom_line()
  })
  
  output$serie_receita <- plotly::renderPlotly({
    
    req(input$generos)
    
    p <- imdb %>% 
      filter(str_detect(generos, input$generos)) %>% 
      group_by(ano) %>% 
      summarise(receita_media = mean(receita, na.rm = TRUE)) %>% 
      filter(!is.na(receita_media)) %>% 
      rename(Receita = receita_media) %>% 
      ggplot(aes(x = ano, y = Receita)) +
      geom_line() +
      theme_minimal()
    
    plotly::ggplotly(
      p, 
      tooltip = "all"
    ) 
    
  })
  
  output$num_filmes <- renderInfoBox({
    infoBox(
      title = "Número de filmes",
      value = nrow(imdb),
      icon = icon("film"),
      fill = TRUE
    )
  })
  
  output$num_diretores <- renderInfoBox({
    infoBox(
      title = "Número de diretores",
      value = n_distinct(imdb$diretor),
      fill = TRUE,
      icon = icon("hand-point-right")
    )
  })
  
  output$num_atores <- renderInfoBox({
    
    num_atores <- imdb %>% 
      select(starts_with("ator")) %>% 
      pivot_longer(cols = ator_1:ator_3) %>% 
      distinct(value) %>% 
      nrow()
    
    infoBox(
      title = "Número de atores",
      value = num_atores,
      fill = TRUE,
      icon = icon("user-friends")
    )
  })
  
  output$tabela_lucros <- reactable::renderReactable({
    imdb %>% 
      mutate(lucro = receita - orcamento) %>% 
      top_n(20, lucro) %>% 
      select(titulo, diretor, ano, lucro) %>% 
      arrange(desc(lucro)) %>% 
      mutate(lucro = scales::dollar(lucro)) %>% 
      reactable::reactable(
        striped = TRUE,
        highlight = TRUE,
        defaultPageSize = 20,
        filterable = TRUE
      )
  })

}

shinyApp(ui, server)