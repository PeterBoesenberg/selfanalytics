library(shiny)
library(data.table)
library(plotly)
source("R/I18n.R")
source("R/Profile.R")
source("R/Metrics.R")
source("R/Performance.R")
i18n <- I18n$new()
i18n$setup()
translations <- i18n$i18n

shinyServer(function(input, output) {
  profile <- Profile$new(translations)
  profile$read(output)
  performance <- Performance$new(translations)
  metrics <- Metrics$new(translations)

  metrics$get_views_server(output, profile$shares)
  metrics$get_likes_server(output, profile$shares)
  metrics$get_comments_server(output, profile$shares)
  metrics$get_all_shares_server(output, profile$shares)

  performance$get_likes_by_views_server(output, profile$shares)
  performance$get_comments_by_views_server(output, profile$shares)
  performance$get_comments_by_likes_server(output, profile$shares)

  profile$get_refresh_server(input, output)
})
