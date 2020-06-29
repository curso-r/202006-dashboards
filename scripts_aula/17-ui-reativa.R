library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "IMDB"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Informações gerais", tabName = "info"),
      menuItem("Orçamentos", tabName = "orcamento"),
      menuItem("Filmes", tabName = "filmes")
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
              uiOutput("select_generos")
            )
          )
        ),
        box(
          width = 12,
          footer = "Fonte: curso-r",
          plotOutput("serie_orcamento") %>% 
            shinycssloaders::withSpinner()
        )
      ),
      tabItem(
        tabName = "filmes",
        h1("Filmes"),
        box(
          width = 12,
          fluidRow(
            column(
              width = 6,
              selectInput(
                inputId = "diretor",
                label = "Selecione o diretor",
                choices = ""
              )
            ),
            column(
              width = 6,
              selectInput(
                inputId = "filme",
                label = "Selecione o filme",
                choices = ""
              )
            )
          )
        ),
        br(),
        valueBoxOutput('filme_orcamento', width = 6),
        valueBoxOutput('filme_receita', width = 6)
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
  
  output$select_generos <- renderUI({
    
    todos_os_generos <- imdb %>% 
      pull(generos) %>% 
      str_split("\\|", simplify = TRUE) %>% 
      as.character() %>% 
      unique() %>% 
      sort() 
    
    todos_os_generos <- todos_os_generos[todos_os_generos != ""]
    
    selectInput(
      inputId = "genero",
      label = "Selecione um gênero",
      choices = todos_os_generos
    )
  })
  
  output$serie_orcamento <- renderPlot({
    
    req(input$genero)

    imdb %>% 
      filter(
        str_detect(generos, input$genero)
      ) %>% 
      group_by(ano) %>% 
      summarise(
        orcamento_medio = mean(orcamento, na.rm = TRUE)
      ) %>% 
      ggplot() +
      geom_line(aes(x = ano, y = orcamento_medio))
    
  })
  
  updateSelectInput(
    session = session,
    inputId = "diretor",
    choices = sort(unique(imdb$diretor))
  )
  
  observe({
    
    filmes_do_diretor <- imdb %>%
      filter(diretor == input$diretor) %>%
      pull(titulo)

    updateSelectInput(
      session = session,
      inputId = "filme",
      choices = filmes_do_diretor
    )
  })
  
  output$filme_orcamento <- renderValueBox({
    orcamento <- imdb %>% 
      filter(
        titulo == input$filme
      ) %>% 
      pull(orcamento) %>% 
      scales::dollar()
    
    orcamento <- ifelse(is.na(orcamento), "Não disponível", orcamento)
    
    valueBox(
      value = orcamento,
      subtitle = "dólares",
      icon = icon("dolar-sign")
    )
  })
  
  output$filme_receita <- renderValueBox({
    receita <- imdb %>% 
      filter(
        titulo == input$filme
      ) %>% 
      pull(receita) %>% 
      scales::dollar()
    
    receita <- ifelse(is.na(receita), "Não disponível", receita)
    
    valueBox(
      value = receita,
      subtitle = "dólares",
      icon = icon("dolar-sign")
    )
  })
  
}


shinyApp(ui, server)