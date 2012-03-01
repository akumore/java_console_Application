class window.AlfredMueller.Models.RealEstate extends Backbone.Model
  coordinates: ->
    @get('coordinates')

  toLatLng: ->
    new google.maps.LatLng(@coordinates()[0], @coordinates()[1])

  id: ->
    @get('_id')