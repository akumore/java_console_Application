class window.AlfredMueller.Views.GoogleAnalyticsTracker extends Backbone.View

  events:
    "click" : "handleClick"

  initialize: ->
    @category = @el.attr('data-ga-category')
    @action = @el.attr('data-ga-action')
    @label = @el.attr('data-ga-label')

  handleClick: ->
    ga "send", "event", @category, @action, @label
