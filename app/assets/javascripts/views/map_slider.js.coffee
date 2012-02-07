class window.AlfredMueller.Views.MapSlider extends Backbone.View

  events:
    "click .map-handle" : "handleClick"

  initialize: ->
    @isOpen = false

  open: (elem) ->
    @el.addClass("open")
    @isOpen = true
    return false

  close: (elem) ->
    @isOpen = false
    @el.removeClass("open")

  toggle: (elem) ->
    if @isOpen
      @close()
    else
      @open()

  handleClick: (e) =>
    @toggle()