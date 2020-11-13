library(R6)
library(shiny.i18n)

I18n <- R6Class("I18n", # nolint
  public = list(
    i18n = NULL,
    setup = function() {
      self$i18n <- Translator$new(translation_json_path = file.path("translation.json"))
      self$i18n$set_translation_language("en")
    }
  ),
  private = list()
)
