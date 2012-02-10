class window.AlfredMueller.Views.Map extends Backbone.View

  initialize: ->
    options =
      zoom: 15
      center: new google.maps.LatLng(47.0, 8.0) # default to switzerland
      mapTypeId: google.maps.MapTypeId.ROADMAP

    @geocoder = new google.maps.Geocoder()
    @map = new google.maps.Map(@el.get(0), options)
    @resolveAddress(@el.data("address"))

  setDimensions: (w, h) ->
    @el.css(
      width: w + "px",
      height: h + "px"
    )

  resolveAddress: (address) ->
    @geocoder.geocode(address: address, @handleGeocodeLookup)

  handleGeocodeLookup: (results, status) =>
    if status == google.maps.GeocoderStatus.OK
      @map.setCenter(results[0].geometry.location)
      marker = new google.maps.Marker(
        map: @map
        position: results[0].geometry.location
      )
