library(R6)
library(config)
library(rvest)
library(RSelenium)
library(data.table)
library(stringr)
source("R/LinkedinComments.R")

config <- config::get()

#' LinkedIn connector
Linkedin <- R6Class("LinkedIn", # nolint
  public = list(

    #' constructor
    initialize = function() {
      private$linkedin_comments <- LinkedinComments$new()
      private$setup_crawler()
      private$login()
      
    },
    #' @description
    #' Read data from the web
    #' @param profile_path path to the profile, e.g. "peterboesenberg"
    #' @param pages number of pages selenium should scroll down to get shares
    read = function(profile_path, pages = 10) {
      shares <- private$get_shares(profile_path, pages)
      name <- private$get_name()
      private$shut_down_crawler()
      data <- list(name = name, shares = shares)
      return(data)
    },
    get_driver = function(){
      return(private$driver)
    }
  ),
  private = list(
    base_path = "https://www.linkedin.com/in",
    login_url = "http://linkedin.com/login",
    shares_path = "detail/recent-activity/shares/",

    selenium_driver = NULL,
    driver = NULL,
    linkedin_comments = NULL,

    #' Starting Selenium and keeping selenium driver as a class variable.
    setup_crawler = function() {
      rd <- rsDriver(chromever = "85.0.4183.87", port = private$get_random_port_number())
      driver <- rd[["client"]]
      driver$maxWindowSize(winHand = "current")
      private$driver <- driver
      private$selenium_driver <- rd
    },

    #' Generate a random number between 1000 and 3000.
    #'
    #' Selenium is for some reason not releasing ports after use.
    #' Therefore we use a random port at every run.
    #' @return integer between 1000 and 30000
    get_random_port_number = function() {
      as.integer(runif(1, 1000, 3000))
    },
    #' Log into LinkedIn.
    #' Credentials have to be supplied in a file config.yml.
    #' Looking for entries linked$user and linked$password.
    login = function() {
      driver <- private$driver
      driver$navigate(private$login_url)
      name_input <- driver$findElements("id", "username")
      name_input[[1]]$clickElement()
      name_input[[1]]$sendKeysToElement(list(config$linkedin$user))
      password_input <- driver$findElements("id", "password")
      password_input[[1]]$clickElement()
      password_input[[1]]$sendKeysToElement(list(config$linkedin$password, key = "enter"))
    },
    #' Shut down the crawler and run garbage collection.
    #' In theory, this should completely stop Selenium and free up the used port.
    #' In reality, the port is still blocked.
    shut_down_crawler = function() {
      private$driver$close()
      private$selenium_driver$server$stop()
      gc()
    },
    #' Scrolls to the end of the page and waits three seconds.
    #' Waiting is necessary to let the webpage load the new content.
    #' (infinite scrolling)
    scroll_down = function() {
      driver <- private$driver
      body <- driver$findElement("css", "body")
      body$sendKeysToElement(list(key = "end"))
      Sys.sleep(3)
    },
    #' @param profile_path path to the profile, e.g. "peterboesenberg"
    #' @param pages number of pages selenium should scroll down to get shares
    get_shares_html = function(profile_path, pages = 10) {
      driver <- private$driver

      url <- paste(private$base_path, profile_path, private$shares_path, sep = "/")
      driver$navigate(url)
      Sys.sleep(3)
      for (i in seq_len(pages)) {
        private$scroll_down()
      }
      private$linkedin_comments$open_all_comments(driver)
      Sys.sleep(4)
      body <- driver$findElements("css", "body")
      body_content <- read_html(unlist(body[[1]]$getElementAttribute("innerHTML")))

      shares <- html_nodes(body_content, ".feed-shared-update-v2")
      return(shares)
    },
    #' Get a single share.
    #' Parses html of one share and returns a list with relevant numbers.
    #'
    #' @param share_html html block of the share
    #'
    #' @return list with date, likes, comments, views
    get_share = function(share_html) {
      raw_date <- html_text(html_node(share_html, ".feed-shared-actor__sub-description span"))
      date <- str_split(raw_date, " ", simplify = TRUE)[1]
      likes <- html_text(html_node(share_html, ".social-details-social-counts__reactions-count"))
      comments_count_raw <- html_text(html_node(share_html, ".social-details-social-counts__comments"))
      comments_raw <- html_nodes(share_html, ".comments-comments-list .comments-post-meta__author-badge")
      print("RAW COMMENTS")
      print(length(comments_raw))
      comments <- private$linkedin_comments$get_comments_count_without_own(comments_count_raw, comments_raw)

      views_raw <- html_text(html_node(share_html, ".analytics-entry-point strong"))
      views <- str_trim(str_split(str_trim(views_raw), "views", simplify = TRUE)[1])
      views <- str_replace(views, ",", "")

      share <- list(date = date, likes = str_trim(likes), comments = comments, views = views)
      print("A SHARE")
      print(share)
      return(share)
    },

    #' @param profile_path path to the profile, e.g. "peterboesenberg"
    #' @param pages number of pages selenium should scroll down to get shares
    get_shares = function(profile_path, pages = 10) {
      shares_html <- private$get_shares_html(profile_path, pages)
      shares <- sapply(shares_html, private$get_share)
      dt <- as.data.table(t(shares))
      dt <- dt[, likes := as.numeric(likes)][, comments := as.numeric(comments)][, views := as.numeric(views)]
      return(dt)
    },
    #' Get the name of the profile from HTML.
    #'
    #' @return name as string, for example "Horst Schmidt"
    get_name = function() {
      driver <- private$driver
      element <- driver$findElements("css", ".pv-recent-activity-top-card__info h3")
      content <- read_html(unlist(element[[1]]$getElementAttribute("innerHTML")))
      return(html_text(content))
    }
  )
)
