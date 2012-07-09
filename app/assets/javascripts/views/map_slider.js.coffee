class window.AlfredMueller.Views.MapSlider extends Backbone.View

  events:
    "click .map-handle" : "handleClick"

  initialize: ->
    @isOpen     = false
    @slider     = @el.find(".map-slide")
    @realEstate = @el.find(".map").data("real_estate")
    @realEstates = new AlfredMueller.Collections.RealEstates([@realEstate])

  open: (elem) ->
    @map ||= new AlfredMueller.Views.Map(
      el: @el.find(".map"),
      real_estates: @realEstates
    )
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

  openGoogleMaps: ->
    window.location.href = "http://maps.google.ch/?q="+@realEstate.coordinates.join(',')
    return false

  handleClick: (e) =>
    if Modernizr.touch
      @openGoogleMaps()
    else
      @toggle()
