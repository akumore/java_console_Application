class window.AlfredMueller.Cms.Views.DependentSelectDisplay extends Backbone.View

  initialize: ->
    @target = @options.target
    @targetRadioGroup = @options.targetRadioGroup
    @targetRadioGroup.bind 'change', @handleChange
    @valueHasChanged()

  valueHasChanged: ->
    if @target.is(":checked")
      @el.removeClass("hidden")
    else
      @el.addClass("hidden")

  handleChange: (e) =>
    @valueHasChanged()
