class window.AlfredMueller.Views.VisionSlider extends Backbone.View

  events:
    "click .toggle" : "handleToggle"

  @getState: ->
    if window.location.pathname == '/'
      monster.get("vision_slider_state") || "open"
    else
      @internalState || "closed"

  @setState: (state)->
    if window.location.pathname == '/'
      monster.set("vision_slider_state", state)
    else
      @internalState = state

  @initialize:
    if @getState() == "open"
      $("html").addClass("vision-slider-open")
    else
      $("html").removeClass("vision-slider-open")

  initialize: ->
    @visionClickArea = @el.find(".vision-click-area")
    @initSlider()

  initSlider: ->
    $(".flexslider", @el).flexslider(
      directionNav: true,
      controlNav: false,
      slideshow: false,
      animation: "slide",
      start: @handleSlide,
      after: @handleSlide
    )

  open: ->
    @animate("open")
    @initSlider()
    $("html").addClass("vision-slider-open")
    AlfredMueller.Views.VisionSlider.setState("open")

  close: ->
    @animate("closed")
    $("html").removeClass("vision-slider-open")
    AlfredMueller.Views.VisionSlider.setState("closed")

  animate: (state)->
    scale = $("#container").width() / 1000
    height = 488 # height on 1000 max width
    top = height * scale

    marginTop = if state == "open" then "0px" else "-#{top}px"
    if Modernizr.csstransitions
      @el.css("marginTop", marginTop)
    else
      @el.animate({marginTop: marginTop})

  handleToggle: (event) =>
    if AlfredMueller.Views.VisionSlider.getState() == "open"
      @close()
    else
      @open()
    false

  handleSlide: (slider) =>
    link = $("a.go", slider.slides.eq(slider.currentSlide))

    if link.length > 0
      @visionClickArea.attr("href", link.attr("href")).removeClass("disabled")
    else
      @visionClickArea.attr("href", link).addClass("disabled")
