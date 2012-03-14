class window.AlfredMueller.Views.VisionSlider extends Backbone.View

  events:
    "click .toggle" : "handleToggle"

  @getState: ->
    monster.get("vision_header_state") || "open"

  @setState: (state)->
    monster.set("vision_header_state", state)

  @initialize:
    if @getState() == "open"
      $("html").addClass("vision-header-open")
    else
      $("html").removeClass("vision-header-open")

  open: ->
    @animate("open")
    $("html").addClass("vision-header-open")
    AlfredMueller.Views.VisionSlider.setState("open")

  close: -> 
    @animate("closed")
    $("html").removeClass("vision-header-open")
    AlfredMueller.Views.VisionSlider.setState("closed")

  animate: (state)->
    marginTop = if state == "open" then "0px" else "-380px"
    @el.css("marginTop", marginTop)

  handleToggle: (event) =>
    if AlfredMueller.Views.VisionSlider.getState() == "open"
      @close()
    else
      @open()
    false