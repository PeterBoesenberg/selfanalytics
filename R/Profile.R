library(R6)
source("R/LinkedIn.R")

#' Profile of a person
Profile <- R6Class("Profile",
  public = list(

    #' Initialize the profile and setup LinkedIn-Crawling.
    initialize = function() {
      private$linkedin <- LinkedIn$new()
    },

    #' @field name full name of the person.
    name = NULL,

    #' @field shares recent shares of the person
    shares = NULL,

    #' @description
    #' Read data from the web and save it to local variables
    read = function() {
      linkedin_data <- private$linkedin$read(private$profile_name)
      self$name <- linkedin_data$name
      self$shares <- linkedin_data$shares
    }
  ),
  private = list(
    linkedin = NULL,
    profile_name = "peterboesenberg"
  )
)
