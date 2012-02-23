class window.AlfredMueller.Views.SimpleSlider extends Backbone.View

  open: ->
    @el.addClass("open")

  close: ->
    @el.removeClass("open")


class window.AlfredMueller.Views.SliderWithFlexControl extends AlfredMueller.Views.SimpleSlider

  initialize: ->
    @flexNav = @el.find(".flex-direction-nav")
    @hideFlexSliderControls(0) unless @isOpen()

  open: (options={}) ->
    if options["noFlexControls"] then @hideFlexSliderControls() else @showFlexSliderControls()
    super

  close: ->
    @hideFlexSliderControls()
    super

  showFlexSliderControls: (animationDuration = 1000) ->
    @flexNav.show(animationDuration)

  hideFlexSliderControls: (animationDuration = 750) ->
    @flexNav.hide(animationDuration)

  isOpen: ->
    @el.hasClass("open")


class window.AlfredMueller.Views.ServicesSlider extends Backbone.View

  events:
    "click .rent-handle": "handleRentClick"
    "click .sale-handle": "handleSaleClick"
    "click .build-handle": "handleBuildClick"

  initialize: ->
    @rentSlider = new AlfredMueller.Views.SliderWithFlexControl(el: @el.find(".rent-slide"))
    @saleSlider = new AlfredMueller.Views.SliderWithFlexControl(el: @el.find(".sale-slide"))
    @buildSlider = new AlfredMueller.Views.SliderWithFlexControl(el: @el.find(".build-slide"))

  handleRentClick: (e) =>
    @buildSlider.close()
    @saleSlider.close()
    @rentSlider.open()

  handleSaleClick: (e) =>
    @buildSlider.close()
    @rentSlider.close()
    @saleSlider.open()

  handleBuildClick: (e) =>
    @rentSlider.close()
    @saleSlider.open(noFlexControls: true)
    @buildSlider.open()
