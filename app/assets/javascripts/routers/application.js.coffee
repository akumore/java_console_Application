class window.AlfredMueller.Routers.Application extends Backbone.Router

  initialize: ->
    # placeholder polyfill, do before accordions, because they hide inputs which cannot be found otherwise
    $('input[placeholder], textarea[placeholder]').placeholder()

    $('body').ajaxSuccess ->
      $('input[placeholder], textarea[placeholder]').placeholder()

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

    # initialize tab slider
    $(".tab-slider").each ->
      new AlfredMueller.Views.TabSlider(el: $(this))

    # initialize slideshows
    $(".gallery .flexslider").flexslider(
      directionNav: true,
      controlNav: false,
      slideshow: false,
      animation: "slide",
      start: (slider) ->
        new AlfredMueller.Views.SliderDeeplink(
          el: $(".icon-groundplan"),
          target: $(".gallery .flexslider li[data-is_floorplan=true]:not(.clone)"),
          slider: slider
        )
    )

    $(".reference-projects-slider .flexslider, .services-slides-container .flexslider").flexslider(
      directionNav: true,
      controlNav: false,
      slideshow: false,
      animation: "slide"
    )

    # initialize all accordions after the sliders, because they can contain sliders
    $(".accordion").each ->
      new AlfredMueller.Views.Accordion(el: $(this))

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

    #initialize chosen selects, doesn't work smoothly on iOS or touch devices in general
    unless Modernizr.touch
      $(".chzn-select").chosen()

    #initialize updater of filter-cities dropdown
    $('.search-filter-form').each ->
      new AlfredMueller.Views.SearchFilterOptionsUpdater(el: $(this))

    # initialize sorting dropdowns
    $(".sort-order-dropdown").each ->
      new AlfredMueller.Views.SortOrderDropdown(el: $(this))
