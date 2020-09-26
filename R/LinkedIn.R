library(R6)
library(rvest)	
library(config)
library(rvest)

config <- config::get()

#' LinkedIn connector
LinkedIn <- R6Class("LinkedIn",
  public = list(
    
    #' constructor
    initialize = function() {
      private$setup_crawler()
      
    },
    #' @description
    #' Read data from the web
    read = function(profile_path) {
      html <- private$get_profile_html(profile_path)
      print(html)
    }
  ),
  private = list(
    base_path = "https://www.linkedin.com/in",
    login_url = "http://linkedin.com/login",
    
    session = NULL,
    
    setup_crawler = function() {
      pgsession <- html_session(private$login_url)
      pgform <- html_form(pgsession)[[1]]
      
      filled_form <- set_values(pgform,
                                session_key = config$linkedin$user,
                                session_password = config$linkedin$password)
      
      submit_form(pgsession, filled_form)
      private$session <- pgsession
    },
    get_profile_html = function(profile_path) {
      session <- private$session
      
      profile_url <- paste(private$base_path, profile_path, sep="/")
      print(profile_url)
      session <- jump_to(session, profile_url)
      
      page_html <- read_html(session)
      return(page_html)
    }
  )
)
