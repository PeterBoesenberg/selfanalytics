library(shiny)
library(plotly)
source("R/performance.R")
source("R/Profile.R")

performance <- Performance$new()
profile <- Profile$new()
shinyUI(fluidPage(
  includeCSS("www/layout.css"),
  includeCSS("www/refresh.css"),
  sidebarLayout(
    
    # Sidebar with a slider input
    sidebarPanel(
      titlePanel("Self Analytics"),
      hr(),
      h4("Step1: Connect to LinkedIn Data"),
      textOutput("shares_count"),
      div(
        class = "refresh",
        profile$get_refresh_ui()
      )
    ),
    mainPanel(
      div(
        class = "flex",
        performance$get_views_ui("linkedin_views"),
        performance$get_likes_ui("linkedin_likes"),
        performance$get_comments_ui("linkedin_comments"),
      )
    )
  )
  
  
))
