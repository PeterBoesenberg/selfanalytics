library(R6)

LinkedinComments <- R6Class( #
  public = list(
    get_comments_count_without_own = function(comments_count_raw, comments_raw) {
      comments_count <- str_split(str_trim(comments_count_raw), " ", simplify = TRUE)[1]
      own_comments <- length(comments_raw)
      print("OWN COMMENTS")
      print(comments_raw)
      print(own_comments)
      print("ALL_COMMENTS")
      print(comments_count_raw)
      print(comments_count)
      print(as.numeric(comments_count))
      comments <- as.numeric(comments_count) - own_comments
      print("THIS makes....")
      print(comments)

      return(comments)
    },
    
    #' Open up all comments with a click.
    #' Only the first few comments and replies are open initially. To get them all,
    #' we have to click the 'comments' link and the 'load more' link several times.
    #'
    #' @param driver Selenium driver, which already navigated to the postings-page
    open_all_comments = function(driver) {
      elements <- driver$findElements("css", ".social-details-social-counts__comments")
      sapply(
        elements,
        function(x) x$clickElement()
      )
      
      last_element_id <- ""
      elements <- driver$findElements("css", ".comments-comments-list__load-more-comments-button")
      while(length(elements) > 0 && elements[[1]]$getElementAttribute("id")[[1]] != last_element_id) {
        elements <- driver$findElements("css", ".comments-comments-list__load-more-comments-button")
        driver$setTimeout(type = "implicit", milliseconds = 1000)

        sapply(
          elements,
          function(x) {
            html<-read_html(unlist(x$getElementAttribute("innerHTML")))
            last_element_id <<- x$getElementAttribute("id")
            x$clickElement()
            }
        )
      }
      last_element_id <- ""
      reply_buttons <- driver$findElements("css", " .button.show-prev-replies")
      while(length(reply_buttons) > 0 ) {
        driver$setTimeout(type = "implicit", milliseconds = 1000)

        sapply(
          reply_buttons,
          function(x) {

            x$clickElement()
            Sys.sleep(2)
            }
        )
        Sys.sleep(2)
        reply_buttons <- driver$findElements("css", ".button.show-prev-replies")
        print("MORE BUTTONS??")
        print(length(reply_buttons))
      }

    }
  ),
  private = list(
  )
)