class window.AlfredMueller.Views.Accordion extends Backbone.View

  events:
    "click li.title a" : "handleClick"

  initialize: ->
    @openElem = @el.find("li.open")

  open: (elem) ->
    if @openElem
      @close(@openElem)

    @openElem = elem
    $(@openElem).addClass("open")

  close: (elem) ->
    @openElem = null
    $(elem).removeClass("open")

  toggle: (elem) ->
    if @openElem == elem
      @close(elem)
    else
      @open(elem)

  handleClick: (e) =>
    # work with the pure DOM node to ensure object identity
    @toggle($(e.currentTarget).parent().get(0))