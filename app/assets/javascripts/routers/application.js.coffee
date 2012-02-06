class window.AlfredMueller.Routers.Application extends Backbone.Router

  initialize: ->
    # initialize all accordions
    $('.accordion').each ->
      new AlfredMueller.Views.Accordion(el: $(this))