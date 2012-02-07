class window.AlfredMueller.Routers.Application extends Backbone.Router

  initialize: ->
    # initialize all accordions
    $(".accordion").each ->
      new AlfredMueller.Views.Accordion(el: $(this))

    # initialize map sliders
    $(".map-slider").each ->
      new AlfredMueller.Views.MapSlider(el: $(this))
    
    # initialize slideshows
    $(window).load ->
      $(".flexslider").flexslider(
        directionNav: true,
        controlNav: false,
        slideshow: false,
        animation: "slide"
      ) 