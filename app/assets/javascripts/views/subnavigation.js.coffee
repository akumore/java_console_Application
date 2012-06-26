class AlfredMueller.Views.Subnavigation extends Backbone.View

  events:
    "click a" : "handleClick"

  goTo: (id) ->
    elem = $(id)
    options = offset:
      left: 0
      top: -15

    if elem.length > 0
      $.scrollTo(elem, 500, options)

  handleClick: (event) =>
    link = event.target
    @goTo(link.hash)
