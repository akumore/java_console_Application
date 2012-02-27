class window.AlfredMueller.Views.SimpleSlider extends Backbone.View

  open: ->
    @el.addClass("open")

  close: ->
    @el.removeClass("open")


class window.AlfredMueller.Views.SliderWithFlexControl extends AlfredMueller.Views.SimpleSlider

  initialize: ->
    @flexNav = @el.find(".flex-direction-nav")
    @linkBox = @el.find(".link-box")
    @hideFlexSliderControls(0) unless @isOpen()
    @hideLinkBox(0) unless @isOpen()
    @clickHandle = @el.find(".handle")
    @clickHandle.addClass("foreground-me")

  open: (options={}) ->
    if options["noFlexControls"]
      @hideFlexSliderControls()
      @hideLinkBox()
      @el.removeClass('active')
    else
      @showFlexSliderControls()
      @showLinkBox()
      @el.addClass('active')
    super

  close: ->
    @hideFlexSliderControls()
    @hideLinkBox()
    @el.removeClass('active')
    super

  showFlexSliderControls: (animationDuration = 1000) ->
    @flexNav.show(animationDuration)

  hideFlexSliderControls: (animationDuration = 750) ->
    @flexNav.hide(animationDuration)

  showLinkBox: (animationDuration = 1000) ->
    @linkBox.show(animationDuration)

  hideLinkBox: (animationDuration = 750) ->
    @linkBox.hide(animationDuration)

  isOpen: ->
    @el.hasClass("open")


class window.AlfredMueller.Views.ServicesSlider extends Backbone.View

  events:
    "click .rent-slide": "handleRentClick"
    "click .sale-slide": "handleSaleClick"
    "click .build-slide": "handleBuildClick"

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
