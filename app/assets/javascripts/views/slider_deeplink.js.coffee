class window.AlfredMueller.Views.SliderDeeplink extends Backbone.View

  events:
    "click" : "handleClick"

  initialize: ->
    @target = @options.target
    @slider = @options.slider
    @targetIdx = @target.parent().children(":not(.clone)").index(@target) 

  gotoTarget: ->
    @slider.flexAnimate(@targetIdx, false)

  handleClick: (event) =>
    @gotoTarget()
    return false
