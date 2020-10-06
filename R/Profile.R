library(R6)
source("R/LinkedIn.R")

#' Profile of a person
profile_class <- R6Class("Profile",
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
      private$linkedin <- linkedin_class$new()
      linkedin_data <- private$linkedin$read(private$profile_name, pages)
      self$name <- linkedin_data$name
      self$shares <- linkedin_data$shares
      private$write(self$shares)
    },
    
    get_refresh_ui = function() {
      tagList(
        sliderInput("pages_count", "Scroll how many times:",
                    min = 0, max = 100,
                    value = 5),
        actionButton("refresh_linkedIn", "Refresh data")
      )
    },
    
    get_refresh_server = function(input, output) {
      observeEvent(input$refresh_linkedIn, {
        self$refresh(input$pages_count)
        # self$shares <- data.table(id = c(1,2,3), views = c(10,20,30), likes=c(30,5,60), comments= c(0, 4,9))
        private$refresh_outputs(output)
      })
    },
    read = function(output) {
      shares <- fread("profile.csv")
      self$shares <- shares
      private$refresh_outputs(output)
    }
  ),
  private = list(
    linkedin = NULL,
    profile_name = "peterboesenberg",
    write = function(shares) {
      shares <- shares[, id:=nrow(shares):1]
      shares <- shares[is.na(comments), comments := 0]
      fwrite(shares, "profile.csv")
    },
    refresh_outputs = function(output = NULL) {
      performance <- performance_class$new() 
      performance$refresh_server(output, self$shares)
      output$shares_count <- private$build_shares_count_ui(self$shares)
    },
    build_shares_count_ui = function(shares) {
      renderText({paste0("Currently loaded shares:", nrow(shares))})
    }
  )
)
