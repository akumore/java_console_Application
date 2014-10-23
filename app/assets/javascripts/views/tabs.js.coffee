class window.AlfredMueller.Views.Tabs extends Backbone.View

  events:
    'click .tabs-navigation li' : 'handleClick'

  initialize: ->
    @navigation = @el.find('.tabs-navigation')
    @navigationItems = @navigation.find('li')
    @contentItems = @el.find('.tabs-content .content')

  handleClick: (event) ->
    makeActive($(event.target))

  makeActive: (link) ->
    @deactivateAll()
    link.parent().addClass('selected')
    @activateContent(link.attr('href'))

  deactivateAll: ->
    @navigationItems.removeClass('selected')
    @contentItems.removeClass('active')

  handleClick: (event) ->
    @makeActive($(event.target))
    event.preventDefault()

  activateContent: (id) ->
    $(id).addClass('active')
    $(id).find('.flexslider').resize()
