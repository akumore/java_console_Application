class window.AlfredMueller.Cms.Views.DependentDisplay extends Backbone.View

  initialize: ->
    @target = @options.target
    @targetValue = @options.targetValue
    @target.bind 'change', @handleChange
    @valueHasChanged()

  valueHasChanged: ->
    if !(@targetValue instanceof Array)
      @targetValue = [@targetValue]

    if (@target.is(":checked") in @targetValue) || (@target.val() in @targetValue)
      @el.removeClass("hidden")
    else
      @el.addClass("hidden")

  handleChange: (e) =>
    @valueHasChanged()
