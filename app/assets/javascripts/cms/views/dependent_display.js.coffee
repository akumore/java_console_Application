class window.AlfredMueller.Cms.Views.DependentDisplay extends Backbone.View

  initialize: ->
    @target = @options.target
    @targetValue = @options.targetValue
    @target.bind 'change', @handleChange
    @valueHasChanged()

  valueHasChanged: ->
    console.log @el
    if @target.val() == @targetValue
      @el.removeClass("hidden")
    else
      @el.addClass("hidden")

  handleChange: (e) =>
    @valueHasChanged()
