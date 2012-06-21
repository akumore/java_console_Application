class AlfredMueller.Views.ToggleButton extends Backbone.View

  events:
    "click" : "handleClick"

  initialize: ->
    currentSortOrder = $(".sort-order-hidden-field").val()
    $(".#{currentSortOrder}").show()
    @form = @el.closest("form")

  handleClick: (event) =>
    @el.children("div").toggle()
    sortOrderToBeChanged = @el.children("div:visible").attr("class")
    $(".sort-order-hidden-field").val(sortOrderToBeChanged)
    @form.trigger("submit")

