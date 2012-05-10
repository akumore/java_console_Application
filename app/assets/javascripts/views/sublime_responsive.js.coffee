class window.AlfredMueller.Views.SublimeResponsive extends Backbone.View

  initialize: ->

    # Prevents some flickering
    @el.css("visibility", "hidden");

    # Fluid column video is inside of
    @parent = @el.parent()
    @aspectRatio = 2 # 2:1

    $(window).resize @handleWindowResize

    # when the resources are ready, load up video and resize correctly
    sublimevideo.ready =>
      sublimevideo.prepare(@el.get(0))
      @handleWindowResize()


  handleWindowResize: =>
    newWidth = @parent.width()
    newHeight = newWidth / @aspectRatio
    sublimevideo.resize(@el.get(0), newWidth, newHeight)
