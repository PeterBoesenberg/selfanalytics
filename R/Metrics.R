library(R6)
library(plotly)

Metrics <- R6Class( #nolint
  "Metrics",
  public = list(
    #' Initialize 
    initialize = function(translations) {
      private$translations <- translations
    },
    #' Refresh all chart outputs serverside.
    #'
    #' @param output shiny output
    #' @param shares datatable with id, views, likes, comments
    refresh_server = function(output, shares) {
      self$get_views_server(output, shares)
      self$get_likes_server(output, shares)
      self$get_comments_server(output, shares)
      self$get_all_shares_server(output, shares)
    },
    #' Get Plotly UI for LinkedIn-Views.
    #'
    #' @return plotlyOutput
    get_views_ui = function() {
      plotlyOutput("linkedin_views")
    },
    #' Builds Plotly chart and puts it in output.
    #'
    #' @param output shiny output
    #' @param shares datatable with id, views, likes, comments
    get_views_server = function(output, shares) {
      output$linkedin_views <- renderPlotly({
        plot <- plot_ly(shares, mode = "lines")
        plot <-
          add_trace(plot,
            x = ~id,
            y = ~views,
            name =  private$translations$t("charts.views.yaxis")
          )
        plot <-
          layout(plot, title = private$translations$t("charts.views.name"))
        plot
      })
    },
    #' Get Plotly UI for LinkedIn-Likes.
    #'
    #' @return plotlyOutput
    get_likes_ui = function() {
      plotlyOutput("linkedin_likes")
    },
    #' Builds Plotly chart and puts it in output.
    #'
    #' @param output shiny output
    #' @param shares datatable with id, views, likes, comments
    get_likes_server = function(output, shares) {
      output$linkedin_likes <- renderPlotly({
        plot <- plot_ly(shares, mode = "lines")
        plot <-
          add_trace(plot,
            x = ~id,
            y = ~likes,
            name =  private$translations$t("charts.likes.yaxis")
          )
        plot <-
          layout(plot, title = private$translations$t("charts.likes.name"))
        plot
      })
    },
    #' Get Plotly UI for LinkedIn-Comments.
    #'
    #' @return plotlyOutput
    get_comments_ui = function() {
      plotlyOutput("linkedin_comments")
    },
    #' Builds Plotly chart and puts it in output.
    #'
    #' @param output shiny output
    #' @param shares datatable with id, views, likes, comments
    get_comments_server = function(output, shares) {
      output$linkedin_comments <- renderPlotly({
        plot <- plot_ly(shares, mode = "lines")
        plot <-
          add_trace(plot,
            x = ~id,
            y = ~comments,
            name =  private$translations$t("charts.comments.yaxis")
          )
        plot <-
          layout(plot, title = private$translations$t("charts.comments.name"))
        plot
      })
    },
    get_all_shares_server = function(output, shares) {
      output$all_shares <- renderTable(shares)
    },
    get_all_shares_ui = function() {
      tableOutput("all_shares")
    }
  ),
  private = list(
    translations = NULL
  )
)
