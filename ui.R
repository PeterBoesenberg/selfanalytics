library(shiny)
library(plotly)
shinyUI(fluidPage(
  includeCSS("www/layout.css"),
  titlePanel("Self Analytics"),
  div(class = "flex",
    plotlyOutput("linkedin_performance")
  )
))
