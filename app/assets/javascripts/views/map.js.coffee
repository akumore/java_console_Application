class window.AlfredMueller.Views.Map extends Backbone.View

  initialize: ->
    options =
      zoom: 15
      center: new google.maps.LatLng(47.0, 8.0) # default to switzerland
      mapTypeId: google.maps.MapTypeId.ROADMAP
      maxZoom: 18

    # basic map
    @map = new google.maps.Map(@el.get(0), options)

    # bounds by real estate points
    @bounds = new google.maps.LatLngBounds()

    # add real estate markers
    @options.real_estates.each (real_estate) =>
      new AlfredMueller.Views.Marker(
        map: @map,
        model: real_estate
      )

      @bounds.extend(real_estate.toLatLng())

    @map.fitBounds(@bounds)

  setDimensions: (w, h) ->
    @el.css(
      width: w + "px",
      height: h + "px"
    )

class window.AlfredMueller.Views.ScrollingMap extends window.AlfredMueller.Views.Map

  initialize: ->
    super
    setInterval @handleScroll, 150
    @window = $(window)
    @animate = Modernizr.cssanimations
    @lastTop = 0

  constrainer: ->
    @constrainingContainer ||= @el.parent()

  top: ->
    _top = @window.scrollTop() - @constrainer().offset().top
    _bottom = @constrainer().height() - @el.height()
    Math.max(0, Math.min(_top, _bottom))

  handleScroll: =>
    if @lastTop != (t = @top())
      if @animate
        @el.css top: t
      else
        @el.animate({top: t}, 'fast')
      @lastTop = t
