# Easy handling of accordion elements
# The structure should be as follows:
#
# <div class='accordion'>
#   <div class='accordion-item'>
#     <div class='title'>Title</div>
#     <div class='content'> ... your content ... </div>
#   </div>
#
#   // repeat accordion-items ...
# </div>
#
# NOTE: Ideally, the less href points to the id of the .expandable div, so that
# when collapsing the expandable container the browser jumps back up.

class window.AlfredMueller.Views.Accordion extends Backbone.View

  events:
    "click .title" : "handleClick"

  initialize: ->
    @items = @el.find(".accordion-item")
    @open  = null
    @initiallyOpenItem()

  initiallyOpenItem: ->
    @items.each (idx, elem) =>
      @closeItem($(elem))

    if window.location.hash
      elem = $(window.location.hash).closest('.accordion-item')
      @openItem(elem) if elem.find(".title").length > 0
    else if @el.data('open_first')
      elem = @el.find(".accordion-item:first-child")
      @openItem(elem, false)

  openItem: (elem, scroll=true) ->
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

