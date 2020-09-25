library(R6)

#' Profile of a person
Profile <- R6Class("Profile",
  public = list(

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


