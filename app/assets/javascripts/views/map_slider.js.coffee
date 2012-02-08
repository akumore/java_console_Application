class window.AlfredMueller.Views.MapSlider extends Backbone.View

  events:
    "click .map-handle" : "handleClick"

  initialize: ->
    @isOpen = false
    @slider = @el.find(".map-slide")
    @map    = @el.find(".map iframe")

  open: (elem) ->
    @map.css(
      width: @slider.width() + "px",
      height: @slider.height() + "px"
    )
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