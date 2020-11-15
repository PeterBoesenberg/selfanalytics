library(R6)
library(plotly)

Performance <- R6Class( #nolint
  "Performance",
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
      self$get_likes_by_views_server(output, shares)
      self$get_comments_by_views_server(output, shares)
      self$get_comments_by_likes_server(output, shares)
    },
    #' Get Plotly UI for LinkedIn-Views.
    #'
    #' @return plotlyOutput
    get_likes_by_views_ui = function() {
      plotlyOutput("linkedin_likes_by_views")
    },
    #' Builds Plotly chart and puts it in output.
    #'
    #' @param output shiny output
    #' @param shares datatable with id, views, likes, comments
    get_likes_by_views_server = function(output, shares) {
      output$linkedin_likes_by_views <- renderPlotly({
        plot <- plot_ly(shares, mode = "lines")
        plot <-
          add_trace(plot,
                    x = ~id,
                    y = ~(likes/views),
                    name =  private$translations$t("charts.likes_by_views.yaxis")
          )
        plot <-
          layout(plot, title = private$translations$t("charts.likes_by_views.name"))
        plot
      })
    },
    #' Get Plotly UI for LinkedIn-Likes.
    #'
    #' @return plotlyOutput
    get_comments_by_views_ui = function() {
      plotlyOutput("linkedin_comments_by_views")
    },
    #' Builds Plotly chart and puts it in output.
    #'
    #' @param output shiny output
    #' @param shares datatable with id, views, likes, comments
    get_comments_by_views_server = function(output, shares) {
      output$linkedin_comments_by_views <- renderPlotly({
        plot <- plot_ly(shares, mode = "lines")
        plot <-
          add_trace(plot,
                    x = ~id,
                    y = ~(comments/views),
                    name =  private$translations$t("charts.comments_by_views.yaxis")
          )
        plot <-
          layout(plot, title = private$translations$t("charts.comments_by_views.name"))
        plot
      })
    },
    #' Get Plotly UI for LinkedIn-Comments.
    #'
    #' @return plotlyOutput
    get_comments_by_likes_ui = function() {
      plotlyOutput("linkedin_comments_by_likes")
    },
    #' Builds Plotly chart and puts it in output.
    #'
    #' @param output shiny output
    #' @param shares datatable with id, views, likes, comments
    get_comments_by_likes_server = function(output, shares) {
      output$linkedin_comments_by_likes <- renderPlotly({
        plot <- plot_ly(shares, mode = "lines")
        plot <-
          add_trace(plot,
                    x = ~id,
                    y = ~(comments/likes),
                    name =  private$translations$t("charts.comments_by_likes.yaxis")
          )
        plot <-
          layout(plot, title = private$translations$t("charts.comments_by_likes.name"))
        plot
      })
    }
  ),
  private = list(
    translations = NULL
  )
)
