library(shiny)
library(data.table)
library(plotly)
source("R/Profile.R")

shinyServer(function(input, output) {
  # profile <- Profile$new()
  # profile$read()
  # print(profile$name)
  # print(profile$shares)
  # fwrite(profile$shares, "profile.csv")

  shares <- fread("profile.csv")
  print(shares)
  shares <- shares[, id:=nrow(shares):1]
  shares <- shares[is.na(comments), comments := 0]
  
  # shares <- shares[]
  output$linkedin_performance <- renderPlotly({
    plot <- plot_ly(shares, mode = 'lines')
    plot <- add_trace(plot, x = ~id, y = ~likes, name = "Likes")
    plot <- add_trace(plot, x = ~id, y = ~comments, name = "Comments")
    plot <- add_trace(plot, x = ~id, y = ~views, name = "Views")
    plot
  })
})
