class AlfredMueller.Views.SortOrderDropdown extends Backbone.View

  events:
    "change select" : "handleChange"

  initialize: ->
    @labelText = @el.data("label_text") || ""
    @form = @el.closest("form")
    @render()

  render: ->
    @el.find(".label").text "#{@labelText} #{@el.find(":selected").text()}"

  handleChange: (event) =>
    @render()
    @form.trigger("submit")
