class window.AlfredMueller.Views.GoogleAnalyticsTracker extends Backbone.View

  initialize: ->
    @category = @el.attr('data-ga-category')
    @action = @el.attr('data-ga-action')
    @label = @el.attr('data-ga-label')
    @trackEvent()

  trackEvent: ->
    ga "send", "event", @category, @action, @label
