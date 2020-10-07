library(R6)

Performance <- R6Class( #nolint
  "Performance",
  public = list(
    #' Refresh all chart outputs serverside.
    #'
    #' @param output shiny output
    #' @param shares datatable with id, views, likes, comments
    refresh_server = function(output, shares) {
      self$get_views_server(output, shares)
      self$get_likes_server(output, shares)
      self$get_comments_server(output, shares)
    },
    #' Get Plotly UI for LinkedIn-Views.
    #'
    #' @param id namespacing id
    #' @return plotlyOutput
    get_views_ui = function(id) {
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
            name = "Likes"
          )
        plot <-
          layout(plot, title = "Views over time")
        plot
      })
    },
    #' Get Plotly UI for LinkedIn-Likes.
    #'
    #' @param id namespacing id
    #' @return plotlyOutput
    get_likes_ui = function(id) {
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
            name = "Likes"
          )
        plot <-
          layout(plot, title = "Likes over time")
        plot
      })
    },
    #' Get Plotly UI for LinkedIn-Comments.
    #'
    #' @param id namespacing id
    #' @return plotlyOutput
    get_comments_ui = function(id) {
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
            name = "Likes"
          )
        plot <-
          layout(plot, title = "Comments over time")
        plot
      })
    }
  ),
  private = list()
)
