library(shiny)
library(data.table)
library(plotly)
source("R/Profile.R")

shinyServer(function(input, output) {
  profile <- Profile$new()
  profile$read()
  print(profile$name)
  print(profile$shares)
  fwrite(profile$shares, "profile.csv")
  
  output$linkedin_performance <- renderPlotly(
    
    plot_ly(type = "bar", orientation = "h", name = "female")
  )
})
