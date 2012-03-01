class window.AlfredMueller.Views.Marker extends Backbone.View

  initialize: ->
    @map = @options.map
    @gmarker = new google.maps.Marker(
      map: @map,
      position: @model.toLatLng()
    )

    @interactive_row = $("#real-estate-#{@model.id()}").data("interactive_row")

    google.maps.event.addListener @gmarker, "mouseover", =>
      @interactive_row.activate()

    google.maps.event.addListener @gmarker, "mouseout", =>
      @interactive_row.deactivate()
