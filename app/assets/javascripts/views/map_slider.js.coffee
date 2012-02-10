class window.AlfredMueller.Views.MapSlider extends Backbone.View

  events:
    "click .map-handle" : "handleClick"

  initialize: ->
    @isOpen = false
    @slider = @el.find(".map-slide")

  open: (elem) ->
    @map ||= new AlfredMueller.Views.Map(el: @el.find(".map"))
    @map.setDimensions(@slider.width(), @slider.height())
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
