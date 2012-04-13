class window.AlfredMueller.Views.TabSlider extends Backbone.View

  events:
    "click .first-level-navigation a" : "highlightLink"

  highlightLink: (event) ->
    @deactivateAll()
    @makeActive(event)

  makeActive: (event) -> 
    $(event.currentTarget).addClass("active")

  deactivateAll: ->
    @el.find('a').removeClass("active")

  