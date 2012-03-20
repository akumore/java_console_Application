class window.AlfredMueller.Routers.Application extends Backbone.Router

  initialize: ->
    # initialize all accordions
    $(".accordion").each ->
      new AlfredMueller.Views.Accordion(el: $(this))

    # initialize vision slider at the top of each page
    $(".vision-slider").each ->
      new AlfredMueller.Views.VisionSlider(el: $(this))

    # initialize map sliders
    $(".map-slider").each ->
      new AlfredMueller.Views.MapSlider(el: $(this))

    # initialize clickable/hoverable table rows
    $("table").each ->
      new AlfredMueller.Views.InteractiveTable(el: $(this))

    # initialize expandable content
    $(".expandable").each ->
      new AlfredMueller.Views.ExpandableContent(el: $(this))

    # initialize slideshows
    $(window).load ->
      $(".flexslider").flexslider(
        directionNav: true,
        controlNav: false,
        slideshow: false,
        animation: "slide"
      )

    # initialize services slider always AFTER flexslider is initialized.
    # It is using flexsliders controls (hiding and showing) internally
    $(window).load ->
      $(".services-slides-container").each ->
        new AlfredMueller.Views.ServicesSlider(el: $(this))

      # add animation-start class to kick of any matching css transitions
      $("html").addClass("animation-start")

    # initialize fancybox overlays
    $(".zoom-overlay").fancybox(
      closeBtn: true
      helpers:
        overlay:
          css:
            backgroundColor: '#0A1930'
    )