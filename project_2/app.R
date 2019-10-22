library(shiny)
source("helper_functions.R")

ui <- fluidPage(
  titlePanel("Visits of a given client and unemployment rate"),
  sidebarLayout(
    sidebarPanel(numericInput("ID", "Client File Number:", value = 1),
                 textOutput("selected_cat")),
    mainPanel(plotOutput("unemp.visits"))
  ) 
)

server <- function(input, output) {
  # output$vioPlot <- renderPlot({
  #   genPlot(input$cat)
  # })
  output$unemp.visits <- renderPlot({
    genPlot(input$ID)
  })
}

shinyApp(ui = ui, server = server)
