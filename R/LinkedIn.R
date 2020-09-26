library(R6)
library(config)
library(rvest)
library(RSelenium)

config <- config::get()

#' LinkedIn connector
LinkedIn <- R6Class("LinkedIn",
  public = list(

    #' constructor
    initialize = function() {
      private$setup_crawler()
      private$login()
    },
    #' @description
    #' Read data from the web
    read = function(profile_path) {
      html <- private$get_shares_html(profile_path)
      print(html)
      return(html)
    }
  ),
  private = list(
    base_path = "https://www.linkedin.com/in",
    login_url = "http://linkedin.com/login",
    shares_path = "detail/recent-activity/shares/",

    selenium_driver = NULL,
    driver = NULL,

    setup_crawler = function() {
      rD <- rsDriver(chromever = '85.0.4183.87', port=1247L)
      driver <- rD[["client"]]
      driver$maxWindowSize(winHand = "current")
      private$driver <- driver
      private$selenium_driver <- rD
    },
    login = function() {
      driver <- private$driver
      driver$navigate(private$login_url)
      name_input = driver$findElements('id','username')
      name_input[[1]]$clickElement()
      name_input[[1]]$sendKeysToElement(list(config$linkedin$user))
      password_input = driver$findElements('id', 'password')
      password_input[[1]]$clickElement()
      password_input[[1]]$sendKeysToElement(list(config$linkedin$password, key = 'enter'))
    },
    shut_down_crawler = function() {
      private$driver$close()
      private$selenium_driver$server$stop()
      gc()
    },
    scroll_down = function() {
      driver <- private$driver
      body <- driver$findElement("css", "body")
      body$sendKeysToElement(list(key = "end"))
      Sys.sleep(3)
    },
    
    get_shares_html = function(profile_path) {
      driver <- private$driver

      url <- paste(private$base_path, profile_path, private$shares_path, sep = "/")
      driver$navigate(url)
      Sys.sleep(3)
      for (i in seq_len(2)) {
        private$scroll_down()
      }
      body <-  driver$findElements("css", "body")
      bpdy_content <- read_html(unlist(body[[1]]$getElementAttribute('innerHTML')))
      private$shut_down_crawler()
      shares <- html_nodes(bpdy_content, ".feed-shared-update-v2")
      return(shares)
    }
  )
)
