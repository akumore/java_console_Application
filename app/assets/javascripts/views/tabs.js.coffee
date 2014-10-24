class window.AlfredMueller.Views.Tabs extends Backbone.View

  events:
    'click .tabs-navigation li' : 'handleClick'

  initialize: ->
    @navigationItems = @el.find('.tabs-navigation li')
    @contentItems = @el.find('.tabs-content .content')
    @initiallyOpenTab()

  initiallyOpenTab: ->
    if window.location.hash.indexOf('tab-')
      h = window.location.hash.replace('tab-', '')
      linkItem = $('a[href=' + h + ']')
      $(linkItem).click()

  makeActive: (link) ->
    @deactivateAll()
    link.parent().addClass('selected')
    @activateContent(link.attr('href'))

  deactivateAll: ->
    @navigationItems.removeClass('selected')
    @contentItems.removeClass('active')

  handleClick: (event) ->
    event.preventDefault()
    target = $(event.target)
    @makeActive(target)
    window.location.hash = 'tab-' + target.attr('href').replace('#', '')

  activateContent: (id) ->
    $(id).addClass('active')
    $(id).find('.flexslider').resize()
