class window.AlfredMueller.Views.TabSlider extends Backbone.View

  events:
    "click .first-level-navigation a" : "handleClick"

  initialize: ->
    @links    = []
    @contents = _.map @el.find(".first-level-navigation a"), (link) =>
      link    = $(link)
      @links.push(link)
      contentElement = $(link.attr("href"))
      content = new AlfredMueller.Views.TabSliderContent(el: contentElement, link: link)
      link.data('tab_slider_content', content)
      content

    activeLink = _.find @links, (link) ->
      link.hasClass("active")

    @activate activeLink.data("tab_slider_content")



  activate: (tabSliderContent) ->
    disabled = _.reject @contents, (content) ->
      content == tabSliderContent

    _.invoke disabled, "deactivate"
    tabSliderContent.activate()

  handleClick: (event) =>
    @activate($(event.target).data("tab_slider_content"))
    return false
