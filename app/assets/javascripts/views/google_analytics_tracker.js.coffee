class window.AlfredMueller.Views.GoogleAnalyticsTracker extends Backbone.View

  events:
    "click" : "handleClick"

  initialize: ->
    @el.attr('data-ga-action')
    @category = @el.attr('data-ga-category')
    @action = @el.attr('data-ga-action')
    @label = @el.attr('data-ga-label')

  handleClick: ->
    if @el.is('input')
      @handleSubmit()
    else
      @handleLink()

  handleSubmit: ->
    $(document).bind "ajaxSuccess", (data, status, xhr) =>
      ga "send", "event", @category, @action, @label

  handleLink: ->
    ga "send", "event", @category, @action, @label
