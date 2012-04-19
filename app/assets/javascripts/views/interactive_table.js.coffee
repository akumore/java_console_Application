class window.AlfredMueller.Views.InteractiveTable extends Backbone.View
  initialize: ->
    @el.find("tbody tr").each ->
      new AlfredMueller.Views.InteractiveRow(el: $(this))

class window.AlfredMueller.Views.InteractiveRow extends Backbone.View

  events:
    "click" : "handleClick"
    "mouseenter" : "handleMouseEnter"
    "mouseleave" : "handleMouseLeave"

  initialize: ->
    @el.data("interactive_row", this)

  activate: ->
    @el.addClass("active")

  deactivate: ->
    @el.removeClass("active")

  handleClick: (e) =>
    window.location.href = @el.find("a:first-child").attr("href")

  handleMouseEnter: (e) =>
    @activate()

  handleMouseLeave: (e) =>
    @deactivate()
