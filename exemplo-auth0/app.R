library(shiny)
library(tidyverse)
library(leaflet)
library(auth0)

cetesb <- read_rds("cetesb.rds")

ui <- fluidPage(
  leafletOutput(outputId = "mapa", height = 500),
  tableOutput("estacao"),
  logoutButton()
)

server <- function(input, output, session) {
  
  output$mapa <- renderLeaflet({
  
    cetesb %>% 
      distinct(estacao_cetesb, lat, long) %>% 
      leaflet() %>% 
      addTiles(urlTemplate = ) %>% 
      # addProviderTiles('Esri.WorldImagery') %>% # Sugestões
      # addProviderTiles("CartoDB.PositronOnlyLabels") %>% 
      addMarkers(
        lng = ~long,
        lat = ~lat, 
        popup = ~estacao_cetesb,
        layerId = ~estacao_cetesb, 
        clusterOptions = markerClusterOptions()
      )
    
  })
  
  output$estacao <- renderTable({
    req(input$mapa_marker_click$id)
    
    cetesb %>% 
      filter(estacao_cetesb == input$mapa_marker_click$id) %>% 
      group_by(poluente) %>% 
      summarise(media_poluente = mean(concentracao, na.rm = TRUE))
    
  })
  
}
# shinyApp(ui, server)
# options(shiny.port = 8080)
shinyAppAuth0(ui, server)


