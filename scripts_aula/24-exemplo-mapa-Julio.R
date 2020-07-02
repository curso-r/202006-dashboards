library(shiny)
library(leaflet)
library(tidyverse)
library(sf)

## Dados de covid obtidos do Ministério da Saúde
tabela_covid <- readr::read_rds("tabela_covid.rds")

## shapefile das UFs
# state_shapes <- geobr::read_state()
# readr::write_rds(state_shapes, "state_shapes.rds")
state_shapes <- readr::read_rds("state_shapes.rds")

da_map <- state_shapes %>%
  inner_join(tabela_covid, c("abbrev_state" = "estado"))

#' monta o mapa
#'
#' @param coluna obitos_novos ou casos_novos
montar_mapa <- function(coluna) {
  pal <- leaflet::colorNumeric("Greens", domain = range(da_map[[coluna]]))
  da_map %>%
    mutate(col = .data[[coluna]]) %>%
    leaflet() %>%
    addTiles() %>%
    addPolygons(
      layerId = ~abbrev_state,
      fillColor = ~pal(col),
      fillOpacity = 0.8,
      color = "black",
      weight = 1,
      label = ~abbrev_state
    ) %>%
    addLegend(
      pal = pal,
      values = ~col,
      opacity = 0.7,
      title = NULL,
      position = "bottomright"
    )
}

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      selectInput(
        "tipo",
        "Escolha o tipo",
        choices = c("Mortes" = "obitos_novos",
                    "Casos" = "casos_novos"),
        selected = "Mortes"
      )
    ),
    mainPanel(
      leafletOutput("mapa"),
      tableOutput("tabela")
    )
  )
)

server <- function(input, output, session) {

  output$mapa <- renderLeaflet({

    event_list <- input$mapa_shape_click

    # se clicar no estado, ele dá um zoom no estado
    if (!is.null(event_list)) {
      montar_mapa(input$tipo) %>%
        setView(event_list$lng, event_list$lat, zoom = 5)
    } else {
      # se não, apenas monta o mapa
      montar_mapa(input$tipo)
    }
  })

  output$tabela <- renderTable({

    event_list <- input$mapa_shape_click
    req(event_list)

    da_map %>%
      filter(abbrev_state == event_list$id) %>%
      as.data.frame() %>%
      select(-geom)

  })

}

shinyApp(ui, server)
