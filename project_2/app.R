library(shiny)
source("helper_functions.R")

ui <- fluidPage(
  titlePanel("Visits of a given client and unemployment rate"),
  fluidRow(
    column(3,
           numericInput("ID", "Client File Number:", value = 0),
           textOutput("text1"),
           textOutput("text2"),
           textOutput("text3")),
    column(9, dataTableOutput(outputId = "summary.table"))
  ),
  hr(),
  fluidRow(
    column(12, plotOutput("unemp.visits"))
  )
)

server <- function(input, output) {
  # output$vioPlot <- renderPlot({
  #   genPlot(input$cat)
  # })
  output$unemp.visits <- renderPlot({
    plot.unemp.visits(input$ID)
  })
  output$summary.table <- renderDataTable({summary},
                                          options = list(pageLength = 5, searching = F, lengthChange = F))
  output$text1 <- renderText("If you know which Client's visits you would like to see, input their number.
                            Otherwise, you may procure a number by sorting the summary table by your
                            statistic of interest.")
  output$text2 <- renderText("For example, clicking `Bus Tickets` will list the bottom 5 recipients of
                             bus tickets and clicking again will list the top 5.")
  output$text3 <- renderText("The x-axis of the graph below has major breaks at the beginning of each year
                             and minor breaks at the beginning of each quarter. That is, bars in the
                             first segment of each year represent the months Jan ~ Mar.")
}

shinyApp(ui = ui, server = server)
