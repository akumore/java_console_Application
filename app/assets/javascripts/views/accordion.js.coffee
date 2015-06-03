# Easy handling of accordion elements
# The structure should be as follows:
#
# <div class='accordion'>
#   <div class='accordion__item'>
#     <div class='accordion__title'>Title</div>
#     <div class='accordion__content'> ... your content ... </div>
#   </div>
#
#   // repeat accordion-items ...
# </div>
#
# NOTE: Ideally, the less href points to the id of the .expandable div, so that
# when collapsing the expandable container the browser jumps back up.

class window.AlfredMueller.Views.Accordion extends Backbone.View

  events:
    "click .accordion__title" : "handleClick"

  initialize: ->
    @items = @el.find(".accordion__item")
    @open  = null
    @initiallyOpenItem()

  initiallyOpenItem: ->
    @items.each (idx, elem) =>
      @closeItem($(elem))

    if window.location.hash
      elem = $(window.location.hash).closest('.accordion__item')
      @openItem(elem) if elem.find(".accordion__title").length > 0
    else if @el.data('open_first')
      elem = @el.find(".accordion__item:first-child")
      @openItem(elem, false)

  openItem: (elem, scroll=true) ->
    @getTrackingInfo(elem) if elem.find('.ga-tracking-info').length > 0
    @closeItem(@open) if @open
    @open = elem.addClass("open").removeClass("closed")
    @initSlider(elem)
    # TODO: fix later
    unless Modernizr.touch
      $.scrollTo(elem, 500) if scroll

  closeItem: (elem) ->
    elem.removeClass("open").addClass("closed")
    @open = null

  toggleItem: (elem) ->
    if elem.hasClass("open")
      @closeItem(elem)
    else
      @openItem(elem)
      if elem.hasClass('accordion-ga-tracking-link')
        new AlfredMueller.Views.GoogleAnalyticsTracker(el: elem)

  initSlider: (elem)->
    $(".flexslider", elem).flexslider(
      directionNav: true,
      controlNav: false,
      slideshow: false,
      animation: "slide",
    )

  handleClick: (event) =>
    item = $(event.currentTarget).parent()
    @toggleItem(item)

  getTrackingInfo: (elem) ->
    trackingInfo = elem.find('.ga-tracking-info')
    elem.attr('data-ga-category', trackingInfo.attr('data-ga-category'))
    elem.attr('data-ga-action', trackingInfo.attr('data-ga-action'))
    elem.attr('data-ga-label', trackingInfo.attr('data-ga-label'))
    elem.addClass('accordion-ga-tracking-link')
