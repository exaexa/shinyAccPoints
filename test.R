#!/usr/bin/R -f
# Run this in shinyAccPoints directory for quicktesting the package

devtools::install()

library(shiny)
library(shinyAccPoints)

num.points <- 50000
alpha <- .1

ui <- fluidPage(
  titlePanel("accPoints test"),
  accPointsOutput('accPtsTest', width='30em', height='30em'),
  actionButton('remix',"Remix!")
)

server <- function(input, output) {
  data <- reactiveValues(
    x=rnorm(num.points),
    y=rnorm(num.points),
    col=sample(rainbow(100, alpha=alpha), num.points, replace=T)
  )

  observeEvent(input$remix, {
    data$x <- rnorm(num.points)
  })

  output$accPtsTest <- renderAccPoints(accPoints(
    x=data$x,
    y=data$y,
    xlim=c(-5,5),
    ylim=c(-5,5),
    col=data$col
  ))
}

shinyApp(ui, server)
