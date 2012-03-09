class window.AlfredMueller.Views.VisionSlider extends Backbone.View

  events:
    "click .toggle" : "handleToggle"

  initialize: ->
    @isOpen = true

  open: ->
    @isOpen = true
    @animate('open')

  close: -> 
    @isOpen = false
    @animate('close')

  animate: (state)->
    if Modernizr.cssanimations
      if state == 'open' then @el.addClass('open') else @el.removeClass('open')
    else
      marginTop = if state == 'open' then '0px' else '-500px'
      @el.animate('marginTop', marginTop)

  handleToggle: (event) =>
    if @isOpen
      @close()
    else
      @open()
    false