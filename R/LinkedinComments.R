library(R6)

LinkedinComments <- R6Class( #
  public = list(
    get_comments_count_without_own = function(comments_count_raw, comments_raw) {
      comments_count <- str_split(str_trim(comments_count_raw), " ", simplify = TRUE)[1]
      own_comments <- length(comments_raw)
      print("OWN COMMENTS")
      print(comments_raw)
      print(own_comments)
      print(comments_count)
      comments <- as.numeric(comments_count) - own_comments
      print("THIs makes....")
      print(comments)
      # if (!is.na(comments)) {
      #   element <- driver$findElements("css", ".pv-recent-activity-top-card__info h3")
      #     
      #     print(comments)
      # }
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
      # for (i in seq_len(length(elements))) {
      #   elements[[i]]$clickElement()
      # }
      #load more
      # elements <- driver$findElements("css", ".comments-comments-list__load-more-comments-button")
      last_element_id <- ""
      elements <- driver$findElements("css", ".comments-comments-list__load-more-comments-button")
      while(length(elements) > 0 & elements[[1]]$getElementAttribute("id")[[1]] != last_element_id) {
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
      replay_containers <- driver$findElements("css", ".comments-comment-item__replies-list")
      reply_buttons <- driver$findElements("css", " .button.show-prev-replies")
      print("COMPLETE REPLY BUTTONS")
      print(length(reply_buttons))
      # while(length(replay_buttons) > 0 ) {
        # print("ACTIVE ID")
        # print(replay_containers[[1]]$getElementAttribute("id")[[1]])
        # replay_containers <- driver$findElements("css", ".comments-comment-item__replies-list")
        # 
        # driver$setTimeout(type = "implicit", milliseconds = 1000)

        sapply(
          reply_buttons,
          function(x) {
            # html<-read_html(unlist(x$getElementAttribute("innerHTML")))
            # last_element_id <<- x$getElementAttribute("id")
            # print("LAST ID")
            # print(last_element_id)
            # button <- x$findChildElements("css", ".button.show-prev-replies")
            # print("BUTTONNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN????")
            # print(length(button))
            # if (length(button) > 0) {
            #   button[[1]]$clickElement()
            # }
            x$clickElement()
            Sys.sleep(2)
            }
        )
        Sys.sleep(2)
        replay_buttons <- driver$findElements("css", ".button.show-prev-replies")
        print("MORE BUTTONS??")
        print(length(replay_buttons))
      # }

    }
  ),
  private = list(
  )
)