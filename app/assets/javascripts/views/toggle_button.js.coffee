class AlfredMueller.Views.ToggleButton extends Backbone.View

  events:
    "click" : "handleClick"
    "mouseenter" : "handleMouseEnter"
    "mouseleave" : "handleMouseLeave"

  initialize: ->
    currentSortOrder = $(".sort-order-hidden-field").val()
    $(".#{currentSortOrder}").show()
    @form = @el.closest("form")

  toggleDiv: ->
    @el.children("div").toggle()

  handleClick: (event) =>
    sortOrderToBeChanged = @el.children("div:visible").attr("class")
    $(".sort-order-hidden-field").val(sortOrderToBeChanged)
    @form.trigger("submit")

  handleMouseEnter: (event) =>
    @toggleDiv()

  handleMouseLeave: (event) =>
    @toggleDiv()

