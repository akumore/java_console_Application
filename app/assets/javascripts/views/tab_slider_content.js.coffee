class window.AlfredMueller.Views.TabSliderContent extends Backbone.View

  events:
    "click .first-level-navigation a" : "handleClick"

  initialize: ->
    @link = @options.link

  activate: ->
    @link.addClass("active")
    @el.removeClass("hidden")

    $(".flexslider", @el).flexslider(
      directionNav: true,
      slideshow: false,
      animation: "slide",
      manualControls: ".second-level-navigation li a"
    )

  deactivate: ->
    @link.removeClass("active")
    @el.addClass("hidden")
    
  makeActive: (link) -> 
    @deactivateAll()
    link.addClass("active")

  deactivateAll: ->
    @el.find('a').removeClass("active")

  handleClick: (event) ->
    makeActive($(event.target))
  