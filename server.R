library(shiny)
source("R/Profile.R")


shinyServer(function(input, output) {
  profile <- Profile$new()
  profile$read()
  print(profile$name)
})
