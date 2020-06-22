library(dplyr)
library(ggplot2)


df <- readRDS("../atividade4/covid.rds")
data = df[,c('estado','casosAcumulado','data')]
sum(is.na(data))
data = na.omit(data)
#veriicar se os "NaN" foram tratados
sum(is.na(data["estado"]))
uf = unique(data["estado"])

library(shiny)

ui <- fluidPage(
  "Registros de novos casos de Covid-19 por estado ao longo do tempo",
  selectInput(
    inputId = "estado",
    label = "Selecione um estado",
    choices = uf[order(uf$estado),]
  ),
  plotOutput("line")
)

server <- function(input, output, session) {
  output$line <- renderPlot({
    new_data = data[data['estado']==input$estado,c("estado","casosAcumulado","data")]
    new_data = new_data[order(new_data$data),]
    new_data = data.frame(group_by(new_data,data)%>%summarise(Total=sum(casosAcumulado)))
    ggplot(data=new_data, aes(x=new_data[,"data"], y=new_data[,"Total"]))+
      geom_line(color='blue',size=2)+
      xlab("2020")+
      ylab("Número de casos")+
      ggtitle(paste("Número de caso de covid-19 para o estado de",input$estado))+
      theme_bw()
  })
  
}

shinyApp(ui, server)