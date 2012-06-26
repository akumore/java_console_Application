class window.AlfredMueller.Views.Marker extends Backbone.View

  initialize: ->
    @map = @options.map
    @gmarker = new google.maps.Marker(
      map: @map,
      position: @model.toLatLng()
    )

    @interactiveRow = $("#real-estate-#{@model.id()}").data("interactive_row")

    if @interactiveRow
      @interactiveRow.setMarker @

    google.maps.event.addListener @gmarker, "mouseover", =>
      @interactiveRow.activate()

    google.maps.event.addListener @gmarker, "mouseout", =>
      @interactiveRow.deactivate()

  bounce: ->
    @gmarker.setAnimation(google.maps.Animation.BOUNCE)

  stopBounce: ->
    @gmarker.setAnimation(null)
