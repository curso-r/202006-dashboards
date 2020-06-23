library(shiny)
library(tidyverse)

imdb <- readr::read_rds("../dados/imdb.rds")

ui <- fluidPage(
  sliderInput(
    inputId = "anos",
    label = "Selecione o intervalo de anos",
    min = 1916,
    max = 2016,
    value = 2000,
    step = 1,
    sep = ""
  ),
  tableOutput(outputId = "tabela")
)

server <- function(input, output, session) {
  
  output$tabela <- renderTable({
    imdb %>%
      filter(ano %in% input$anos) %>%
      select(titulo, ano, diretor, receita, orcamento) %>%
      mutate(lucro = receita - orcamento) %>%
      top_n(20, lucro) %>%
      arrange(desc(lucro)) %>%
      mutate_at(vars(lucro, receita, orcamento), ~ scales::dollar(.x))
  })
  
}

shinyApp(ui, server)