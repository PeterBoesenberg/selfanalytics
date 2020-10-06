library(shiny)
library(data.table)
library(plotly)
source("R/Profile.R")
source("R/performance.R")

shinyServer(function(input, output) {
  profile <- profile_class$new()
  shares <- profile$shares
  performance <- performance_class$new() 
    
  performance$get_views_server("linkedin_views", output, shares)
  performance$get_likes_server("linkedin_likes", output, shares)
  performance$get_comments_server("linkedin_comments", output, shares)
  
  profile$get_refresh_server(input)
})
