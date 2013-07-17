class window.AlfredMueller.Views.SublimeVideo extends Backbone.View

  @addVideo: (sublime_responsive) ->
    @videos ||= []
    @videos.push sublime_responsive

  @ready: ->
    # when the resources are ready, load up video and resize correctly
    sublime.ready =>
      for video in @videos
        sublimevideo.prepare(video.getVideo())
        video.handleWindowResize()

        # Google Analytics Integration
        id = $(video.getVideo()).attr('id')
        sublime.player(id).on
          start: trackVideoStart
          end: trackVideoEnd

  initialize: ->
    # Prevents some flickering
    @el.css("visibility", "hidden");

    # Fluid column video is inside of
    @parent = @el.parent()
    @aspectRatio = 2 # 2:1

    $(window).resize @handleWindowResize
    @parent.bind 'activate', @handleWindowResize

    AlfredMueller.Views.SublimeVideo.addVideo(@)

  getVideo: ->
    @el.get(0)

  handleWindowResize: =>
    newWidth = @parent.width()
    newHeight = newWidth / @aspectRatio
    if sublimevideo.resize
      sublimevideo.resize(@getVideo(), newWidth, newHeight)

  # Google Analytics Integration
  trackVideoStart = (player) ->
    ga "send", "event", 'Video', 'Gestartet', videoName(player)

  trackVideoEnd = (player) ->
    ga "send", "event", 'Video', 'Beendet', videoName(player)

  videoName = (player) ->
    player.videoElement().getAttribute "title"
