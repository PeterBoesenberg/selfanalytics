library(R6)
source("R/LinkedIn.R")

#' Profile of a person
Profile <- R6Class("Profile", #nolint
  public = list(

    #' Initialize the profile
    initialize = function() {
    },

    #' @field name full name of the person.
    name = NULL,

    #' @field shares recent shares of the person
    shares = NULL,

    #' @description
    #' Read data from the web and save it to local variables
    #' @param pages how many pages should selenium scroll down to get shares
    refresh = function(pages = 10) {
      private$linkedin <- Linkedin$new()
      linkedin_data <- private$linkedin$read(private$profile_name, pages)
      self$name <- linkedin_data$name
      self$shares <- linkedin_data$shares
      private$write(self$shares)
    },

    #' Gets the UI-tags to refresh Profile data.
    #' Builds a taglist with input and button
    #'
    #' @return tagList with input and button
    get_refresh_ui = function() {
      tagList(
        sliderInput("pages_count", "Scroll how many times:",
          min = 0, max = 40,
          value = 5,
          width = "100%"
        ),
        actionButton("refresh_linkedIn", "Refresh data", class = "refresh_button")
      )
    },

    #' Gets the server-part for refresh-UI.
    #' Observes button and starts linkedin-crawling on click.
    #' Afterwards, refresh UI
    #' @param input shiny input with refresh_linkedin
    #' @param output shiny output
    get_refresh_server = function(input, output) {
      observeEvent(input$refresh_linkedIn, {
        self$refresh(input$pages_count)
        private$refresh_outputs(output)
      })
    },
    #' Read profile from profile.csv.
    #' Reads profile and refreshes UI
    #' @param output shiny output
    read = function(output) {
      shares <- fread("profile.csv")
      self$shares <- shares
      private$refresh_outputs(output)
    }
  ),
  private = list(
    linkedin = NULL,
    profile_name = "peterboesenberg",

    #' Write shares to profile.csv.
    #' This file will be read at start of app.
    #'
    #' @param shares datatable with columns likes, comments, views, date
    write = function(shares) {
      shares <- shares[, id := nrow(shares):1] #nolint
      shares <- shares[is.na(comments), comments := 0]
      shares <- shares[is.na(likes), likes := 0]
      shares <- shares[is.na(views), views := 0]
      fwrite(shares, "profile.csv")
    },

    #' Refreshes shiny-outputs with values in self$shares.
    #' Used to rerender plotly.charts with Profile-performance.
    #' Sets shiny output variables
    #'
    #' @param output shiny output
    refresh_outputs = function(output = NULL) {
      performance <- Performance$new()
      performance$refresh_server(output, self$shares)
      output$shares_count <- private$build_shares_count_ui(self$shares)
    },

    #' Builds the text output to show how many shares are currently loaded.
    #'
    #' @param shares datatable, whose rows are counted
    #' @return shiny renderText
    build_shares_count_ui = function(shares) {
      renderText({
        paste0("Currently loaded shares:", nrow(shares))
      })
    }
  )
)
