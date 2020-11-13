library(shiny)
library(plotly)
library(shiny.i18n)
source("R/I18n.R")
source("R/performance.R")
source("R/Profile.R")
i18n <- I18n$new()
i18n$setup()
translations <- i18n$i18n


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
        performance$get_views_ui("linkedin_views"),
        performance$get_likes_ui("linkedin_likes"),
        performance$get_comments_ui("linkedin_comments"),
      )
    )
  )
  
  
))
