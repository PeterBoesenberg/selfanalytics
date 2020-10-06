library(R6)
source("R/LinkedIn.R")

#' Profile of a person
profile_class <- R6Class("Profile",
  public = list(

    #' Initialize the profile
    initialize = function() {
      private$read()
    },

    #' @field name full name of the person.
    name = NULL,

    #' @field shares recent shares of the person
    shares = NULL,

    #' @description
    #' Read data from the web and save it to local variables
    refresh = function() {
      private$linkedin <- linkedin_class$new()
      linkedin_data <- private$linkedin$read(private$profile_name)
      self$name <- linkedin_data$name
      self$shares <- linkedin_data$shares
      private$write(self$shares)
    },
    
    get_refresh_ui = function() {
      actionButton("refreshLinkedIn", "Refresh data")
        
    },
    
    get_refresh_server = function(input) {
      observeEvent(input$refreshLinkedIn, {
        self$refresh()
      })
    }
  ),
  private = list(
    linkedin = NULL,
    profile_name = "peterboesenberg",
    read = function() {
      shares <- fread("profile.csv")
      shares <- shares[, id:=nrow(shares):1]
      shares <- shares[is.na(comments), comments := 0]
      self$shares <- shares
    },
    write = function(shares) {
      fwrite(shares, "profile.csv")
    }
  )
)
