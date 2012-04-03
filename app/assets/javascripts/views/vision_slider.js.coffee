class window.AlfredMueller.Views.VisionSlider extends Backbone.View

  events:
    "click .toggle" : "handleToggle"

  @getState: ->
    monster.get("vision_slider_state") || "open"

  @setState: (state)->
    monster.set("vision_slider_state", state)

  @initialize:
    if @getState() == "open"
      $("html").addClass("vision-slider-open")
    else
      $("html").removeClass("vision-slider-open")

  initialize: ->
    $(".flexslider", @el).flexslider(
      directionNav: true,
      controlNav: false,
      slideshow: false,
      animation: "slide"
    )

  open: ->
    @animate("open")
    $("html").addClass("vision-slider-open")
    AlfredMueller.Views.VisionSlider.setState("open")

  close: -> 
    @animate("closed")
    $("html").removeClass("vision-slider-open")
    AlfredMueller.Views.VisionSlider.setState("closed")

  animate: (state)->
    marginTop = if state == "open" then "0px" else "-385px"
    @el.css("marginTop", marginTop)

  handleToggle: (event) =>
    if AlfredMueller.Views.VisionSlider.getState() == "open"
      @close()
    else
      @open()
    false