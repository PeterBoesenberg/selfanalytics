library(shiny)
library(plotly)
source("R/performance.R")
source("R/Profile.R")

performance <- performance_class$new() 
profile <- profile_class$new()
shinyUI(fluidPage(
  includeCSS("www/layout.css"),
  titlePanel("Self Analytics"),
  h1("Connect to LinkedIn Data"),
  textOutput("shares_count"),
  div(class = "flex",
      profile$get_refresh_ui()
      )
  ,
  div(class = "flex",
    performance$get_views_ui("linkedin_views"),
    performance$get_likes_ui("linkedin_likes"),
    performance$get_comments_ui("linkedin_comments"),
  )
))

