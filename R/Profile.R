library(R6)
source("R/LinkedIn.R")

#' Profile of a person
Profile <- R6Class("Profile",
  public = list(
    #' constructor
    initialize = function() {
      linkedin <- LinkedIn$new()
    },

    #' @field name full name of the person.
    name = NULL,

    #' @field company current company
    company = NULL,

    #' @description
    #' Read data from the web
    read = function() {
      self$name <- "Peter"
      self$company <- "functionHR"
    }
  ),
  private = list(
    path = "https://www.linkedin.com/in/peterboesenberg/"
  )
)
