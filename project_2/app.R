library(shiny)
source("helper_functions.R")

ui <- fluidPage(
  titlePanel("Visits of a given client and unemployment rate"),
  fluidRow(
    column(3,
           numericInput("ID", "Client File Number:", value = 0),
           textOutput("text1"),
           textOutput("text2"), hr(),
           textOutput("text3"), hr(),
           textOutput("text4"), hr(),
           textOutput("text5")),
    column(9, dataTableOutput(outputId = "summary.table"))
  ),
  hr(),
  fluidRow(
    column(12, plotOutput("unemp.visits"))
  )
)

server <- function(input, output) {
  output$unemp.visits <- renderPlot({
    plot.unemp.visits(input$ID)
  })
  output$summary.table <- renderDataTable({summary},
                                          options = list(pageLength = 10, searching = T, lengthChange = F))
  output$text1 <- renderText("If you know which Client's visits you would like to see, input their number.
                            Otherwise, you may procure a number by sorting the summary table by your
                            statistic of interest.")
  output$text2 <- renderText("For example, clicking `Bus Tickets` will list the bottom 5 recipients of
                             bus tickets and clicking again will list the top 5.")
  output$text3 <- renderText("`Client File Number` = 0 will return aggregated visits of all Clients.
                             Other invalid numbers will return the error
                             `$ operator is invalid for atomic vectors`.")
  output$text4 <- renderText("For Clients whose visits range across 2 years or less, the x-axis has breaks at every month.
                             For clients whose visits range across more than that, breaks are given at every year, with sub-breaks at every month.")
  output$text5 <- renderText("For the best user-experience, please use fullscreen.")
}

shinyApp(ui = ui, server = server)
