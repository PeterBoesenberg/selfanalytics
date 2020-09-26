library(shiny)

shinyUI(fluidPage(
  titlePanel("Self Analytics"),

  sidebarLayout(
    sidebarPanel(
      div("asdads"),
      sliderInput("bins",
        "Number of bins:",
        min = 1,
        max = 50,
        value = 30
      )
    ),

    mainPanel(
      div("bla")
    )
  )
))
