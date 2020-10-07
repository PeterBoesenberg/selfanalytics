library(shiny)
library(data.table)
library(plotly)
source("R/Profile.R")
source("R/performance.R")

shinyServer(function(input, output) {
  profile <- Profile$new()
  profile$read(output)
  performance <- Performance$new()

  performance$get_views_server(output, profile$shares)
  performance$get_likes_server(output, profile$shares)
  performance$get_comments_server(output, profile$shares)

  profile$get_refresh_server(input, output)
})
