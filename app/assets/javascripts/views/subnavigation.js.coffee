class AlfredMueller.Views.Subnavigation extends Backbone.View

  events:
    "click a" : "handleClick"

  goTo: (id) ->
    elem = $(id)
    if elem.length > 0
      $.scrollTo(elem, 500)

  handleClick: (event) =>
    link = event.target
    @goTo(link.hash)
