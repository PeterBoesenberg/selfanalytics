library(shiny)
library(plotly)
library(shiny.i18n)
source("R/I18n.R")
source("R/Metrics.R")
source("R/Performance.R")
source("R/Profile.R")
i18n <- I18n$new()
i18n$setup()
translations <- i18n$i18n


metrics <- Metrics$new(translations)
performance <- Performance$new(translations)
profile <- Profile$new(translations)
shinyUI(fluidPage(
  includeCSS("www/layout.css"),
  includeCSS("www/refresh.css"),
  sidebarLayout(
    
    # Sidebar with a slider input
    sidebarPanel(
      titlePanel(translations$t("app.title")),
      hr(),
      h4(translations$t("step1.header")),
      textOutput("shares_count"),
      div(
        class = "refresh",
        profile$get_refresh_ui()
      )
    ),
    mainPanel(
      div(
        class = "flex",
        metrics$get_views_ui(),
        metrics$get_likes_ui(),
        metrics$get_comments_ui()
      ),
      div(
        class = "flex",
        performance$get_comments_by_views_ui(),
        performance$get_comments_by_likes_ui(),
        performance$get_likes_by_views_ui()
      ),
      div(
        metrics$get_all_shares_ui()
      )
    )
  )
  
  
))
