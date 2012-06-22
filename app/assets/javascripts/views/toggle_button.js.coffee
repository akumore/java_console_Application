class AlfredMueller.Views.ToggleButton extends Backbone.View

  events:
    "click" : "handleClick"
    "mouseenter" : "handleMouseEnter"
    "mouseleave" : "handleMouseLeave"

  initialize: ->
    currentSortOrder = $(".sort-order-hidden-field").val()
    $(".#{currentSortOrder}").show()
    @form = @el.closest("form")
    if currentSortOrder == "asc"
      @el.addClass("asc")

  toggleDiv: ->
    @el.children("div").toggle()
    @el.toggleClass("asc")

  handleClick: (event) =>
    sortOrderToBeChanged = @el.children("div:visible").attr("class")
    $(".sort-order-hidden-field").val(sortOrderToBeChanged)
    @form.trigger("submit")

  handleMouseEnter: (event) =>
    @toggleDiv()

  handleMouseLeave: (event) =>
    @toggleDiv()

