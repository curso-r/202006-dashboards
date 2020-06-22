library(shiny)

imdb <- read_rds("../dados/imdb.rds")

ui <- fluidPage(
  sliderInput(
    inputId = "anos",
    label = "Selecione o intervalo de anos",
    min = 0,
    max = 2.2,
    value = 1,
    step = 0.1,
    sep = "",
    format = "####,#"
  ),
  tableOutput(outputId = "tabela")
)

server <- function(input, output, session) {
  
  # output$tabela <- renderTable({
  #   imdb %>% 
  #     filter(ano %in% input$anos[1]:input$anos[2]) %>% 
  #     select(titulo, ano, diretor, receita, orcamento) %>% 
  #     mutate(lucro = receita - orcamento) %>%
  #     top_n(20, lucro) %>% 
  #     arrange(desc(lucro)) %>% 
  #     mutate_at(vars(lucro, receita, orcamento), ~ scales::dollar(.x))
  # })
  
}

shinyApp(ui, server)