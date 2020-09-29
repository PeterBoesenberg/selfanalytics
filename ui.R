library(shiny)
library(plotly)
shinyUI(fluidPage(
  titlePanel("Self Analytics"),
  plotlyOutput("linkedin_performance")
))
