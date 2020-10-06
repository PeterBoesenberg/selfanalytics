library(R6)

performance_class <- R6Class(
  "Performance",
  public = list(
    get_views_ui = function(id) {
      plotlyOutput("linkedin_views")
    },
    refresh_server = function(output, shares) {
      self$get_views_server(output, shares)
      self$get_likes_server(output, shares)
      self$get_comments_server(output, shares)
    },
    get_views_server = function(output, shares) {
      output$linkedin_views <- renderPlotly({
        plot <- plot_ly(shares, mode = 'lines')
        plot <-
          add_trace(plot,
                    x = ~ id,
                    y = ~ views,
                    name = "Likes")
        plot <-
          layout(plot, title = "Views over time")
        plot
      })
    },
    get_likes_ui = function(id) {
      plotlyOutput("linkedin_likes")
    },
    get_likes_server = function(output, shares) {
      output$linkedin_likes <- renderPlotly({
        plot <- plot_ly(shares, mode = 'lines')
        plot <-
          add_trace(plot,
                    x = ~ id,
                    y = ~ likes,
                    name = "Likes")
        plot <-
          layout(plot, title = "Likes over time")
        plot
      })
    },
    get_comments_ui = function(id) {
      plotlyOutput("linkedin_comments")
    },
    get_comments_server = function(output, shares) {
      output$linkedin_comments <- renderPlotly({
        plot <- plot_ly(shares, mode = 'lines')
        plot <-
          add_trace(plot,
                    x = ~ id,
                    y = ~ comments,
                    name = "Likes")
        plot <-
          layout(plot, title = "Comments over time")
        plot
      })
    }
  ),
  private = list()
  
)
