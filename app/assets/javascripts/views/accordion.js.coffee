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
    if window.location.hash
      elem = $(window.location.hash)
      @openItem(elem.parent()) if elem.hasClass("title")

  openItem: (elem) ->
    @closeItem(@open) if @open
    @open = elem.addClass("open")

  closeItem: (elem) ->
    elem.removeClass("open")
    @open = null

  toggleItem: (elem) ->
    if elem.hasClass("open")
      @closeItem(elem)
    else
      @openItem(elem)

  handleClick: (event) =>
    item = $(event.currentTarget).parent()
    @toggleItem(item)
